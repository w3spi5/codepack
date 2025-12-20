## 2025-12-20 - Unexpected sed behavior in pipes
**Learning:** `sed 's// /g'` without a prior regex fails (exit code 1) on some systems/versions, and when used in a pipe like `cat | sed | tr`, it can cause the pipe to effectively transmit nothing if the failure happens early or in a specific way, leading to silent data loss.
**Action:** Always validate `sed` commands in isolation. Prefer strict filtering (like `tr -cd`) over ambiguous replacement when sanitizing data. Avoid unnecessary pipes to prevent masking errors.
