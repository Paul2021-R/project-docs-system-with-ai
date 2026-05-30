# Tool Usage for AI (Chat·Code·Antigravity)

본 문서는 AI 에이전트(Claude, Gemini, Antigravity 등)가 본 워크스페이스에서 사용할 도구 사용 패턴과 컨텍스트 메타를 정리한 것이다. CLAUDE.md 및 GEMINI.md는 각각 Claude Code 및 Antigravity/Gemini에 적용되며, 본 문서를 공통 AI 에이전트용 룰로 사용한다.

> 본 문서는 시스템 골격이다. 프로젝트 고유 항목(Plane UUID, 도메인 컨텍스트, secret 경로 등)은 적용 시 프로젝트별로 본 문서 하단 또는 별도 컨텍스트 파일에 추가한다.

## 본 문서 읽는 시점

세션 진입 시점에 사용자가 다음 형태로 지시한다:
- "본 워크스페이스 작업 시작 — conventions/tool-usage-for-AI.md 읽어줘"
- 또는 본 문서가 project knowledge에 포함된 경우 자동으로 로드된다

## 1. Filesystem MCP

사용자 컴퓨터 파일을 다룰 때 사용하는 도구다. 원격 AI 컴퓨터(`/mnt`, `/home/claude` 등)와 별개이다.

### 1.1 사용 패턴

- **로드**: deferred 도구라 `tool_search`로 로드한다. 키워드 예: `filesystem read directory tree`, `filesystem edit file`, `filesystem write file`
- **읽기 — `read_multiple_files`**: 관련 파일 여러 개를 한 번에 읽는다. 시간 절약.
- **디렉토리 구조 — `directory_tree`**: `excludePatterns`를 지정한다. 표준 패턴:
  `["node_modules", ".git", ".gradle", "build", ".next", "__pycache__", ".venv", "dist", ".idea", "target"]`
- **수정 — `edit_file`**: 사용자 컴퓨터 파일을 수정할 때 사용한다. 원격 AI의 `str_replace`는 사용자 컴퓨터에 적용되지 않는다.
- **신규 — `write_file`**: 사용자 컴퓨터 파일을 신규 생성할 때 사용한다.

⚠️ `edit_file` 사용 전 반드시 `read_text_file`로 현재 상태를 확인한다 (이전 편집으로 문자열이 바뀌었을 수 있음). 신규/전체 교체는 `write_file`.

### 1.2 도구 선택 메커니즘

사용자 컴퓨터 파일이면 Filesystem MCP, 원격 AI 컴퓨터 파일이면 view/str_replace/create_file. 경로가 어느 쪽인지 헷갈리면 작업 전에 확인한다.

## 2. Plane MCP (프로젝트가 Plane을 쓰는 경우)

self-hosted Plane을 다룰 때 사용하는 도구다. 사용하지 않는 프로젝트는 본 섹션을 제거한다.

### 2.1 사용 패턴

- **로드**: deferred 도구. `tool_search limit=20`으로 로드한다 (필수 — 기본 limit으로는 일부 도구가 누락된다).

### 2.2 프로젝트 식별자

<!-- 적용 시 채운다:
  workspace_id: ...
  프로젝트 UUID / 라벨 UUID / State UUID / 멤버 UUID -->

### 2.3 로컬 TODO ↔ Plane work item 연동 (범용 원칙)

Plane work item과 로컬 TODO(`todo/{backlog,done}/data/`)는 **별개 체계**이다. 역할로 분리해 운영한다 (SoT 분리).

- **Plane** = work item 단위 추적. 상태·우선순위·담당자·브랜치 단위의 SoT.
- **로컬 TODO** = 구현 spec·수도코드·설계 구조의 SoT.

**매핑 규칙**: work item name에 `(TODO-N)`을 명시해 1:1 연결한다. branch는 Plane work item ID 기반(§5.2)이며, 동일 work item 컨텍스트의 TODO는 같은 branch를 공유한다.

**입도 차이 허용**: Plane이 로컬보다 더 세분화될 수 있다. 일치 강제는 아니다.

**상태 동기화**: 이중 관리(Plane state vs `backlog/INDEX.md`의 Currently active). 수동 일치를 원칙으로 한다.

## 3. 메모리 도구 (memory_user_edits)

### 3.1 사용 시점

사용자가 명시적으로 요청한 경우에만 사용한다. 자율 호출하지 않는다. "기억해줘", "잊어줘", "메모리 갱신해줘" 같은 표현이 있을 때만.

### 3.2 저장하지 않을 항목

- 프로젝트 워크스페이스 전용 정보 — 본 문서/컨텍스트 파일에 기록한다
- Plane UUID 등 환경 ID — 본 문서에 기록한다
- 사용자가 직접 발화하지 않은 추론 정보

### 3.3 저장할 항목

- 사용자 자체 메타 (호칭, 의사결정 lens 등)
- 다른 프로젝트에서도 통용되는 메타 (마크다운 표준 등)

### 3.4 한도

최대 30개. 추가 발생 시 기존 항목을 교체(`replace`)하거나 사용자 결정을 받아 삭제한다.

## 4. 문서 작성 패턴

### 4.1 형식

- 마크다운 사용 (docx는 명시 요청 시만)
- Obsidian frontmatter(`---`로 감싼 tags: 블록) 미사용
- 임의 메타데이터 생성하지 않음 (요청 없으면)

### 4.2 버전 관리

- **정수 버전 업 (v1→v2)**: 기존 문서 폐기. 이전 버전 참조 없이 완전히 새로 작성.
- **소수점 버전 업 (v2→v2.1)**: 기존 문서 수정. 이전 버전 참조 없이 해당 문서만으로 전체 파악이 가능해야 한다.

### 4.3 시크릿 보관 위치 표현

- "본인 보관처"로 일반화하여 표기 (메모리에 저장하지 말 것)
- 문서/ADR/setup 가이드 작성 시 동일

## 5. 워크스페이스 구조 포인터

### 5.1 3 레이어 철학

정식 정의: `architecture/overview.md` §0, `conventions/code-style.md` §0.

- **Layer A — Application**: 각 레포 `app/` 안. 완벽 독립 구동.
- **Layer B — Management**: 레포 루트 + GitOps 레포. Dockerfile, k8s manifest 등.
- **Layer C — Workspace Operation (CGDS)**: 워크스페이스 루트. CLAUDE.md, project-docs/, .env (워크스페이스 도구 운영용).

### 5.2 Git 브랜치 컨벤션

정식 정의: `conventions/code-style.md` "Git Convention".

- 패턴: `{type}/{YYYYMMDD}-{WORK_ITEM_ID}` (예: `feature/20260501-INFRASTRUC-1`)
- 모든 작업은 work item과 1:1 매핑. work item을 먼저 생성한 후 브랜치를 생성한다.

### 5.3 의도적 미결(deferred) 패턴 (범용)

어떤 API/도메인은 본격 구현 전에 *내용 파악 + 검증*이 선행되어야 한다. 다음 경우에 해당한다:

1. **외부 의존 검증 대기**: 외부 서비스 계약/검증/승인 필요
2. **자본/법적 요건 미충족**: 사업 단계상 진행 불가
3. **상위 시스템 의존**: 선행 TODO 완료 필요
4. **MVP 외 가능성**: 우선순위 낮음

**처리 규칙**:
- 해당 모듈/문서 헤더에 `상태: ⚠️ 의도적 미결 — 사유 / 본격 진행은 TODO-N` 명시
- INDEX 테이블에 ⚠️ 마커 + 사유
- stub 코드 생성 시 *클래스 단위 주석*으로 동일 사유를 명시 (placeholder 응답만 제공)
- AI 에이전트는 사유 검토 없이 자율적으로 미결 영역 구현을 시도하지 않는다

## 6. 본 문서 수정 패턴

본 문서는 워크스페이스 컨텍스트 + AI 도구 사용 룰을 담는다. 수정 시점:

- 워크스페이스 디렉토리 구조 변경 시
- 도구 사용 패턴에서 새 항목 발견 시
- (Plane 사용 시) 프로젝트/라벨/State 식별자 변경 시
- 사용자가 명시한 시점

⚠️ 본 문서는 수정 시 정수/소수점 버전을 매기지 않는다 (단일 reference 문서). 추가/수정된 항목만 반영한다.
