## 2025-12-21 - [Bash Pipeline Optimization]
**Learning:** Avoid useless pipes like `cat | sed`. Using input redirection `tr < file` saved 2 process forks per file and fixed a data loss bug caused by `sed 's// /g'`.
**Action:** Always prefer redirection over `cat` for single file inputs.
