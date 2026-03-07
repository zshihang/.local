#!/bin/bash
# Google-specific discovery provider

dirs_shallow=$(tmux show -gv @sessionizer-dirs)
dirs_deep=$(tmux show -gv @sessionizer-dirs-deep)
flags=$(tmux show -gv @sessionizer-fd-flags)

# Generate a list of roots to exclude (exact matches)
roots=$(echo "$dirs_shallow $dirs_deep" | tr ' ' '\n' | sed 's|/$||')

# Function to filter out roots from fd output
filter_roots() {
    while read -r line; do
        clean_line="${line%/}"
        match=0
        while read -r root; do
            if [[ "$clean_line" == "$root" ]]; then
                match=1
                break
            fi
        done <<< "$roots"
        [[ $match -eq 0 ]] && echo "$line"
    done
}

# 1. Shallow search for local dirs
if [[ -n "$dirs_shallow" ]]; then
    fd --type d --max-depth 1 $flags . $dirs_shallow 2>/dev/null | filter_roots
fi

# 2. Deep smart search for cloud/monorepos
if [[ -n "$dirs_deep" ]]; then
    fd --type d --max-depth 1 $flags . $dirs_deep 2>/dev/null | while read -r ws; do
      ws="${ws%/}"
      if [[ -d "$ws/google3" ]]; then
        echo "$ws/google3"
      else
        fd --type d --max-depth 1 $flags . "$ws" 2>/dev/null | filter_roots
      fi
    done
fi
