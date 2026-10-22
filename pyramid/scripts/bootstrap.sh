#!/usr/bin/env bash
# 세션 피라미드를 새 워크스페이스에 펼친다. git 초기화 · 원격 생성은 하지 않는다(사람이 확인 후 한다).
# 사용: bootstrap.sh <WORKSPACE_ROOT> <SLUG> <PROJECT_NAME> <role...>
#   LEAD_ONLY_ROLES="lab"  → 그 역할에는 lead 에이전트만 둔다
set -euo pipefail
[[ $# -ge 4 ]] || { echo "사용: bootstrap.sh <WORKSPACE_ROOT> <SLUG> <PROJECT_NAME> <role...>" >&2; exit 64; }
root="$(realpath -m "$1")"; slug="$2"; pname="$3"; shift 3; roles=("$@")
tpl="$(cd "$(dirname "$0")/../.." && pwd)"; py="$tpl/pyramid"
if [[ -d "$root" && -n "$(ls -A "$root")" ]]; then echo "중단: $root 가 비어 있지 않다" >&2; exit 1; fi
mkdir -p "$root/project-docs/conventions" "$root/project-docs/decisions" "$root/project-docs/scripts"

cp "$py/workspace/CLAUDE.md" "$root/CLAUDE.md"
cp -r "$py/project-docs/." "$root/project-docs/"
cp "$tpl/conventions/code-style.md" "$root/project-docs/conventions/"
cp "$tpl/decisions/template.md" "$tpl/decisions/ADR-000-template.md" "$root/project-docs/decisions/"
for s in journal-gate protect-tests qa-run spawn respawn-all; do cp "$py/scripts/$s.sh" "$root/project-docs/scripts/"; done
printf '.claude/worktrees/\n.claude/settings.local.json\n' > "$root/project-docs/.gitignore"

for r in "${roles[@]}"; do
  d="$root/$r"; mkdir -p "$d"; cp -r "$py/repo/." "$d/"
  a="$d/.claude/agents"
  mv "$a/lead.md" "$a/lead-$r.md"; mv "$a/exec.md" "$a/exec-$r.md"; mv "$a/fix.md" "$a/fix-$r.md"
  if [[ " ${LEAD_ONLY_ROLES:-} " == *" $r "* ]]; then rm "$a/exec-$r.md" "$a/fix-$r.md"; fi
  python3 - "$d" "$r" "$slug-$r" <<'PY'
import os, sys
d, role, repo = sys.argv[1:]
for base, dirs, files in os.walk(d):
    dirs[:] = [x for x in dirs if x != ".git"]
    for f in files:
        p = os.path.join(base, f)
        s = open(p, encoding="utf-8").read()
        t = s.replace("{{ROLE}}", role).replace("{{REPO_NAME}}", repo)
        if t != s: open(p, "w", encoding="utf-8").write(t)
PY
done

python3 - "$root" "$slug" "$pname" "${roles[@]}" <<'PY'
import os, sys
root, slug, pname, *roles = sys.argv[1:]
sub = {
    "{{PROJECT_NAME}}": pname, "{{SLUG}}": slug, "{{SLUG_UPPER}}": slug.upper(),
    "{{WORKSPACE_ROOT}}": root, "{{REPO_LIST}}": " · ".join(["project-docs", *roles]),
    "{{ADR_TRACKS}}": " · ".join(["META", *[r.upper() for r in roles]]),
    "{{ROLE_SCOPE}}": "총괄이 첫 지시와 함께 채운다.",
}
for base, dirs, files in os.walk(root):
    dirs[:] = [x for x in dirs if x != ".git"]
    for f in files:
        p = os.path.join(base, f)
        s = open(p, encoding="utf-8").read()
        t = s
        for k, v in sub.items(): t = t.replace(k, v)
        if t != s: open(p, "w", encoding="utf-8").write(t)
PY
chmod +x "$root"/project-docs/scripts/*.sh "$root"/*/scripts/*.sh 2>/dev/null || true
left="$(grep -rn '{{' "$root" --exclude-dir=.git || true)"
[[ -z "$left" ]] && echo "펼침 완료: $root (자리표시자 0건)" || { echo "남은 자리표시자:"; echo "$left"; }
