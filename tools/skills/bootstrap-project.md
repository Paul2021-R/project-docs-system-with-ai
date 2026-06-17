# skill: bootstrap-project

새 프로젝트에 본 project-docs 시스템을 적용할 때 **한 번** 실행하는 셋업 절차다. `@project-docs/tools/skills/bootstrap-project.md` 멘션 실행. placeholder 토큰을 프로젝트 값으로 채우고, 문서 스켈레톤을 Discovery 결과로 채운 뒤, 경로 정합을 검증한다.

> 협업 모델: 실행 에이전트(Claude / Gemini — 동일 룰셋)가 셋업을 수행하고, 트랙 확정·큰 결정은 사용자 승인(`[o]`)을 받는다. STOP 게이트는 `CLAUDE.md` 참조. 이 절차는 프로젝트당 1회성(셋업)이다 — 상시 룰이 아니다.

## Step 1 — Discovery (프로젝트 탐색)

워크스페이스를 스캔해 채울 값을 모은다. **STOP**: 결과를 사용자에게 보고하고 토큰 치환안 승인(`[o]`)을 받은 뒤 다음 단계.

- **서브 프로젝트·스택**: 각 레포의 마커 파일을 본다 (`package.json` / `build.gradle*` / `pyproject.toml`·`requirements.txt` / `go.mod` / `Cargo.toml` / `*.csproj` 등) → 언어·프레임워크·패키지매니저·런타임 버전.
- **인프라**: `docker-compose.yml` / `k8s`·`helm` / `.github/workflows` / `Jenkinsfile` / `*.tf` 등.
- **메타**: 프로젝트명 · 한 줄 설명 · 워크스페이스 절대경로 · 서브레포 목록 · GitOps 레포(있으면) · 서비스 도메인.

## Step 2 — 토큰 치환

`README.md` "placeholder 토큰" 표를 기준으로 `{{...}}`를 프로젝트 값으로 일괄 치환한다.

- 트랙 토큰(`{{TODO_TRACKS}}` / `{{ADR_TRACKS}}`)은 프로젝트 성격에 맞게 사용자와 합의해 확정한다 (대문자, TODO=단어 또는 hyphen subscope, ADR=단어 — TODO보다 광범위한 묶음).
- 트랙 토큰은 여러 문서에 분산되므로 **동시 치환**한다 (분산 위치 목록은 README "placeholder 토큰" 절 참조 — 정합 유지).
- 미치환 검출: `grep -rn '{{' .` → 0건.

## Step 3 — 문서 채우기

Discovery 결과로 스켈레톤을 채운다. 각 문서 상단 fill-in 주석을 따른다.

- `architecture/overview.md` · `architecture/cicd.md` — 구성·데이터·인프라·CI/CD.
- `context/setup/getting-started.md` 등 — 셋업 절차.
- `conventions/code-style.md` — 탐지된 언어 섹션 + 레포 레이아웃.
- `workitem/README.md` 트랙 정의 / `decisions/template.md` 트랙 매핑.
- 해당 없는 섹션·도구(GitOps 등)는 관련 토큰·문단째 삭제한다.

## Step 4 — 검증

- `@project-docs/tools/skills/bootstrap-path-align.md` 실행 → broken / undocumented / order drift **0** 확인.
- `grep -rn '{{' .` → 미치환 토큰 **0** 확인.
- 생성·수정 문서 목록을 사용자에게 보고 → 수정 요청 반영.

> 트리거 = `@project-docs/tools/skills/bootstrap-project.md`.
