# Session Pyramid — 다중 세션 운영 골격

`main`의 CGDS v2는 **사람 한 명 + 세션 하나**가 기준이다. 이 브랜치는 그 위에 **세션 여럿이 Paul 없이 주고받는 층**을 더한 골격이다. 사람은 되돌리기 어려운 결정만 보고, 총괄 세션이 계약과 통합을 쥐며, 리드가 설계하고, 실행자가 구현한다.

`bootstrap.sh`로 새 워크스페이스에 펼친다. 프로젝트 고유 값은 `{{...}}` 자리표시자로 남겨 두고 펼칠 때 치환한다.

## 층과 역할

| 층 | 에이전트 | 모델 · 강도 | 하는 일 | 하지 않는 일 |
|:--|:--|:--|:--|:--|
| 사람 | — | — | 되돌리기 어려운 결정 · `main` 병합 · production 적용 | — |
| 총괄 | `chief` | Opus · xhigh | 계약 · ADR · 작업 번호 발급 · 지시 · `develop` 병합 · 비개발 직접 지시 | 코드 작성 · 원본 diff 읽기 |
| 리드 | `lead-{role}` | Opus · high | 설계 · 합격 기준과 테스트 선작성 · 작업 분해 · 실행자 · 개선 기동 | 계약 변경(제안만) |
| 실행 | `exec-{role}` | Sonnet · high | 구현 · 빌드 · 타입 · 린트 수정 | 테스트 실패 후 수정 · 테스트 파일 편집 |
| QA | `qa-run.sh` | 스크립트 | 테스트 1회 구동 · 원본 보존 · 판정 | 해석 · 요약 |
| 개선 | `fix-{role}` | Opus · high | 실패 진단 · 수정 · 재구동 최대 3회 | 테스트 변경을 기록 없이 하기 |
| 리뷰 | opencode + `plan-review` · `work-review` | 외부 모델 | 계획 · 결과물 검토 리포트 | 코드 수정 |
| 비개발 | `research` · `synthesis` | Sonnet · high / Opus · medium | 조사 · 편집 / 종합 · 인사이트 | 수집 쪽의 결론 도출 |

- 층은 셋(총괄 · 리드 · 실행)에서 멈춘다. 지시를 전달만 하는 층은 맥락만 새고 가치가 없다.
- 실행자는 테스트가 실패해도 고치지 않는다. 고치다 테스트를 약하게 만드는 유인을 구조에서 없애고, 실패 원본을 그대로 개선 역할에 넘긴다.
- QA는 판단이 필요 없는 일이라 세션이 아니라 스크립트다.

## 펼쳐지는 모양

```
{{WORKSPACE_ROOT}}/          # git 아님
├── CLAUDE.md                # 공통 룰 — 모든 세션이 자동 로드
├── project-docs/            # git · 총괄 소유 · 공유 공간
│   ├── .claude/agents/      # chief · research · synthesis
│   ├── contracts/  decisions/  conventions/
│   ├── roles/               # 역할 카드
│   ├── handoff/{orders,requests,to-paul,strikes}/
│   ├── status/  ops/  qa/  workitem/  work-journal/
│   └── scripts/             # spawn · respawn-all · qa-run · 훅
└── {role}/                  # 역할마다 독립 git 저장소
    ├── CLAUDE.md            # 역할 룰 — 그 폴더에서 띄운 세션만 로드
    ├── .claude/agents/      # lead-{role} · exec-{role} · fix-{role}
    ├── .claude/settings.json
    ├── scripts/test.sh      # QA가 부르는 테스트 진입점
    └── docs/notes/          # 그 역할의 개인 메모
```

## 펼치는 법

```bash
pyramid/scripts/bootstrap.sh <WORKSPACE_ROOT> <SLUG> <PROJECT_NAME> <role...>
# 예: bootstrap.sh ~/workspace/acme acme "acme-app" lab server app
#     LEAD_ONLY_ROLES="lab" 이면 lab 에는 lead 에이전트만 둔다(실험은 리드가 직접 한다)
```

펼친 뒤 할 일은 셋이다.

1. 각 폴더에서 `claude`를 한 번 실행해 workspace trust를 수락한다. 수락하지 않은 폴더에서는 백그라운드 세션이 `Workspace not trusted`로 종료된다.
2. 각 폴더를 git 저장소로 초기화하고 원격을 붙인다.
3. 총괄을 띄운다: `project-docs/scripts/spawn.sh chief project-docs`.

## 근거

- Claude Code 백그라운드 세션 · supervisor · `respawn` — <https://code.claude.com/docs/en/agent-view>
- 에이전트 정의 필드(`model` · `effort` · `tools` · `hooks` · `initialPrompt`) — <https://code.claude.com/docs/en/sub-agents>
- CLAUDE.md 로드 순서(상위 폴더는 시작 시 전부) — <https://code.claude.com/docs/en/memory>
- Stop 훅으로 종료 차단 — <https://code.claude.com/docs/en/hooks>
