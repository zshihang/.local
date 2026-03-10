#!/usr/bin/env bash

# Google-specific installation logic

# Add Google-internal release paths to the tool existence check
EXTRA_TOOL_PATHS=(
  "/google/bin/releases/%tool%-cli/tools/%tool%"
  "/google/bin/releases/%tool%/tools/%tool%"
)

info "Google-specific setup loaded."
