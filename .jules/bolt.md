This is a placeholder for .jules/bolt.md
## 2025-12-22 - [Buggy sed pipeline]
**Learning:** `sed 's// /g'` (empty regex) causes exit code 1 on some platforms and silent data loss in pipes.
**Action:** Always verify `sed` syntax and prefer `tr` for simple character filtering to avoid process overhead and portability issues.
