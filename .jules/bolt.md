## 2025-12-23 - Broken sed pipeline caused data loss
**Learning:** The command `sed 's// /g'` with an empty pattern is invalid and exits with code 1. When used in a pipe `cat | sed | tr` where stderr is redirected to `/dev/null`, it silently fails and breaks the pipe, resulting in empty output.
**Action:** Always verify regex patterns in `sed`. Use `tr` for simple character replacements. Avoid suppressing stderr blindly when debugging critical data pipelines.
