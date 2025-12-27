## 2024-05-23 - Broken sed pipeline causing data loss
**Learning:** The command `sed 's// /g'` is invalid because of an empty regex and causes `sed` to fail. When used in a pipeline like `cat | sed | tr`, if `sed` fails, the downstream `tr` receives nothing, resulting in empty content for all files. Additionally, `cat file | ...` is an inefficient pattern (useless use of cat).
**Action:** Replace `cat file | sed ... | tr ...` with direct redirection `tr ... < file`. Always verify pipeline components individually to ensure they don't fail silently with `2>/dev/null`.
