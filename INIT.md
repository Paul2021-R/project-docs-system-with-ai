# Project-Docs Init — {{PROJECT_NAME}}

> 이 문서는 Claude Code가 프로젝트 문서를 세팅할 때 따르는 부트스트랩 체크리스트이다.
> 순서대로 실행하며, 각 Phase 완료 후 다음으로 넘어간다.
> 새 프로젝트에 본 시스템을 적용할 때의 1급 진입점이다.

- **프로젝트명**: {{PROJECT_NAME}}
- **브랜치**: {{PROJECT_NAME}}

---

## 시스템 구조 (CGDS v2)

```
┌─────────────────────────────────────────────────────┐
│ 시스템 내부 (3축)                                    │
│  - Claude Chat   → 의도 lens (계획·전략·라우팅)      │
│  - Claude Code   → 구현 lens (실행·작업일지)         │
│  - User          → 운영 lens (검수·결정·승인)        │
├─────────────────────────────────────────────────────┤
│ 시스템 외부 (독립)                                   │
│  - Gemini CLI    → review-only (수동 호출)           │
│                    결과는 reviews/에 저장 후 종료    │
└─────────────────────────────────────────────────────┘
```

Gemini는 시스템 내부 통신에 참여하지 않는다.
사용자가 수동으로 호출하고, 결과를 직접 읽고, 필요하면 Claude Code에 명시 전달한다.

---

## 사전 작업: 토큰 치환

본 시스템은 placeholder 토큰을 사용한다. Phase 1 Discovery 결과로 아래 토큰을 일괄 치환한다.
미치환 토큰 검출: `grep -rn '{{' .`

| 토큰 | 의미 | 치환 시점 |
|------|------|-----------|
| `{{PROJECT_NAME}}` | 프로젝트명 | Phase 1 |
| `{{PROJECT_DESC}}` | 한 줄 설명 | Phase 1 |
| `{{WORKSPACE_ROOT}}` | 워크스페이스 절대경로 | Phase 1 |
| `{{REPO_LIST}}` | 서브 레포 목록 | Phase 1 |
| `{{GITOPS_REPO}}` | GitOps 레포명 (없으면 제거) | Phase 1 |
| `{{SERVICE_DOMAIN}}` | 서비스 도메인 | Phase 1 |
| `{{TODO_TRACKS}}` | TODO 트랙 정의 | Phase 2 |
| `{{ADR_TRACKS}}` | ADR 트랙 정의 | Phase 2 |

---

## Phase 1: 프로젝트 탐색 (Discovery)

프로젝트 루트를 스캔하여 아래 정보를 수집한다.
**STOP 게이트**: Phase 1 완료 후 사용자 승인(`[o]` 표식) 없이 Phase 2로 진행 금지.

### 1-1. 프로젝트 메타데이터

| 항목 | 탐지 방법 | 폴백 |
|------|-----------|------|
| 프로젝트 설명 | README.md 첫 줄, package.json description | 사용자에게 질문 |

### 1-2. 서브 프로젝트 식별

| 마커 파일 | 판정 |
|-----------|------|
| package.json | Node.js 계열 |
| build.gradle / build.gradle.kts | JVM (Kotlin/Java) |
| pom.xml | JVM (Maven) |
| requirements.txt / pyproject.toml / setup.py | Python |
| Cargo.toml | Rust |
| go.mod | Go |
| *.csproj / *.sln | .NET |
| Dockerfile | 컨테이너 (보조 판정) |

### 1-3. 기술 스택 상세 파악

| 대상 | 탐지 소스 |
|------|-----------|
| 프레임워크 | dependencies (package.json, build.gradle 등) |
| 언어 버전 | .nvmrc, .python-version, .java-version, .tool-versions |
| 패키지 매니저 | lock 파일 |
| 린터/포맷터 | .eslintrc, .prettierrc, ruff.toml, ktlint 설정 등 |
| 테스트 프레임워크 | jest.config, pytest.ini, build.gradle test 블록 |

### 1-4. 인프라 탐지

| 마커 | 판정 |
|------|------|
| docker-compose.yml | 로컬 개발 환경 정의 있음 |
| k8s/, helm/ | Kubernetes 배포 |
| .github/workflows/ | GitHub Actions CI/CD |
| Jenkinsfile | Jenkins CI/CD |
| terraform/, .tf | IaC (Terraform) |

### 1-5. STOP — Discovery 결과 확인

수집한 정보를 사용자에게 출력하고, Phase 1 토큰(`{{PROJECT_NAME}}` 등) 치환안을 함께 제시한 뒤 다음 표식을 기다린다.

- `[o]` Phase 2 진행 → 다음 단계
- `[/]` 수정 필요 → 사용자 지시 대기

자율 진행 금지. "잘 했네", "OK" 같은 모호한 응답은 승인으로 간주하지 않는다.

---

## Phase 2: 문서 생성 + 트랙 확정

Discovery 결과를 기반으로 project-docs/ 하위 문서를 자동 생성한다.
**STOP 게이트**: 각 서브 단계 완료 후 사용자 확인 후 진행.

### 2-0. 트랙 확정 (`{{TODO_TRACKS}}` / `{{ADR_TRACKS}}`)
프로젝트 성격에 맞는 트랙 체계를 사용자와 합의해 확정한다.
- TODO 트랙: 단어 한 개 또는 hyphen + subscope (대문자)
- ADR 트랙: 단어 한 개 (대문자), TODO 트랙보다 광범위한 묶음
- 확정 후 `CLAUDE.md` / `GEMINI.md` / `todo/README.md` / `decisions/template.md` 의 토큰을 동시 치환한다 (네 곳 정합 유지).

### 2-1. architecture/overview.md
Discovery 데이터로 구성 요소, 데이터 레이어, 인프라 섹션을 채운다.

### 2-2. conventions/code-style.md
탐지된 언어별로 해당 섹션만 추가한다. §2 레포 레이아웃의 `{{REPO_LIST}}`를 치환한다.

### 2-3. context/setup/getting-started.md
탐지된 런타임/도구 버전, 패키지 매니저 명령어, 실행 명령어를 채운다.

### 2-4. todo/README.md
owner 분배 기준을 사용자에게 질문하여 설정한다 (`defaults/owner-template.md` 기본값 참조).

### 2-5. GEMINI.md 프로젝트 컨텍스트 채우기
Discovery 결과를 GEMINI.md의 `## Project Context` 섹션(있을 경우)에 반영한다.
이 섹션은 외부 Gemini agent가 review 시 플랫폼 컨텍스트로 사용한다.

---

## Phase 3: 검증

- [ ] 생성된 문서 목록을 사용자에게 출력
- [ ] 미치환 토큰 검출 (`grep -rn '{{' .`) — 0건 확인
- [ ] "검토 후 수정할 부분을 알려주세요" 안내
- [ ] 수정 요청 반영 후 커밋

---

## CGDS 협업 규약 (전체 워크플로우 공통)

### 작업 파일 명명 규칙

| 디렉토리 | 파일명 | 작성자 | 용도 |
|---------|-------|-------|------|
| `work-journal/` | `YYYY-MM-DD.md` | Claude Code | 작업일지 (계획·수행·리뷰응답 누적) |
| `reviews/` | `YYYY-MM-DD_HHMMSS.md` | 외부 Gemini | 코드 리뷰 보고서 |

같은 날 추가 라운드는 `work-journal/YYYY-MM-DD.md` 한 파일에 `##` 헤딩으로 누적한다.
`reviews/` 안의 파일은 호출마다 독립 timestamp 파일로 생성된다.

### Identifier 규칙

`TODO-{NUMBER}-{HH:MM:SS}`

각 발화는 독립 ID를 가진다. 멘션·참조의 구분자로 사용한다.
같은 초 내 충돌 시 `-2`, `-3` suffix를 끝에 붙인다.

### 체크박스 의미

- `[o]` 완료 / 승인
- `[/]` 유저 결정으로 유보 (defer)

### STOP 게이트 원칙

자연어 instruction은 100% 강제되지 않으므로, **명시 표식 없이 진행하지 않는다.**

- 모호한 응답("좋아", "OK", "그래")은 승인으로 간주하지 않는다.
- 표식 부재 시 다음 행동은 항상 "대기".
- 자율 TODO 생성, 환경 구축, 코드 작성은 명시 지시 후에만.

### 전체 플로우 원칙

모든 TODO는 priority/owner와 무관하게 동일 절차를 따른다.
미스언더스탠딩 cost > ping-pong cost.

---

## 외부 Review 처리 (opt-in)

외부 Gemini agent가 `reviews/YYYY-MM-DD_HHMMSS.md`에 보고서를 작성하더라도,
**Claude Code는 자동으로 그 파일을 읽지 않는다.**

사용자가 명시적으로 review 파일을 전달했을 때만:
1. 파일을 읽고 응답 계획을 수립한다
2. `work-journal/YYYY-MM-DD.md`에 응답 섹션을 누적한다
3. 사용자 승인 후 수정 적용

Discord 알림은 외부 Gemini가 보고서 작성 후 자동 발송한다 (사용자 인지용).

---

## 이 INIT을 실행하는 방법

Claude Code에게:

```
INIT.md를 읽고 Phase 1부터 시작해줘.
각 STOP 게이트에서 내 승인을 기다려.
```
