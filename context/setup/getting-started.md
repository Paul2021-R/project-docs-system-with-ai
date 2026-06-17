# Getting Started

본 문서는 새 합류자(또는 새 머신)가 Holygrail 워크스페이스의 로컬 개발 환경을 셋업하는 절차를 정의한다. 시스템 구성은 [../../architecture/overview.md](../../architecture/overview.md), CI/CD는 [../../architecture/cicd.md](../../architecture/cicd.md) 참조.

> **현재 단계**: Godot 게임 클라이언트만 존재. 서버·컨테이너·CI 미존재 — 관련 절은 "현재 없음"으로 둔다.

---

## 1. Prerequisites

### 1.1 호스트 도구

| 도구 | 용도 |
|---|---|
| Godot Engine 4.6 | 게임 엔진/에디터. `project-holygrail/project.godot`를 연다 (Forward Plus 지원 버전) |
| Git | 버전 관리 (각 서브레포 독립) |
| Git LFS | 대용량 에셋(`*.mp4/mov/wav/ogg`) 추적 — clone 후 `git lfs install` 필요 |

### 1.2 외부 계정 / 키

**현재 없음** — 외부 레지스트리/키 불필요 (로컬 게임 개발). GitHub 레포 접근 권한만 필요. 향후 배포/서버 도입 시 작성. 🚨 키·토큰 실제 값은 절대 본 문서에 적지 않는다.

## 2. Repository Setup

워크스페이스 루트는 다음 레포의 통합 컨텍스트이다 (project-holygrail (Godot 4.6 게임), project-docs (문서 시스템)).

```
/home/hansol/workspace/holygrail/
├── project-holygrail/   # Godot 4.6 게임 클라이언트 (project.godot)
└── project-docs/        # CGDS 문서 시스템 (별도 git 레포)
```

각 레포 clone 후 LFS 에셋을 받으려면:

```
git lfs install
git -C project-holygrail lfs pull
```

각 레포는 독립 git 레포이며, `project-docs/`는 통합 문서로 별도 관리된다.

## 3. Environment Variables

**현재 없음** — 게임 클라이언트는 `.env` 불필요. 설정은 `project.godot` + Godot 프로젝트 설정으로 관리. 향후 서버 연동 시 작성.

## 4. Running Locally

에디터로 열기:

```
cd project-holygrail && godot project.godot      # 에디터 실행
```

에디터 없이 메인 씬 바로 실행:

```
cd project-holygrail && godot --path . 
```

`F5`(에디터 내) 또는 위 명령으로 메인 씬(`main_00.tscn`)이 구동된다. 컨테이너·k8s 불필요 (분리 철학 충족 — 레포 단독 실행).

## 5. Troubleshooting

자주 겪는 문제·처방은 [troubleshooting.md](troubleshooting.md)에 누적한다.

## 6. 참고 문서

- 시크릿 관리 → [secret-guide.md](secret-guide.md)
- 아키텍처 → [../../architecture/overview.md](../../architecture/overview.md)
- CI/CD → [../../architecture/cicd.md](../../architecture/cicd.md)
