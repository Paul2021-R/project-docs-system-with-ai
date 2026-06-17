# Work Journal — Daily Work Log

이 디렉토리는 실행 에이전트의 일일 작업 일지(계획·실행, 그리고 사용자가 명시 전달한 경우 review 응답)를 담는다. **선택적** — 매 턴 필수가 아니라, 사용자가 턴 단위 기록을 명시 요청할 때만 작성한다.

## File Type

| File | Author | Purpose |
|------|--------|---------|
| `YYYY-MM-DD.md` | 실행 에이전트 | 일일 작업 일지 (계획 + 실행 + review 응답) |
| `tools/templates/work-journal.md` | — | 새 일지 스켈레톤 — **형식 SoT** |

**1일 1파일, 누적.** 같은 날 여러 작업·세션은 같은 파일 안에 새 `##` 헤딩으로 누적한다. `_v2` 접미사 금지.

## 형식 — 템플릿이 SoT

새 일지는 `cp tools/templates/work-journal.md work-journal/YYYY-MM-DD.md`로 시작한다. 형식 정의는 템플릿 한 곳에만 둔다(중복 방지):

- **본문 구조**: `# {YYYY-MM-DD} work log` → 한 줄 요약 → `## 미완 / 다음`(**항상 본문 최상단** — 다음 세션 진입점 즉시 노출) → `## N. 주제`(각 섹션 **`**결론**:` 먼저**, 그 뒤 메커니즘·결정·트레이드오프 산문).
- **frontmatter 미사용**: 일반 마크다운(전역 메타데이터 임의생성 금지 / Obsidian frontmatter 미사용). vault 동기화 등으로 tags가 필요한 프로젝트만 work-journal 한정 예외로 두고 그 사유를 본 README에 명시한다.

작성 절차는 [`conventions/skill-write-journal.md`](../conventions/skill-write-journal.md).

## Rules

1. **Language**: 한국어 작성 허용. 단 클래스명·API 엔드포인트·변수명·수도코드 등 기술 식별자는 영어.
2. **Immutability**: 작성된 `##` 섹션은 in-place 수정하지 않는다. 정정·추가는 새 `##` 섹션으로 누적(`## 미완 / 다음`은 살아있는 큐라 갱신 허용).
3. **Markers**: `[o]` done / approved, `[/]` deferred by user decision. `[x]` 미사용.
4. **No auto-trigger**: 어떤 디렉토리도 polling하지 않는다. review 응답은 사용자가 review 파일 경로를 명시 전달할 때만 진입.

## Review 응답 (opt-in)

사용자가 `reviews/YYYY-MM-DD_HHMMSS.md` 경로를 명시 전달하면 그 파일을 읽고 오늘 일지에 `(review-response)` 섹션을 누적한다 ([`reviews/README.md`](../reviews/README.md) 참조). 어느 에이전트(Claude/Gemini)든 동일 절차.

## Deprecated (역사적 기록은 유효)

- **구 CGDS v1 식별자 섹션 형식** `## TODO-{N}-{HH:MM:SS} (plan/execution)` → 현 `## N. 주제` 산문 형식(결론-first)으로 대체. 기존 파일은 그대로 유효.
- **표 중심 레이아웃**(진행도/결정/다음 큐 표) → 산문 + `## 미완 / 다음` 큐로 대체 (논증·왜는 산문, 표는 *병렬 비교 가능한 항목*에만).
