#!/usr/bin/env bash
# QA — 저장소의 scripts/test.sh 를 1회 돌리고 원본 출력과 판정만 남긴다. 해석하지 않는다.
# 사용: qa-run.sh <role> <WORK-ID> <exec|fix>
#   exec 는 작업당 첫 구동만, fix 는 첫 실패 뒤 최대 3회까지 허용한다.
set -uo pipefail
[[ $# -eq 3 ]] || { echo "사용: qa-run.sh <role> <WORK-ID> <exec|fix>" >&2; exit 64; }
role="$1"; work="$2"; by="$3"
docs="$(cd "$(dirname "$0")/.." && pwd)"
repo="$(git rev-parse --show-toplevel 2>/dev/null || echo "$(dirname "$docs")/$role")"
out="$docs/qa/$work"; mkdir -p "$out"
prev=$(find "$out" -maxdepth 1 -name 'run-*.json' 2>/dev/null | wc -l)
if [[ "$by" == "exec" && "$prev" -ge 1 ]]; then
  echo "거부: $work 는 이미 QA가 돌았다. 실행자는 다시 돌리지 않는다 — 리드에게 보고한다." >&2; exit 3
fi
if [[ "$by" == "fix" && "$prev" -ge 4 ]]; then
  echo "거부: $work 는 개선 재구동 3회를 모두 썼다. 리드를 거쳐 총괄로 올린다." >&2; exit 3
fi
[[ -f "$repo/scripts/test.sh" ]] || { echo "env: $repo/scripts/test.sh 가 없다" >&2; }
k=$((prev + 1)); ts=$(date +%Y%m%d-%H%M%S)
log="$out/run-$k-$ts.log"
( cd "$repo" && bash scripts/test.sh ) >"$log" 2>&1
code=$?
case $code in 0) v=pass;; 1) v=test-fail;; 2) v=env-fail;; *) v=unknown;; esac
python3 -c 'import json,sys
k=["work","role","by","run","verdict","exit","branch","commit","log"]
v=sys.argv[1:]; v[3]=int(v[3]); v[5]=int(v[5])
print(json.dumps(dict(zip(k,v)),ensure_ascii=False))' \
  "$work" "$role" "$by" "$k" "$v" "$code" \
  "$(git -C "$repo" branch --show-current 2>/dev/null || echo -)" \
  "$(git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo -)" "$log" > "$out/run-$k-$ts.json"
echo "QA $work run $k ($by): $v (exit $code) → $log"
