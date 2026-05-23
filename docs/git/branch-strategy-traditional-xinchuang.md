# Git 分支策略：传统线（main）与信创线（各走各的）

> 最后更新：2026-05-23  
> 目标：传统分支维护 Tomcat JDK8/JDK17 + ProGuard；信创分支仅 JDK17 + TongWeb + ProGuard，互不 merge 回 main。

## 分支模型

```text
main（传统线）
├── wmt-framework          → JDK 8 + Tomcat + ProGuard
└── wmt-framework-jdk17    → JDK 17 + Tomcat + ProGuard

xinchuang/tongweb（信创线）
└── wmt-framework-jdk17    → JDK 17 + TongWeb + ProGuard
    （不维护 JDK 8 树）
```

| | **main（传统）** | **xinchuang/tongweb（信创）** |
|--|------------------|-------------------------------|
| JDK 8 | ✅ Tomcat + ProGuard | ❌ 删除整树 |
| JDK 17 | ✅ Tomcat + ProGuard | ✅ TongWeb + ProGuard |
| 信创 → main | ❌ 永不整支合并 | — |
| main → 信创 | — | ✅ 可选（同步 bugfix / ProGuard 规则） |

发版 Tag 建议：

```text
v2025.12-tomcat-jdk8
v2025.12-tomcat-jdk17
v2025.12-tongweb-jdk17
```

---

## 文件清单

### A. main（传统线）— ProGuard JDK 17

| 操作 | 路径 | 说明 |
|------|------|------|
| 新增 | `docs/proguard/proguard-jdk17-library.conf` | JDK17 库模块规则 |
| 新增 | `docs/proguard/proguard-jdk17-starter.conf` | JDK17 Starter 规则 |
| 新增 | `docs/proguard/README-jdk17.md` | 构建说明 |
| 修改 | `pom.xml` | ProGuard 7.4.2、jmods、插件管理 |
| 修改 | `wmt-framework-jdk17/pom.xml` | `proguard-jar-modules` 自动挂载 |
| 修改 | `wmt-framework-jdk17/wmt-common/pom.xml` | 覆盖为 library 规则 |

**不要与 ProGuard 混在同一 commit：**

- `BannerApplicationRunner.java` / `GlobalExceptionHandler.java`（模块提示清理）
- `docs/后端开发规范-jdk17.md`
- `docs/xinchuang-tongweb/*.pdf`
- `docs/xinchuang-tongweb/TongWeb_Embed/license.dat`（**勿提交**）

### B. 信创分支 — TongWeb + PFB（相对 main 的差异）

见 `git diff main..xinchuang/tongweb`；核心为 `wmt-dependencies-jdk17/pom.xml`、web/websocket starter、PFB 相关 Java 与 `docs/xinchuang-tongweb/`。

### C. 信创分支删除 — JDK 8

删除 `wmt-framework/`、`wmt-dependencies/` 整树。

### D. main 保留 — 双 JDK Tomcat

```bash
# JDK 8
mvn -f wmt-framework/pom.xml clean package -Pobfuscate -DskipTests

# JDK 17（需 JDK 17 作为 Maven 与 ProGuard 引导库）
export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
export PROGUARD_JDK_HOME="$JAVA_HOME"
mvn -f wmt-framework-jdk17/pom.xml clean package -Pobfuscate -DskipTests
```

---

## Git 操作步骤

### 阶段 1：ProGuard 合入 main ✅

已完成：`feat/proguard-jdk17` → merge 至 `main`（见 git log）。

### 阶段 2：整理信创长期分支

```bash
git checkout feat/xinchuang-tongweb-verify
git checkout -b xinchuang/tongweb
git merge feat/pfb-api-c2
git merge main
git rm -r wmt-framework wmt-dependencies
git commit -m "chore(xinchuang): 移除 JDK8，信创线仅保留 JDK17"
```

### 阶段 3：打 Tag

```bash
git tag -a v2025.12-tomcat-jdk17 -m "Tomcat JDK17 + ProGuard"   # on main
git tag -a v2025.12-tongweb-jdk17 -m "TongWeb JDK17 + ProGuard" # on xinchuang
```

---

## 日常协作

| 场景 | 操作 |
|------|------|
| Tomcat bugfix / ProGuard 更新 | **main** 改 → 信创 `merge main` 或 cherry-pick |
| TongWeb / 信创专用 | 仅 **xinchuang/tongweb** |
| 发混淆包 | `-Pobfuscate` + `PROGUARD_JDK_HOME=JDK17` |
