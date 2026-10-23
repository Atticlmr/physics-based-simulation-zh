#!/usr/bin/env bash
# 重新构建中文版并把 HTML 推送到 gh-pages 分支（GitHub Pages 自动更新）
set -euo pipefail
cd "$(dirname "$0")"

origin="$(git remote get-url origin)"
./build.sh

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cp -a book/. "$tmp/"
cd "$tmp"
touch .nojekyll
git init -q -b gh-pages
git add -A
git commit -q -m "deploy: $(date '+%Y-%m-%d %H:%M:%S')"
git push -f "$origin" gh-pages
echo "已推送 gh-pages，稍等片刻即可在 Pages 上看到更新。"
