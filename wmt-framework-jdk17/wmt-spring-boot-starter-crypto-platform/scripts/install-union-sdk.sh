#!/usr/bin/env bash
# 将行方交付的 example-basic-services jar 安装到本地 Maven 仓库。
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JAR="${ROOT}/lib/example-basic-services-3.8.204.jar"
DEFAULT_SRC="${UNION_SDK_JAR:-}"
if [[ -z "${DEFAULT_SRC}" ]]; then
  CANDIDATES=(
    "/Users/whiskey/Projects/CodeUp/ahzx-boim-svc/docs/nm-deliver/raw/接口文档材料/esb及相关/加密平台api新-20250422/example-basic-services-3.8.204.jar"
  )
  for c in "${CANDIDATES[@]}"; do
    if [[ -f "${c}" ]]; then DEFAULT_SRC="${c}"; break; fi
  done
fi
if [[ ! -f "${JAR}" && -n "${DEFAULT_SRC}" && -f "${DEFAULT_SRC}" ]]; then
  mkdir -p "${ROOT}/lib"
  cp "${DEFAULT_SRC}" "${JAR}"
  echo "已从交付目录拷贝: ${DEFAULT_SRC}"
fi
if [[ ! -f "${JAR}" ]]; then
  echo "缺少 vendor jar: ${JAR}"
  echo "请将行方 example-basic-services-3.8.204.jar 放入 lib/，或设置 UNION_SDK_JAR"
  exit 1
fi
mvn install:install-file \
  -Dfile="${JAR}" \
  -DgroupId=com.union \
  -DartifactId=example-basic-services \
  -Dversion=3.8.204 \
  -Dpackaging=jar
echo "已安装 com.union:example-basic-services:3.8.204"
