# project-docs-system-with-ai

AI 에이전트(Claude / Gemini)와 함께 쓰는 **CGDS v2(Claude-Gemini Dev System)** 운영 프레임워크의 재사용 가능한 골격이다.
특정 프로젝트의 내용은 담지 않는다 — 새 프로젝트에 복사한 뒤 `INIT.md`로 placeholder를 채워 사용한다.

## 이게 뭔가

워크스페이스 문서·TODO·결정(ADR)·작업일지·외부 리뷰를 AI 에이전트가 일관되게 다루도록 만든 규약 + 템플릿 묶음이다. 핵심은 세 가지다:

1. **3축 협업 구조** — Claude Chat(계획·실행) / Claude Code(위임 실행) / User(검수·결정), + 외부 Gemini(review-only).
2. **STOP 게이트** — 명시 표식(`[o]`) 없이 단계 전환 금지. 미스언더스탠딩 cost > ping-pong cost.
3. **SoT 분리** — 진행 상태는 `todo/INDEX.md`, 결정은 `decisions/`(immutable), 구현 spec은 TODO entry, 작업 기록은 `work-journal/`.

## 새 프로젝트에 적용하는 법

```
1. 이 디렉토리를 새 워크스페이스에 project-docs/ 로 복사한다.
2. CLAUDE.md / GEMINI.md / INIT.md 는 워크스페이스 루트로 옮긴다.
3. Claude Code에게: "INIT.md를 읽고 Phase 1부터 시작해줘."
4. INIT Phase 1(Discovery) → Phase 2(문서 생성 + 트랙 확정)에서
   placeholder 토큰을 프로젝트 값으로 치환한다.
5. grep -rn '{{' . 로 미치환 토큰 0건 확인.
```

## placeholder 토큰

| 토큰 | 의미 |
|------|------|
| `{{PROJECT_NAME}}` | 프로젝트명 |
| `{{PROJECT_DESC}}` | 한 줄 설명 |
| `{{WORKSPACE_ROOT}}` | 워크스페이스 절대경로 |
| `{{REPO_LIST}}` | 서브 레포 목록 |
| `{{GITOPS_REPO}}` | GitOps 레포명 (없으면 제거) |
| `{{SERVICE_DOMAIN}}` | 서비스 도메인 |
| `{{TODO_TRACKS}}` | TODO 트랙 정의 |
| `{{ADR_TRACKS}}` | ADR 트랙 정의 |

토큰은 `{{...}}` Mustache 형식이다. `grep -rn '{{' .`로 미치환분을 일괄 검출한다.
트랙 토큰(`{{TODO_TRACKS}}`/`{{ADR_TRACKS}}`)은 `CLAUDE.md`·`GEMINI.md`·`todo/README.md`·`decisions/template.md` 네 곳에 분산되므로 동시에 치환해야 정합이 유지된다.

## 새 세션 시작 시 읽는 순서 (적용 후 기준)

1. **`project-docs/README.md`** — 진입점 + 1뎁스 인덱스 (프로젝트별로 본 파일을 갈음)
2. **`/CLAUDE.md`** — Claude Code 작업 지시문 (역할 / TODO 흐름 / 불변성)
3. **`project-docs/todo/README.md`** — TODO 운영 규약 (트랙·파일명 패턴·상태 필드)
4. **`project-docs/todo/backlog/INDEX.md`** — 미착수 큐 + `> Currently active` 마커
5. **`project-docs/todo/done/INDEX.md`** — 완료 아카이브
6. **`project-docs/decisions/`** — 누적 ADR (`ADR-{NNN}-{TRACK}-{slug}.md`)

## 역할

- **Claude (Chat)** — 계획 + 메인 실행. 의도 청취 → 명확화 → 계획 분해 → 코드/문서 변경.
- **User** — 결정자. 우선순위 결정, 큰 변경 승인(`[o]`)/수정(`[/]`), 환경 의존 작업(.env, age 키 등).
- **Claude Code** — 위임 기반 병렬 보조자. 명시 위임 시 진입. 자율 polling 없음.

## 디렉토리 가이드

```
project-docs-system-with-ai/
├── README.md                  # 본 파일 — 시스템 설명 + 적용법
├── INIT.md                    # 부트스트랩 체크리스트 (1급 진입점)
├── CLAUDE.md                  # Claude 에이전트 지시문 → 적용 시 워크스페이스 루트로
├── GEMINI.md                  # Gemini 에이전트 지시문 → 적용 시 워크스페이스 루트로
├── conventions/
│   ├── tool-usage-for-AI.md   # AI 도구 사용 규약 (Filesystem/Plane MCP, 메모리, 문서)
│   ├── code-style.md          # 워크스페이스 분리 철학 + 언어 무관 코딩/Git 규약
│   └── skill-write-journal.md # 작업 일지 작성 스킬
├── decisions/                 # ADR (immutable, append-only)
│   ├── template.md
│   └── ADR-000-template.md
├── todo/
│   ├── README.md              # TODO 운영 규약
│   ├── backlog/{INDEX.md, data/}
│   └── done/{INDEX.md, data/}
├── api/                       # API 명세 재분류 시스템
│   ├── README.md
│   └── TEMPLATE.md
├── work-journal/README.md     # 작업 일지 운영 규약
├── specs/README.md            # Ground Truth 기획 명세 규약
├── reviews/README.md          # 외부 Gemini 리뷰 규약
├── defaults/owner-template.md # owner 분배 기본값
└── scripts/README.md          # 경량 bash 도구 레이어 규약 (본체 .sh 미포함)
```

## 핵심 규약

### TODO / ADR Identifier

- TODO entry 파일명: `TODO-{N}-{slug}.md` (소수점 ID 허용, ID는 immutable). 자세히는 `todo/README.md`.
- ADR 파일명: `ADR-{NNN}-{TRACK}-{slug}.md` (TRACK 대문자). 자세히는 `decisions/template.md`.

### STOP / 승인

- 큰 변경·비가역 작업·shared state 영향 작업 → plan 제시 후 `[o]` 대기.
- 작은 targeted 수정·읽기·상태 확인 → 즉시 진행.
- 판단 모호 시 묻는 쪽이 안전.

### 불변성

- 큰 폭 재작성 시 기존 파일을 `<filename>.bak.{YYYYMMDD-HHMM}-{사유}`로 백업 후 작성.
- ADR(`decisions/`)은 immutable, append-only. 변경 시 새 ADR로 superseding.
- `work-journal/` `##` 섹션은 in-place 수정 금지 — 새 섹션 누적.
- `todo/` entry는 backlog → done cut-and-paste (불변성 예외).
- `_v2` 파일 금지 — 헤딩 누적 또는 versioned `.bak` rotation.
- Obsidian frontmatter(`---` tags 블록) 미사용 — 일반 마크다운.

본 README는 시스템 구조·인덱스에 한정한다. 진행 상태 스냅샷은 적지 않는다 (drift 방지).
