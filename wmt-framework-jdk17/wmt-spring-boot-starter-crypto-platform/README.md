# wmt-spring-boot-starter-crypto-platform

内蒙古银行 **加密平台（Union CSSP）** Spring Boot Starter。

## 职责边界

| 场景 | 是否用本 Starter |
|------|------------------|
| 密钥同步后导入 PIK/MAK 到 HSM（`servE112`） | ✅ |
| 删除密钥（`servE116`） | ✅ |
| 日常联盟业务 MAC（Body `KeyInd` → ESB 算 MAC） | ❌ 用 ESB，不要在热路径调本组件 |
| 行内 LRMS / IFBS 等 | ❌ 不需要 |

## 依赖

- 行方 `example-basic-services-3.8.204.jar`（自包含 UnionCSSP + core）
- `bcprov-jdk18on` / `bcpkix-jdk18on` **1.80**

首次构建前安装 vendor jar：

```bash
cd wmt-framework-jdk17/wmt-spring-boot-starter-crypto-platform
./scripts/install-union-sdk.sh
```

## 配置

```yaml
wmt:
  crypto-platform:
    enabled: true
    config-file: /opt/dmpf/crypto/serverList.conf
    fail-on-config-error: true
```

`serverList.conf` 模板见 `src/main/resources/crypto-platform/serverList.conf.example`。

## 使用

```java
@Resource
private CryptoPlatformKeyService cryptoPlatformKeyService;

public void afterEsbKeySync(String keyName, String keyValueHex) {
    cryptoPlatformKeyService.importSymmetricKeyByLmkOrThrow(keyName, keyValueHex);
}
```

## 版本

| 组件 | 版本 |
|------|------|
| example-basic-services | 3.8.204 |
| BouncyCastle jdk18on | 1.80 |
