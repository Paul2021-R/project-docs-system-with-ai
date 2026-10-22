# handoff — 세션 사이의 메시지

메시지 하나가 파일 하나다. **기존 파일을 고치지 않는다.** 답장도 새 파일이고, `re:`로 원래 메시지를 가리킨다.

## 파일명

```
{YYYYMMDD-HHMM}-{from}-to-{to}-{{SLUG_UPPER}}-{n}.md
```

## 머리말

```markdown
---
from: lead-server
to: exec-server
work: {{SLUG_UPPER}}-12
kind: order            # order · report · proposal · blocked · decision
re:                    # 답장이면 원래 파일명
---
```

## 폴더

| 폴더 | 방향 | 쓰는 쪽 |
|:--|:--|:--|
| `orders/` | 위 → 아래 (지시 · 합격 기준) | 총괄 · 리드 |
| `requests/` | 아래 → 위 (보고 · 계약 변경 제안 · 막힘 · 병합 요청) | 보고하는 쪽 |
| `to-paul/` | 총괄 → Paul (되돌리기 어려운 결정만) | 총괄 |
| `strikes/` | 개선 이관 기록 · 진단 · 테스트 변경 | 개선 |

## 처리 판정

지시는 그 지시를 `re:`로 가리키는 `report` 또는 `blocked`가 생기면 처리된 것이다. 받는 쪽은 처리 전에 `requests/`에서 자기 답장이 이미 있는지 확인한다.

## to-paul 형식

질문 · 선택지 · 추천 · 그 추천이 깨지는 조건 · 되돌릴 수 있는지. 하루 한 번 묶어서 올린다.
