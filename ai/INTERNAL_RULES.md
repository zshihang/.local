# Google Internal Engineering Rules

## Tooling & Standards
- **Build System:** Use `blaze` exclusively. Never use `bazel`.
- **Version Control:** Prefer `jj` with the `google` extension. For Piper, use `g4`.
- **Code Search:** Use `cs` or semantic search tools when available.
- **Review:** Use `critique` (cl/XXXXX) for all code reviews.

## Workflow
- **CL Lifecycle:** Always include a BUG= and TEST= tag in CL descriptions.
- **Syncing:** In Git-on-Borg repos, sync via `jj git fetch` and `jj rebase -d main@origin`.
- **Gerrit:** Always preserve the `Change-Id:` footer in commit messages.
