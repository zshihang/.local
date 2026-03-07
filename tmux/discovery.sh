#!/bin/bash
# Google-specific discovery provider

dirs_shallow=$(tmux show -gv @sessionizer-dirs)
dirs_deep=$(tmux show -gv @sessionizer-dirs-deep)
flags=$(tmux show -gv @sessionizer-fd-flags)

# Shallow search for local dirs
if [[ -n "$dirs_shallow" ]]; then
    fd --type d --max-depth 1 $flags . $dirs_shallow 2>/dev/null
fi

# Deep smart search for cloud/monorepos
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
