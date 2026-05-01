#!/usr/bin/env bash
# janitor.sh: Find and report resource-heavy orphaned processes

info() { printf '\033[1;34m%s\033[0m\n' "$*"; }

info "--- Top 10 Memory Consumers ---"
ps -eo pid,ppid,user,%mem,rss,comm --sort=-%mem | head -n 11 | awk '{print $0 " (" $5/1024 " MB)"}'

info "\n--- Likely 'Ghost' Processes (Orphaned/LSPs) ---"
# Find common leakers that are children of PID 1 (orphaned)
# We specifically look for connectd, gopls, and node/gemini agents
ghosts=$(ps -eo pid,ppid,comm,etime | grep -E "gopls|rust-analyzer|node|connectd" | awk '$2 == 1 {print $1}')

if [[ -n "$ghosts" ]]; then
    echo "Found $(echo "$ghosts" | wc -w) orphaned background processes:"
    ps -p $ghosts -o pid,user,%mem,%cpu,etime,comm | awk 'NR>1'
    echo -e "\nTo kill all ghosts: ps -eo pid,ppid,comm | grep -E 'gopls|rust-analyzer|node|connectd' | awk '\$2 == 1 {print \$1}' | xargs kill -9"
else
    echo "No obvious ghost processes found."
fi

info "\n--- Tmux Sessions ---"
tmux list-sessions 2>/dev/null || echo "No tmux sessions running."
