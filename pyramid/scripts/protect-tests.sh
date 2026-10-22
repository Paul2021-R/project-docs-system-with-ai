#!/usr/bin/env bash
# PreToolUse 훅 — 실행자(exec-*)가 테스트 파일을 고치지 못하게 막는다. 다른 역할은 통과시킨다.
set -uo pipefail
input="$(cat)"
read -r role path < <(python3 -c 'import json,sys
d=json.load(sys.stdin); t=d.get("tool_input") or {}
print(d.get("agent_type") or "-", t.get("file_path") or t.get("notebook_path") or "-")' <<<"$input" 2>/dev/null || echo "- -")
[[ "$role" != exec-* || "$path" == "-" ]] && exit 0
case "/$path" in
  */test/*|*/tests/*|*/__tests__/*|*/integration_test/*|*/spec/*|*_test.*|*.test.*|*.spec.*|*/test_*|*Test.kt|*Tests.kt|*Test.java)
    echo "실행자는 테스트 파일을 고칠 수 없다: $path — 테스트가 틀렸다고 보면 리드에게 handoff/requests/ 로 보고한다." >&2
    exit 2;;
esac
exit 0
