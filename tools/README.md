# Tools

project-docs를 **운용하는** 머시너리. content(`architecture`·`context`·`decisions`·`workitem`·`specs` = 프로젝트가 *무엇인지*)와 분리된, 에이전트가 *쓰는* 도구 레이어다.

- `scripts/` (별도 top-level) = shell 실행 본체 (machine-run, bash).
- `tools/` (본 디렉토리) = 에이전트가 멘션·복사로 쓰는 것 (agent-run).

## skills/ — @멘션 실행 절차 문서

CLI 자동 인식 skill이 아니라 `@project-docs/tools/skills/<name>.md` 형태로 **명시 호출**하는 절차 문서다. 읽기 위주이며, 변경은 절차 안에서 사용자 승인 후에만.

- `catchup.md` — 세션 시작 시 현재 작업 상황 파악 (읽기 전용 보고).
- `bootstrap-path-align.md` — `CLAUDE.md`·`README.md` 등 인덱스/지시 문서의 경로 참조를 실제 구조와 대조·정렬 (broken ref / 미문서화 / 순서 drift 검출).

## templates/ — cp-기반 스켈레톤 SoT

새 항목은 인라인 복붙이 아니라 `cp tools/templates/<x>.md ...`로 만든다 (포맷 SoT 단일화 — drift 차단).

- `workitem.md` — 새 workitem entry. 필드 의미는 `workitem/README.md` "TODO 항목 포맷".
- `work-journal.md` — 새 일일 작업일지 (미완/다음 top · `## N. 주제` 결론-first). 운영 규약은 `work-journal/README.md`.

> **ADR 템플릿 예외**: ADR 스켈레톤은 `decisions/template.md`에 잔류한다 — ADR 서브시스템(immutable · `ADR_TRACKS` 트랙 토큰 치환 · `ADR-000-template.md` 샘플 페어)과 결합돼 있어 거기서 관리하는 게 정합이다.
