# Architecture Overview

본 문서는 {{PROJECT_NAME}} 시스템 전반의 구성 요소와 인프라 골격을 정의한다. CI/CD 파이프라인 상세는 [cicd.md](cicd.md), 워크스페이스 분리 철학은 [conventions/code-style.md](../conventions/code-style.md) 참조.

<!-- bootstrap-project 시 Discovery 결과로 채운다. 해당 프로젝트에 없는 섹션은 삭제한다.
     본 문서는 "무엇이 어떻게 구성되어 있는가"(정적 구조)를 담는다 — 진행 상태는 workitem/ SoT. -->

---

## 0. 워크스페이스 분리 철학 (요약)

분리 원칙 SoT는 `conventions/code-style.md`이다. 핵심만:

- **app은 자기 완결적** — `cd app && <한 명령>`로 컨테이너·CI 없이 로컬 구동 가능.
- **매니지먼트 파이프라인은 app 밖** — Dockerfile·CI·manifest·secret은 레포 루트 또는 {{GITOPS_REPO}}.
- **시스템 운영(문서·에이전트)은 워크스페이스 루트** — `project-docs/`·`CLAUDE.md`.

## 1. 구성 요소

### 1.1 어플리케이션 서비스

<!-- 각 서브 레포를 한 줄씩: 역할·스택·포트. Discovery(bootstrap-project) 결과로 채운다. -->

| 서비스 | 레포 | 역할 | 스택 |
|---|---|---|---|
| <서비스명> | <repo> | <한 줄> | <언어/프레임워크> |

### 1.2 GitOps / 배포 레포

<!-- {{GITOPS_REPO}} 가 있으면 기술, 없으면 본 절 삭제. -->

## 2. 데이터 레이어

<!-- DB·캐시·큐·오브젝트 스토리지 등. 없는 항목은 행 삭제. -->

| 컴포넌트 | 용도 | 비고 |
|---|---|---|
| <PostgreSQL 등> | <용도> | |

## 3. 인프라

### 3.1 런타임 / 클러스터

<!-- 배포 타깃: k8s(k3s/k3d) · docker-compose · 서버리스 · VM 등.
     환경(local/staging/prod) 분리가 있으면 상세는 cicd.md로 위임하고 여기선 한 줄. -->

### 3.2 운영 도구

<!-- 모니터링·로깅·secret·CI 서버 등. 도입 전이면 'context/roadmap/ 참조'로 둔다. -->

## 4. Namespace / 격리 정책

<!-- k8s 등 격리 단위가 있을 때만. 미사용이면 본 절 삭제. -->

## 5. 외부 라우팅

<!-- 도메인({{SERVICE_DOMAIN}}) · Gateway/Ingress · TLS · 프록시(Cloudflare 등). -->

## 6. 외부 서비스 / 통합

<!-- 결제·AI API·메일·푸시 등 3rd-party 의존. -->

## 7. 참고 문서

- CI/CD → [cicd.md](cicd.md)
- 셋업 → [../context/setup/getting-started.md](../context/setup/getting-started.md)
- 결정 누적 → [../decisions/](../decisions/)
