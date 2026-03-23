#!/bin/bash
# .local/tmux/.config/tmux/scripts/local_discovery.sh (Google-specific)

dirs_deep=$(tmux show -gv @sessionizer-dirs-deep)
dirs_shallow=$(tmux show -gv @sessionizer-dirs)

# 1. Cloud smart search (CITC / google3)
# Optimized for remote network filesystems
if [[ -n "$dirs_deep" ]]; then
    for base_dir in $dirs_deep; do
        find "$base_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while read -r ws; do
            ws="${ws%/}"
            
            # Skip export directories, g3doc temp workspaces, and install temp workspaces
            [[ "$ws" == *-export-* ]] && continue
            [[ "$ws" == */G3DOC-* ]] && continue
            [[ "$ws" == *-install-* ]] && continue
            
            if [[ -d "$ws/google3" ]]; then
                echo "$ws/google3"
            else
                echo "$ws"
            fi
        done
    done
fi

# 2. Emit nested roots to bypass the generic filter_roots in sessionizer.sh
# Any shallow root that is a subdirectory of another root is treated as a "visible container".
# This allows directories like 'google' and 'quantum' to show up even if they are listed as roots.
for root in $dirs_shallow; do
    for parent in $dirs_shallow; do
        if [[ "$root" == "$parent"/* ]]; then
            echo "$root"
            break
        fi
    done
done
