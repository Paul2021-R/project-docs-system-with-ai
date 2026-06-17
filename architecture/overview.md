# Architecture Overview

본 문서는 Holygrail 시스템 전반의 구성 요소와 인프라 골격을 정의한다. CI/CD 파이프라인 상세는 [cicd.md](cicd.md), 워크스페이스 분리 철학은 [conventions/code-style.md](../conventions/code-style.md) 참조.

> **현재 단계**: Godot 게임 클라이언트 단독 (스모크 테스트). 서버·데이터·배포 인프라 미존재.
> 인프라성 절(§1.2·§2~§6)은 **구조만 보존**하고 "현재 미사용 — 향후 서버/배포 도입 시 작성"으로 둔다 (seam 유지, YAGNI).
>
> 본 문서는 "무엇이 어떻게 구성되어 있는가"(정적 구조)를 담는다 — 진행 상태는 workitem/ SoT.

---

## 0. 워크스페이스 분리 철학 (요약)

분리 원칙 SoT는 `conventions/code-style.md`이다. 핵심만:

- **app은 자기 완결적** — `cd app && <한 명령>`로 컨테이너·CI 없이 로컬 구동 가능.
- **매니지먼트 파이프라인은 app 밖** — Dockerfile·CI·manifest·secret은 레포 루트 또는 N/A.
- **시스템 운영(문서·에이전트)은 워크스페이스 루트** — `project-docs/`·`CLAUDE.md`.

## 1. 구성 요소

### 1.1 어플리케이션 서비스

| 서비스 | 레포 | 역할 | 스택 |
|---|---|---|---|
| Holygrail (게임 클라이언트) | `project-holygrail` | Godot 게임 본체 — 현재 스모크 테스트 단계 (스프라이트 4방향 이동) | GDScript / Godot 4.6 · Jolt Physics(3D) · `gl_compatibility` 렌더 · 에셋 Git LFS |
| 문서 시스템 | `project-docs` | CGDS 문서·TODO·ADR·결정 운영 (에이전트 룰셋) | Markdown |

### 1.2 GitOps / 배포 레포

**현재 미사용** — GitOps/배포 레포 없음. 클라이언트 게임이라 배포는 Godot export(플랫폼별 바이너리) 모델. 향후 서버/배포 인프라 추가 시 본 절 작성.

## 2. 데이터 레이어

**현재 미사용** — 서버 백엔드가 없어 DB·캐시·큐·스토리지 모두 해당 없음. 게임 상태는 클라이언트 로컬(Godot resource/save) 처리. 향후 멀티플레이어·서버 기능 추가 시 작성.

| 컴포넌트 | 용도 | 비고 |
|---|---|---|
| (없음) | | 향후 서버 도입 시 작성 |

## 3. 인프라

### 3.1 런타임 / 클러스터

**현재 미사용** — 런타임 클러스터/배포 타깃 없음. 개발은 로컬 Godot 에디터. 향후 서버 배포(k8s/compose/VM) 도입 시 작성하고 상세는 cicd.md로 위임.

### 3.2 운영 도구

**현재 미사용** — 모니터링·로깅·secret·CI 서버 없음. 향후 도입 시 작성.

## 4. Namespace / 격리 정책

**현재 미사용** — k8s 등 격리 단위 없음. 향후 서버 인프라 도입 시 작성.

## 5. 외부 라우팅

**현재 미사용** — 외부 도메인/Gateway/TLS 없음 (클라이언트 게임). 향후 서버 API·온라인 기능 추가 시 작성.

## 6. 외부 서비스 / 통합

**현재 미사용** — 결제·AI API·메일·푸시 등 외부 의존 없음. 향후 도입 시 작성.

## 7. 참고 문서

- CI/CD → [cicd.md](cicd.md)
- 셋업 → [../context/setup/getting-started.md](../context/setup/getting-started.md)
- 결정 누적 → [../decisions/](../decisions/)
