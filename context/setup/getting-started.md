# Getting Started

본 문서는 새 합류자(또는 새 머신)가 {{PROJECT_NAME}} 워크스페이스의 로컬 개발 환경을 셋업하는 절차를 정의한다. 시스템 구성은 [../../architecture/overview.md](../../architecture/overview.md), CI/CD는 [../../architecture/cicd.md](../../architecture/cicd.md) 참조.

<!-- bootstrap-project 시 탐지된 런타임/도구 버전·패키지매니저·실행 명령어로 채운다. -->

---

## 1. Prerequisites

### 1.1 호스트 도구

<!-- 빌드·실행에 필요한 CLI 도구. Discovery에서 탐지된 패키지매니저·런타임 반영. -->

| 도구 | 용도 |
|---|---|
| <도구> | <용도> |

### 1.2 외부 계정 / 키

<!-- 레지스트리 push 권한, 알림 webhook, 암호화 키 등. 🚨 키·토큰 실제 값은 절대 본 문서에 적지 않는다. -->

## 2. Repository Setup

워크스페이스 루트는 다음 레포의 통합 컨텍스트이다 ({{REPO_LIST}}).

```
{{WORKSPACE_ROOT}}/
└── <repo>/   # <역할>
```

각 레포는 독립 git 레포이며, `project-docs/`는 통합 문서로 별도 관리된다.

## 3. Environment Variables

<!-- 로컬 구동에 필요한 .env 키 목록. 키 이름·용도만 — 값은 커밋 금지. -->

## 4. Running Locally

<!-- `cd <app> && <한 명령>`으로 시작하는 자기완결 실행 절차를 서비스별로. 컨테이너·k8s 없이 동작해야 한다(분리 철학). -->

## 5. Troubleshooting

자주 겪는 문제·처방은 [troubleshooting.md](troubleshooting.md)에 누적한다.

## 6. 참고 문서

- 시크릿 관리 → [secret-guide.md](secret-guide.md)
- 아키텍처 → [../../architecture/overview.md](../../architecture/overview.md)
- CI/CD → [../../architecture/cicd.md](../../architecture/cicd.md)
