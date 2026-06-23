# wmt-spring-boot-starter-partner-http

伙伴 HTTP 出站客户端与凭证预加载（`wmt.partner.apps` → Redis）。

**当前状态：未纳入构建。** `wmt-framework-jdk17/pom.xml` 与 BOM 中已注释本模块，待下一版组件库发布后再启用。

业务侧若仅需入站验签，使用 `wmt-spring-boot-starter-protection` 的 `@ApiSignature` 即可。
