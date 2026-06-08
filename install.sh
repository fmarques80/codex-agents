#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_DIR="$HOME/.codex"
SYNC_DIRS=(
  "agents"
  "rules"
  "playbooks"
)

sync_dir() {
  local source_dir="$1"
  local target_dir="$2"

  mkdir -p "$target_dir"

  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "$source_dir/" "$target_dir/"
    return
  fi

  find "$target_dir" -mindepth 1 -delete
  cp -a "$source_dir/." "$target_dir/"
}

mkdir -p "$CODEX_DIR"

cp "$REPO_DIR/AGENTS.md" "$CODEX_DIR/"

for dir in "${SYNC_DIRS[@]}"; do
  sync_dir "$REPO_DIR/$dir" "$CODEX_DIR/$dir"
done

echo "Codex governance instalada."
