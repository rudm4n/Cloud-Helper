#!/bin/bash
# apply-hf-patches.sh
# Applies Hugging Face Spaces-specific modifications on top of upstream EasyProxy code.
# This script is idempotent — safe to run multiple times.

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "=== Applying HF Spaces patches ==="

# ─────────────────────────────────────────────
# 1. README.md — prepend HF YAML frontmatter
# ─────────────────────────────────────────────
echo "[1/2] Adding HF YAML frontmatter to README..."
if ! head -1 README.md | grep -q "^---"; then
  ORIGINAL=$(cat README.md)
  cat > README.md << 'YAMLHEADER'
---
title: TVCasa2025
emoji: 📺
colorFrom: blue
colorTo: green
sdk: docker
app_port: 7860
pinned: false
---

YAMLHEADER
  echo "$ORIGINAL" >> README.md
else
  echo "  (already has YAML frontmatter, skipping)"
fi

# ─────────────────────────────────────────────
# 2. .gitignore / .dockerignore — ensure .git excluded from Docker
# ─────────────────────────────────────────────
echo "[2/2] Ensuring .git is excluded from Docker context..."
if [ -f .dockerignore ]; then
  if ! grep -q "^\.git$" .dockerignore; then
    echo ".git" >> .dockerignore
  fi
else
  echo ".git" > .dockerignore
fi

echo "=== HF patches applied successfully ==="
