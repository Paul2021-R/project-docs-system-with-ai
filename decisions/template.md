# ADR-{NNN}: {제목}

## Status
<!-- Proposed | Accepted | Deprecated | Superseded by ADR-{NNN} -->

## Date
<!-- YYYY-MM-DD -->

## Context
<!-- 이 결정이 필요한 배경과 문제 상황을 기술 -->

## Decision
<!-- 어떤 결정을 내렸는지 기술 -->

## Consequences

### Positive
### Negative

## Alternatives Considered

---

> **파일명 컨벤션**: `ADR-{NNN}-{TRACK}-{slug}.md`
>
> - `NNN`: 3자리 정수, decisions/ 안 다음 빈 번호. ID는 immutable.
> - `TRACK`: 대문자 짧은 단어. 프로젝트 트랙 체계 = `GAMEPLAY, TECH, PROCESS`.
>   - TODO 트랙과 의미 매핑 (첫 단어 축약). todo 트랙보다 광범위한 묶음.
>        GAMEPLAY — 게임 설계·메커닉·콘텐츠 구조 결정 (TODO: GAMEPLAY/ART/AUDIO 포괄)
>        TECH     — 엔진·아키텍처·물리·렌더·빌드/export 기술 결정 (TODO: ENGINE/BUILD 포괄)
>        PROCESS  — 협업·문서·컨벤션·워크플로우 결정
> - `slug`: 영문 kebab-case, 30자 내외, 결정 본질을 압축.
> - 예: `ADR-008-CICD-jenkins-job-routing.md`, `ADR-012-META-track-rename.md`

---
