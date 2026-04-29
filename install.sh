#!/usr/bin/env bash

# Google-specific installation logic

# Add Google-internal release paths to the tool existence check
EXTRA_TOOL_PATHS=(
  "/google/bin/releases/%tool%-cli/tools/%tool%"
  "/google/bin/releases/%tool%/tools/%tool%"
)

# Jetski setup
mkdir -p ~/.gemini/jetski/rules ~/.gemini/jetski/skills

# Rules
ln -sf /usr/local/google/home/zshihang/workspace/dotfiles/.xxxxx/ai/RULES.md ~/.gemini/jetski/rules/rules.md
ln -sf /usr/local/google/home/zshihang/workspace/dotfiles/.xxxxx/ai/SOUL.md ~/.gemini/jetski/rules/soul.md
ln -sf /usr/local/google/home/zshihang/workspace/dotfiles/.local/ai/RULES.local.md ~/.gemini/jetski/rules/local_rules.md
ln -sf /usr/local/google/home/zshihang/workspace/dotfiles/.local/ai/INTERNAL_RULES.md ~/.gemini/jetski/rules/internal_rules.md

# Skills
for d in /usr/local/google/home/zshihang/workspace/dotfiles/.xxxxx/ai/skills/*; do
  if [ -d "$d" ]; then
    ln -sf "$d" ~/.gemini/jetski/skills/
  fi
done

# Memory tuning (Linux only)
if [[ "$(uname -s)" == "Linux" ]]; then
  info "Applying memory tuning (swappiness=10, vfs_cache_pressure=50)..."
  sudo sysctl vm.swappiness=10
  sudo sysctl vm.vfs_cache_pressure=50
  echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-memory-tuning.conf >/dev/null
  echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.d/99-memory-tuning.conf >/dev/null
fi

info "Google-specific setup loaded."
