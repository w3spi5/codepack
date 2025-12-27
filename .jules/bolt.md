## 2025-12-21 - [Bash Pipeline Optimization]
**Learning:** Avoid useless pipes like `cat | sed`. Using input redirection `tr < file` saved 2 process forks per file and fixed a data loss bug caused by `sed 's// /g'`.
**Action:** Always prefer redirection over `cat` for single file inputs.
## 2025-12-20 - Unexpected sed behavior in pipes
**Learning:** `sed 's// /g'` without a prior regex fails (exit code 1) on some systems/versions, and when used in a pipe like `cat | sed | tr`, it can cause the pipe to effectively transmit nothing if the failure happens early or in a specific way, leading to silent data loss.
**Action:** Always validate `sed` commands in isolation. Prefer strict filtering (like `tr -cd`) over ambiguous replacement when sanitizing data. Avoid unnecessary pipes to prevent masking errors.
## 2025-12-18 - [Bash Filtering Bottleneck & Subshell Overhead]
**Learning:** Offloading file filtering logic from a Bash loop to `find` predicates drastically reduces overhead, especially when combined with removing unnecessary subshells (like `cat | sed | tr`). In this codebase, moving filtering to `find` and removing a broken `sed` command not only improved performance but also fixed a critical data loss bug where `sed` failure resulted in empty content.
**Action:** When working with file processing scripts in Bash, always maximize the use of `find`'s native filtering capabilities before iterating in a loop, and audit pipelines for potential failure points that might fail silently with `2>/dev/null`.
