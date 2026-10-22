#!/usr/bin/env bash
# Stop 훅 — 이 역할이 오늘 커밋했는데 저널이 그 커밋보다 오래됐으면 종료를 막는다.
# 역할은 훅 입력의 agent_type(--agent 이름)으로 정한다. 역할 없는 세션은 통과시킨다.
set -uo pipefail
input="$(cat)"
read -r active role < <(python3 -c 'import json,sys
d=json.load(sys.stdin)
print(d.get("stop_hook_active",False), d.get("agent_type") or "-")' <<<"$input" 2>/dev/null || echo "False -")
[[ "$active" == "True" || "$role" == "-" ]] && exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
docs="$(cd "$(dirname "$0")/.." && pwd)"
journal="$docs/work-journal/$(date +%Y)/$(date +%m)/$(date +%Y%m%d)-$role.md"
last="$(git log --since=midnight --grep="^Agent-Session: project-.*-$role\$" --format=%ct -1 2>/dev/null)"
[[ -z "$last" ]] && exit 0
if [[ -f "$journal" && "$(stat -c %Y "$journal")" -ge "$last" ]]; then exit 0; fi
python3 -c 'import json,sys
print(json.dumps({"decision":"block","reason":f"오늘 커밋한 작업의 저널이 없거나 커밋보다 오래됐다. {sys.argv[1]} 에 절을 덧붙인 뒤 끝낸다 (형식: project-docs/work-journal/README.md)."},ensure_ascii=False))' "$journal"
