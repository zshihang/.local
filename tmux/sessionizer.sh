#!/bin/bash
dirs_shallow=$(tmux show -gv @sessionizer-dirs)
dirs_deep=$(tmux show -gv @sessionizer-dirs-deep)
flags=$(tmux show -gv @sessionizer-fd-flags)
hist=$(tmux show -gv @sessionizer-history)

# 1. Tac history
if [[ -f "$hist" ]]; then
    tac "$hist" | head -n 50
fi

# 2. Local shallow search
if [[ -n "$dirs_shallow" ]]; then
    fd --type d --max-depth 1 $flags . $dirs_shallow 2>/dev/null
fi

# 3. Cloud smart search
if [[ -n "$dirs_deep" ]]; then
    fd --type d --max-depth 1 $flags . $dirs_deep 2>/dev/null | while read -r ws; do
      ws="${ws%/}"
      if [[ -d "$ws/google3" ]]; then
        echo "$ws/google3"
      else
        fd --type d --max-depth 1 $flags . "$ws" 2>/dev/null
      fi
    done
fi
