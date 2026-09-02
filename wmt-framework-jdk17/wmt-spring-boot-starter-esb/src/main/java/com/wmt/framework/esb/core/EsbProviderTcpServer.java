package com.wmt.framework.esb.core;

import com.wmt.framework.esb.config.EsbProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * ESB 标准接出（提供方）：TCP 同步短连接 + 长度头 + XML Body。
 */
@Slf4j
public class EsbProviderTcpServer {

    private final int port;
    private final int backlog;
    private final int soTimeoutMs;
    private final int lengthHeaderSize;
    private final Charset charset;
    private final int maxBodyBytes;
    private final EsbProviderRouter router;
    private final ExecutorService workerPool;
    private final AtomicBoolean running = new AtomicBoolean(false);

    private ServerSocket serverSocket;
    private Thread acceptThread;

    public EsbProviderTcpServer(EsbProperties esbProperties, EsbProviderRouter router) {
        EsbProperties.Provider provider = esbProperties.getProvider();
        this.port = provider.getPort();
        this.backlog = provider.getBacklog();
        this.soTimeoutMs = provider.getSoTimeoutMs();
        this.lengthHeaderSize = esbProperties.getLengthHeaderSize() > 0
                ? esbProperties.getLengthHeaderSize() : 8;
        this.charset = esbProperties.getCharset() != null
                ? esbProperties.getCharset() : StandardCharsets.UTF_8;
        this.maxBodyBytes = esbProperties.getMaxBodyBytes() > 0
                ? esbProperties.getMaxBodyBytes() : 102400;
        this.router = router;
        int workerThreads = Math.max(provider.getWorkerThreads(), 1);
        this.workerPool = Executors.newFixedThreadPool(workerThreads, r -> {
            Thread t = new Thread(r, "esb-provider-worker");
            t.setDaemon(true);
            return t;
        });
    }

    public synchronized void start() throws IOException {
        if (running.get()) {
            return;
        }
        serverSocket = new ServerSocket(port, backlog);
        running.set(true);
        acceptThread = new Thread(this::acceptLoop, "esb-provider-accept");
        acceptThread.setDaemon(true);
        acceptThread.start();
        log.info("[esb-provider] TCP 监听已启动 port={} routes={}", port, router.registeredRouteCount());
    }

    private void acceptLoop() {
        while (running.get()) {
            try {
                Socket socket = serverSocket.accept();
                workerPool.execute(() -> handleConnection(socket));
            } catch (IOException ex) {
                if (running.get()) {
                    log.warn("[esb-provider] accept 失败: {}", ex.toString());
                }
            }
        }
    }

    private void handleConnection(Socket socket) {
        try (socket) {
            socket.setSoTimeout(soTimeoutMs);
            InputStream in = socket.getInputStream();
            OutputStream out = socket.getOutputStream();
            String requestXml = readFrame(in);
            if (!StringUtils.hasText(requestXml)) {
                log.warn("[esb-provider] 空请求，关闭连接 remote={}", socket.getRemoteSocketAddress());
                return;
            }
            log.debug("[esb-provider] 收到请求 length={} remote={}",
                    requestXml.length(), socket.getRemoteSocketAddress());
            String responseXml = router.dispatch(requestXml);
            writeFrame(out, responseXml);
        } catch (SocketTimeoutException ex) {
            log.warn("[esb-provider] 读超时 remote={}", socket.getRemoteSocketAddress());
        } catch (Exception ex) {
            log.error("[esb-provider] 连接处理异常 remote={}", socket.getRemoteSocketAddress(), ex);
        }
    }

    private String readFrame(InputStream in) throws IOException {
        String headerText = EsbTcpTransport.readFixedHeader(in, lengthHeaderSize, charset);
        int bodyLength;
        try {
            bodyLength = EsbTcpTransport.parseLengthHeader(headerText);
        } catch (RuntimeException ex) {
            throw new IOException("非法长度头: " + headerText, ex);
        }
        if (bodyLength <= 0 || bodyLength > maxBodyBytes) {
            throw new IOException("报文长度越界: " + bodyLength);
        }
        byte[] body = EsbTcpTransport.readFully(in, bodyLength);
        return new String(body, charset);
    }

    private void writeFrame(OutputStream out, String xml) throws IOException {
        byte[] body = xml.getBytes(charset);
        if (body.length > maxBodyBytes) {
            throw new IOException("响应超长: " + body.length);
        }
        String header = String.format("%0" + lengthHeaderSize + "d", body.length);
        if (header.length() != lengthHeaderSize) {
            throw new IOException("响应长度超出长度头可表示范围: " + body.length);
        }
        out.write(header.getBytes(charset));
        out.write(body);
        out.flush();
    }

    public synchronized void stop() {
        running.set(false);
        if (serverSocket != null && !serverSocket.isClosed()) {
            try {
                serverSocket.close();
            } catch (IOException ignored) {
                // ignore
            }
        }
        workerPool.shutdownNow();
        try {
            workerPool.awaitTermination(3, TimeUnit.SECONDS);
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
        }
        log.info("[esb-provider] TCP 监听已停止 port={}", port);
    }

    public int getPort() {
        return port;
    }

    public boolean isRunning() {
        return running.get();
    }

}
