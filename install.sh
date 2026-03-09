#!/usr/bin/env bash

# This script is sourced by .xxxxx/install.sh
# It contains Google-specific or machine-specific setup.

install_roadwarrior_macos() {
  if command_exists roadwarrior || command_exists rw; then
    info "roadwarrior already installed"
    return
  fi
  info "Installing roadwarrior for macOS..."
  if command_exists mule; then
    sudo mule install roadwarrior || warn "mule install roadwarrior failed"
  else
    warn "mule not found, skipping roadwarrior install"
  fi
}

if [[ "$OS" == "macos" ]]; then
  install_roadwarrior_macos
fi
