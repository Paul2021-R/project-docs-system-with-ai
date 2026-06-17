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
> - `TRACK`: 대문자 짧은 단어. 프로젝트 트랙 체계는 `{{ADR_TRACKS}}` (bootstrap-project 시 확정).
>   - TODO 트랙과 의미 매핑 (첫 단어 축약). todo 트랙보다 광범위한 묶음.
>   <!-- 예시 (snacks):
>        CICD — CI/CD, k8s manifest, secret, operator, infra
>        META — CGDS 같은 메타 시스템·워크플로우·운영 원칙
>        APP  — 애플리케이션 레벨 결정 (BE/FE/Worker)
>        DOCS — 문서·컨벤션 자체에 대한 결정 -->
> - `slug`: 영문 kebab-case, 30자 내외, 결정 본질을 압축.
> - 예: `ADR-008-CICD-jenkins-job-routing.md`, `ADR-012-META-track-rename.md`

---
