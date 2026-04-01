#!/usr/bin/env bash

# Local overrides for Gemini hooks.
# This script intercepts AfterTool events to prioritize Google-specific tooling (g4/hg/jj fix)
# when working within google3.

hook_override() {
  local _hook_name="$1" # Reserved for future granular overrides
  local type="$2"       # "run" or "check"
  shift 2

  # Only override if in google3
  if [[ "$HOOK_FILE" != *"/google3/"* ]]; then
    return 1 # Fall back to default
  fi

  # Run the central google3cleaner.sh for ALL file types in google3.
  # It handles g4/hg/jj fix and build_cleaner.
  local cleaner="/google/src/files/head/depot/google3/coresystems/sre/prodai/gemini_cli/superpowers/hooks/google3cleaner.sh"
  local validator="/google/src/files/head/depot/google3/coresystems/sre/prodai/gemini_cli/superpowers/hooks/skill-validator.py"

  if [[ "$(basename "$HOOK_FILE")" == "SKILL.md" && -f "$validator" ]]; then
    echo "$HOOK_INPUT" | python3 "$validator"
  fi
  local validator="/google/src/files/head/depot/google3/coresystems/sre/prodai/gemini_cli/superpowers/hooks/skill-validator.py"

  # If this is a SKILL.md file, run the validator manually since the central hook is broken (.sh vs .py)
  if [[ "$(basename "$HOOK_FILE")" == "SKILL.md" && -f "$validator" ]]; then
    echo "$HOOK_INPUT" | python3 "$validator"
  fi

  if [[ -f "$cleaner" ]]; then
    echo "$HOOK_INPUT" | "$cleaner"
    # We exit 0 here because google3cleaner handled formatting/vcs.
    # For some languages, we might still want to run local checkers (hook_check),
    # but for formatters (hook_run), we are done.
    if [[ "$type" == "run" ]]; then
      return 0
    else
      # For checks (like ty check), let them fall through after cleaning
      return 1
    fi
  fi

  return 1 # Fall back if cleaner not found
}
