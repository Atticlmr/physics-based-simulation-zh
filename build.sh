#!/usr/bin/env bash
# 构建中文版《基于物理的仿真》HTML 电子书
set -euo pipefail
cd "$(dirname "$0")"

export PATH="${HOME}/.cargo/bin:${PATH}"

for bin in mdbook mdbook-katex mdbook-numeq mdbook-numthm mdbook-bib; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "缺少 $bin，请先按 README.md 中的说明安装 mdBook 及插件。" >&2
    exit 1
  fi
done

mdbook build
echo
echo "构建完成：$(pwd)/book/index.html"
