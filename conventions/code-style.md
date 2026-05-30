# Code Style & Conventions

## 0. Foundational — 워크스페이스 분리 철학

본 컨벤션의 기반이 되는 세 가지 원칙. 상세 설명과 다이어그램은 `architecture/overview.md` §0 참조.

1. **app은 완벽하게 독립적으로 구동 가능해야 한다.**
   `cd app && <한 명령>`만으로 로컬 실행이 가능해야 한다. 컨테이너·k8s·CI 어떤 것도 거치지 않고 동작해야 한다.

2. **매니지먼트 파이프라인은 app 바깥에 있다.**
   Dockerfile / Jenkinsfile / docker-compose.yml / k8s 매니페스트 등 app/을 외부에서 감싸는 모든 것은 app/ 밖에 둔다 (레포 루트 또는 GitOps 레포).

3. **워크스페이스 루트의 `.env`는 시스템과 에이전트(CGDS) 운영용이다.**
   각 어플리케이션의 `.env`는 `app/.env`. 워크스페이스 루트의 `.env`는 워크스페이스 도구 스크립트가 읽는 CGDS 운영 환경변수 전용이다. 두 `.env`는 같은 이름이지만 완전히 다른 레이어의 자원이다.

이 세 원칙을 위반하는 컨벤션은 본 문서에 들어오지 않는다. 위반 도입이 필요할 때는 별도 ADR을 통해 명시 결정.

---

## 1. General

<!-- init에서 탐지된 언어 목록과 들여쓰기 규칙이 채워진다 -->

## 2. Repository Layout & Containerization

각 앱 레포({{REPO_LIST}})는 동일 레이아웃 컨벤션을 따른다. §0의 원칙 1, 2를 풀어낸 것이다.

```
<repo-root>/
├── app/                  ← 어플리케이션 코드 + 어플리케이션 메타데이터.
│   │                       언어/런타임이 인식하는 프로젝트 루트는 여기다.
│   │                       (pyproject.toml / build.gradle.kts / package.json
│   │                        등 어플리케이션 메타파일이 이 안에 위치)
│   ├── .env              ← 어플리케이션 dev용 환경변수 (git 미추적).
│   └── .env.example      ← 위 템플릿.
├── Dockerfile            ← 컨테이너화 정의. 레포 루트.
├── docker-compose.yml    ← 로컬 통합 실행 (선택).
├── Jenkinsfile           ← CI 파이프라인 (해당 시).
├── k8s/                  ← (선택) 레포 내 보조 매니페스트.
├── README.md
├── .gitignore            ← 레포 전체 무시 규칙.
└── .dockerignore         ← 컨테이너 빌드 무시 규칙.
```

원칙:

- **`app/`은 어플리케이션의 독립 프로젝트 루트.** 어플리케이션 메타파일과 lockfile, 런타임 설정(`.python-version` / `.nvmrc`), dev용 `.env`는 모두 `app/` 안에 둔다. 로컬 실행도 이 안에서 한다 (`cd app && ...`).
- **컨테이너·CI·레포 운영 파일은 모두 레포 루트에 둔다.** `Dockerfile` / `docker-compose.yml` / `Jenkinsfile` / `.dockerignore` / `.gitignore` / `README.md`.
- **Docker build context는 레포 루트.** `docker build .`을 레포 루트에서 실행하며, Dockerfile 안에서 `COPY app/ ./app/` + `WORKDIR /app` 식으로 진입한다.
- 빌드 산출물(`.next/` / `target/` / `build/` / `__pycache__/` 등)은 `.dockerignore`로 명시 차단한다.

이 컨벤션은 레포 일관성 + 빌드 명령 단일화 + 어플리케이션 책임 격리(`app/` 안에서 자기 완결)를 위한 것이다.

### 2.1 시크릿 위치 정책 (§0의 원칙 3 적용)

| 시크릿 종류 | 위치 | 비고 |
|---|---|---|
| 어플리케이션 dev용 (로컬 실행) | `<repo>/app/.env` | git 미추적. `app/.env.example`로 템플릿 제공 |
| 어플리케이션 staging/production용 | k8s Secret (SOPS 암호화) | GitOps 레포의 `.../secret.enc.yaml` |
| CGDS 시스템 운영용 | 워크스페이스 루트 `.env` | 워크스페이스 도구 스크립트가 읽음 |

레이어 간 자원 혼합 금지. 어플리케이션이 워크스페이스 루트 `.env`를 읽거나, CGDS 도구가 k8s Secret에 접근하는 경우는 발생하지 않아야 한다.

### 2.2 Secret Management (k8s Secret 전용 — 일반 원칙)

staging/production용 k8s Secret은 SOPS 암호화 + KSOPS generator + overlay 패턴을 따른다 (해당 인프라를 쓰는 경우). 핵심 원칙만 시스템 레이어로 유지한다. 구체 절차·이름 규칙은 적용 시 `context/setup/secret-guide.md` + ADR로 작성한다.

1. **환경별 분리 — base에 secret 두지 않음**. 환경별 secret 값이 다르고, overlay 밖 참조를 차단하기 위함.
2. **KSOPS generator 패턴** — `.enc.yaml`은 `resources:`가 아닌 `generators:` 섹션에 추가.
3. **SOPS encrypted_regex** — `^(data|stringData)$`로 data 필드만 암호화. metadata/apiVersion/kind는 평문 유지 (GitOps 도구가 manifest를 인식해야 함).
4. **`.enc.yaml` 직접 수정 금지** — 평문 영역을 text editor로 직접 수정 시 SOPS MAC이 깨진다. `sops <file>` 인터랙티브 또는 decrypt→수정→encrypt 사이클.

---

## 3. Naming

| 대상 | 규칙 | 예시 |
|------|------|------|
| 변수/함수 | camelCase | `getUserById` |
| 클래스 | PascalCase | `UserService` |
| 상수 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| 파일 (TS) | kebab-case | `user-service.ts` |
| DB 컬럼 | snake_case | `created_at` |

## 4. Comments (필수 규약)

모든 메서드 / 클래스 / 인터페이스 단위에 의도 주석을 단다.

- 형식: 1~2줄, "무엇을 / 왜" 중심
- 행동 내역(누가 언제 무엇을 했는지)은 주석이 아니라 `work-journal/YYYY-MM-DD.md` 작업일지에 기록
- 코드를 행동 로그로 부풀리지 않는다

## 5. Git Convention

### Branch Structure

브랜치 이름은 `{type}/{YYYYMMDD}-{WORK_ITEM_ID}` 패턴을 따른다.

- `{YYYYMMDD}` — 브랜치 생성 일자 (KST 기준)
- `{WORK_ITEM_ID}` — work item identifier (Plane 등 트래커의 프로젝트 식별자 + 시퀀스 번호).

```
예시: feature/20260501-INFRASTRUC-1
      bug/20260503-PRODUCT-23
      chore/20260507-INFRASTRUC-12
      hotfix/20260510-PRODUCT-45
```

브랜치 type:

- `main` — 배포 전용. 직접 커밋 금지
- `develop` — 개발 메인. 모든 PR의 기본 타겟
- `feature/...` — 기능 개발
- `bug/...` — 버그 수정
- `chore/...` — 설정/환경 작업
- `hotfix/...` — 긴급 수정
- `release/vX.Y.Z` — 배포 점검 (날짜·work item 패턴 적용 안 함)

원칙:

- **모든 브랜치는 work item과 1:1 매핑된다.** 브랜치명에 work item identifier가 포함된다.
- **브랜치와 TODO는 별개 체계이다.** 한 브랜치에서 여러 TODO가 진행될 수 있다. TODO 측에서는 `branch:` 필드로 어느 브랜치에서 진행할지 지정한다 (`todo/README.md` 참조).
- 식별자가 없는 즉흥 작업은 브랜치를 만들기 전에 트래커에 work item부터 등록한다.
- PR 본문 첫 줄에는 해당 work item URL을 둔다.

### Commit Message

- 형식: `type: 설명`
- type: feat, fix, refactor, docs, test, chore, style, rename, remove
- 한글 허용, type 접두사는 영문 소문자 고정
