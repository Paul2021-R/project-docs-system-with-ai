# {{PROJECT_NAME}} — project-docs

세션 피라미드의 **공유 공간**이자 총괄(`chief`)의 작업 폴더다. 공통 룰은 워크스페이스 루트 `CLAUDE.md`에 있다.

| 경로 | 무엇 | 쓰는 쪽 |
|:--|:--|:--|
| `roles/` | 역할 카드 — 역할마다 하는 일과 하지 않는 일 | 총괄 |
| `contracts/` | 역할 사이의 계약 — API · DB 스키마 · 메타데이터 장부 | 총괄 |
| `decisions/` | ADR (불변 · 추가만) | 총괄 |
| `workitem/` | 작업 번호 발급부와 작업 entry(설계 · 합격 기준) | 총괄 발급 · 리드 설계 |
| `handoff/` | 세션 사이의 메시지 | 보내는 쪽이 새 파일로 |
| `status/` | 역할별 현재 상태 한 장 | 그 역할 |
| `qa/` | QA 스크립트의 원본 결과 | `qa-run.sh` |
| `ops/` | 환경 · 배포 · 운영 기록 | infra 리드 |
| `work-journal/` | 역할별 날짜 단위 저널 | 그 역할 |
| `conventions/` | 코드 · git 규약 | 총괄 |
| `scripts/` | spawn · respawn-all · qa-run · 훅 | 총괄 |

진입 순서: 루트 `CLAUDE.md` → `roles/{내 역할}.md` → `handoff/orders/`의 내 몫 → 해당 작업 entry.
