#!/usr/bin/env bash
# 역할 세션을 백그라운드로 띄운다. 이름은 project-{{SLUG}}-{agent}, 원격 제어를 켠다.
# 이미 있는 세션이 쉬고 있으면 같은 대화를 이어서 새 지시를 확인시키고, 작업 중이면 건드리지 않는다.
# 사용: spawn.sh <agent> <dir>    예) spawn.sh lead-server server
set -euo pipefail
[[ $# -eq 2 ]] || { echo "사용: spawn.sh <agent> <dir>" >&2; exit 64; }
agent="$1"; dir="$2"
docs="$(cd "$(dirname "$0")/.." && pwd)"; root="$(dirname "$docs")"
name="project-{{SLUG}}-$agent"
nudge="project-docs/handoff/orders/ 에서 $agent 앞으로 온 미처리 지시를 확인하고 처리한다."
found="$(claude agents --json --all 2>/dev/null | python3 -c 'import json,sys
n=sys.argv[1]; hit=[s for s in json.load(sys.stdin) if s.get("name")==n and s.get("kind")=="background"]
s=hit[-1] if hit else None
print(s.get("state","-"), s.get("sessionId","-")) if s else print("none -")' "$name")"
read -r state sid <<<"$found"
cd "$root/$dir"
case "$state" in
  none) exec claude --bg --agent "$agent" --name "$name" --remote-control "$name" ;;
  working|running) echo "작업 중이라 건드리지 않는다: $name — 끝날 때 orders/ 를 다시 확인한다." ;;
  *) exec claude --resume "$sid" --bg --remote-control "$name" "$nudge" ;;
esac
