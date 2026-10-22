#!/usr/bin/env bash
# 재부팅 뒤 project-{{SLUG}}-* 세션 중 멈춘 것만 다시 띄운다(저장된 대화를 이어간다).
set -euo pipefail
claude agents --json --all 2>/dev/null | python3 -c 'import json,sys
for s in json.load(sys.stdin):
    if s.get("kind")=="background" and str(s.get("name","")).startswith("project-{{SLUG}}-") and s.get("state") in ("failed","stopped"):
        print(s["id"], s["name"])' | while read -r id name; do
  echo "respawn $name ($id)"; claude respawn "$id"
done
