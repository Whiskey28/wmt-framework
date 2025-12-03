package com.wmt.framework.sjb;

import lombok.Data;

import java.io.Serializable;

/**
 * sjb（数据部）平台基础配置
 *
 * <p>
 * 推荐在业务系统的 {@code application-*.yml} 中使用前缀 {@code wmt.sjb} 进行配置，例如：
 *
 * <pre>
 * wmt:
 *   sjb:
 *     url: https://example.com/sjb/gateway
 *     org-id: ax_0002
 *     department: ax_001
 * </pre>
 *
 * 业务系统可以自行通过 Spring Boot 的 {@code @ConfigurationProperties} 进行绑定，
 * 本类本身不强依赖 Spring Boot，只是一个普通的配置 POJO。
 */
@Data
public class SjbProperties implements Serializable {

    /**
     * sjb 平台统一网关地址
     *
     * <p>例如：{@code https://example.com/sjb/gateway}</p>
     */
    private String url;

    /**
     * 机构编码，对应 sjb header 中的 {@code orgId}
     */
    private String orgId;

    /**
     * 部门编码，对应 sjb header 中的 {@code department}
     */
    private String department;

}


