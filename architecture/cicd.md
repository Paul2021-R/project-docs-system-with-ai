# CI/CD 파이프라인 설계

본 문서는 Holygrail의 CI/CD 파이프라인 설계와 운영 규약을 정의한다. 시스템 구성은 [overview.md](overview.md), 결정 근거는 [../decisions/](../decisions/) 참조.

> **현재 상태**: CI/CD 파이프라인 **없음**. 빌드는 로컬 Godot 에디터의 export(플랫폼별 바이너리) 수동 방식.
> 본 문서 골격은 **삭제하지 않고 보존**한다 — 향후 Godot export 자동화(GitHub Actions 등) 또는 서버 배포 도입 시 각 절을 채운다 (seam 유지).

---

## 1. 목적과 우선순위

### 1.1 목표
<!-- 이 프로젝트 CI/CD가 달성할 것 3~5줄. 예: 멀티 서비스 빌드 일관성, 환경 drift 최소화, 롤백 용이성. -->

### 1.2 우선순위
<!-- 확장성 / 안정성 / 속도 / 운영편의 중 이 프로젝트의 순위와 이유. -->

## 2. 환경 구성

### 2.1 환경 분리
<!-- 몇 환경인지(local/staging/production 등), 각 환경의 위치·빌드도구·TLS·도메인. 단일 환경이면 그렇게 명시. -->

| 환경 | 빌드/배포 도구 | 위치 | TLS | 비고 |
|---|---|---|---|---|
| local | | | | |
| staging | | | | |
| production | | | | |

### 2.2 공용 인프라
<!-- 환경 간 공유하는 레지스트리·secret 저장소·CI 서버 등. -->

## 3. 빌드·배포 흐름

### 3.1 트리거
<!-- push / PR / tag / manual 중 무엇이 무엇을 트리거하는지. -->

### 3.2 빌드·배포 시퀀스
<!-- 소스 → 빌드 → 이미지/아티팩트 → 배포 단계. 다이어그램 권장. -->

### 3.3 Secret · env 관리 흐름
<!-- 빌드/런타임 secret 주입 경로. 상세 절차는 [../context/setup/secret-guide.md] 로 위임. -->

## 4. 배포 대상 구조

<!-- N/A 디렉토리 트리, base/overlay 책임 분배 등.
     k8s/GitOps 미사용이면 배포 산출물(이미지·아티팩트·배포 스크립트) 구조로 대체. -->

## 5. 핵심 결정 사항

<!-- 파이프라인의 주요 설계 결정. 각 항목은 ADR로 분리하고 여기선 1줄 요약 + 링크.
     예: `- 이미지 태그 전략 → decisions/ADR-{NNN}-{TRACK}-image-tag.md` -->

## 6. Risk

<!-- 🚨 실행 시 실패·손실·장애로 이어질 수 있는 운영 risk (빌드 실패 격리, 롤백 불가 상황, secret 유출 경로 등). -->

## 7. 주의사항

<!-- ⚠️ 알아두면 좋은 전제·한계·환경 의존성. -->

## 8. 작업 추적

진행/완료 작업은 [../workitem/backlog/INDEX.md](../workitem/backlog/INDEX.md) (active) + [../workitem/done/INDEX.md](../workitem/done/INDEX.md) 참조.
