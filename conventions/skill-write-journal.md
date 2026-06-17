# Skill: Write Work Journal (작업 일지 작성 스킬)

사용자가 일일 작업 일지의 작성·갱신을 요청했을 때 에이전트가 따르는 절차다. 형식 SoT는 [`tools/templates/work-journal.md`](../tools/templates/work-journal.md), 운영 규약은 [`work-journal/README.md`](../work-journal/README.md).

## Execution Steps

### 1. Gather Context & Metadata
1. **Today's Date**: 시스템 로컬 시간 기준 `YYYY-MM-DD`.
2. **Target Path**: `project-docs/work-journal/YYYY-MM-DD.md`.
3. **Check Existing**: 같은 날 파일이 있으면 **먼저 읽고** append한다(덮어쓰기 금지 — 아래 Append Rules).
4. **Detect Active Task**: `project-docs/workitem/backlog/INDEX.md`에서 현재 active / in-progress item을 추출.
5. **Git Status**: 워크스페이스에서 현재 branch + 변경/untracked 파일 확인.

### 2. Analyze Session
대화 맥락에서 추출: 논의된 문제 / 내린 결정 / 변경·생성·삭제된 파일 / 핵심 명령 / 해결된 이슈.

### 3. Draft — 템플릿 복사로 시작
`cp tools/templates/work-journal.md work-journal/YYYY-MM-DD.md` 후 채운다. **Obsidian frontmatter 미사용**(일반 마크다운). 구조:

```markdown
# {YYYY-MM-DD} work log

{한 줄 요약 — 그날의 성격·주제. 코드 작업이면 선택 메타: branch / 작업 ID.}

## 미완 / 다음
- {다음 세션 진입점 / 미결 / 후속}        ← 항상 본문 최상단

## 1. {주제}
**결론**: {핵심 먼저 — bottom line 한두 줄.}
{무엇을 / 왜 / 메커니즘·결정·트레이드오프. terse하되 인과 유지. 근거는 `file:line` 또는 링크.}

## 2. {주제}
**결론**: …
…
```

핵심 원칙:
- **`## 미완 / 다음`은 항상 본문 최상단** — 다음 세션이 진입점을 즉시 보게 한다.
- **각 `## N. 주제`는 `**결론**:` 먼저**, 그 뒤 산문. 표는 *병렬 비교 가능한 항목*에만(논증·왜는 산문).

### 4. Language Policy
설명·요약·회고는 한국어. 기술 식별자(클래스명·API 엔드포인트·git 명령·변수명·수도코드)는 영어.

### 5. Write / Append
- 새 파일: 위 템플릿으로 작성.
- 기존 파일: 아래 Append Rules.
- 작성 후 경로·요약을 사용자에게 제시.

## Append Rules (동일 일자 추가 작업)

오늘 파일이 이미 있으면 덮어쓰지 않는다. 불변성 — 작성된 `##` 섹션은 in-place 수정 금지.

1. **`## 미완 / 다음` 갱신**: 살아있는 큐다. 완료분 정리 / 새 진입점 추가 — 이 큐만 갱신 허용.
2. **새 주제 섹션 누적**: 추가 세션·작업은 다음 번호의 `## N. 주제`로 추가(기존 섹션 안에 끼워 넣지 않는다). 각 섹션 `**결론**:` 먼저.
3. **정정**: 기존 섹션을 고치지 말고 새 `## N.` 섹션에 정정 사유와 함께 누적한다.
