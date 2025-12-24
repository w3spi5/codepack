## 2024-01-01 - Broken sed pipe causing data loss
**Learning:** `sed 's// /g'` (empty regex) causes exit code 1 and silent data loss in pipes on some Bash versions; `tr` should be used for simple character filtering.
**Action:** Always check exit codes of commands in pipes or use safer alternatives like `tr`.
