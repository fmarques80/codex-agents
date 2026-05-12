#!/usr/bin/env bash
set -e

REPO_DIR="$HOME/codex-agents"
CODEX_DIR="$HOME/.codex"

cd "$REPO_DIR"

echo "Copiando somente itens já rastreados no repo..."

git ls-files | while read -r file; do
  if [ -e "$CODEX_DIR/$file" ]; then
    mkdir -p "$(dirname "$REPO_DIR/$file")"
    cp -a "$CODEX_DIR/$file" "$REPO_DIR/$file"
    echo "Atualizado: $file"
  fi
done

echo "Copiando exceção: config.toml"

if [ -f "$CODEX_DIR/config.toml" ]; then
  cp -a "$CODEX_DIR/config.toml" "$REPO_DIR/config.toml"
fi

echo
git status --short

if git diff --quiet; then
  echo "Nada para commitar."
  exit 0
fi

git add .
MSG="Atualiza Codex em $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$MSG"
git push
