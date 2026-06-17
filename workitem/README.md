## TODO 관리 규약

### 파일 구조

```
workitem/
├── README.md                       # 본 문서
├── backlog/
│   ├── INDEX.md                    # 트랙 그룹화 + 근황·우선순위
│   └── data/{TRACK}/               # 트랙별 entry 파일
└── done/
    ├── INDEX.md                    # 트랙 그룹화 + 시간순 보조 리스트
    └── data/{TRACK}/
```

- 각 TODO는 `data/{TRACK}/TODO-{N}-{slug}.md` 단일 entry 파일로 존재한다.
- `in-progress.md`는 사용하지 않는다. 진행 상태는 entry 안 `status` 필드 + `started:` 필드로 추적한다.
- INDEX.md는 lookup index. entry 본문은 individual 파일에서 읽는다.

### 트랙 정의

프로젝트 트랙 체계 = `GAMEPLAY, ART, AUDIO, ENGINE, BUILD`.

새 TODO는 확정된 트랙 중 하나로 분류한다. 어디에도 정확히 맞지 않으면 새 트랙 신설 여부를 먼저 결정한다.

| 트랙 | 범위 |
|---|---|
| `GAMEPLAY` | 게임 로직·메커닉·입력 처리, 플레이어/적/아이템 동작, 씬 구성, 상태 관리 |
| `ART` | 스프라이트·텍스처·애니메이션·셰이더·VFX, UI 비주얼 |
| `AUDIO` | BGM·효과음·오디오 버스·사운드 트리거 |
| `ENGINE` | 프로젝트 설정·물리(Jolt)·렌더링·플러그인·성능, 코드 아키텍처(autoload 등) |
| `BUILD` | export 프리셋·플랫폼 빌드·패키징·릴리스, LFS/에셋 파이프라인 |

> ⚠️ 향후 서버 백엔드가 추가되면 `SERVER`(또는 hyphen subscope) 트랙을 신설한다.

### 트랙 명명 컨벤션

트랙명은 대문자. todo 트랙은 단어 한 개 또는 hyphen + subscope.
ADR 트랙(`decisions/`)은 단어 한 개 형식 — todo 트랙보다 광범위한 묶음. 두 namespace는 별개로 운영한다.

### 파일명 패턴

```
TODO-{N}-{kebab-case-en-slug}.md
```

- `N`: 정수 또는 소수점 ID (예: `6.5`, `6.6`). ID는 immutable.
- `slug`: 영문 kebab-case. 30자 내외. 본문 제목 의미 압축.
- 같은 ID에 후속 entry가 필요하면: `TODO-{N}-{slug}-followup.md`.
- 원본 TODO가 작업 단위로 분리되면: 원본을 `TODO-{N}.0-{slug}.md`로 rename + done으로 이관(분리 anchor), 신규는 `TODO-{N}.1` / `TODO-{N}.2` 등. `N.0` entry 본문에 `split-into:` + `split-rationale:` 필드로 분리 근거 명시.

### TODO 항목 포맷

새 entry는 `cp tools/templates/workitem.md backlog/data/{TRACK}/TODO-{N}-{slug}.md`로 만든다 — 스켈레톤 SoT는 `tools/templates/workitem.md`다. 아래 블록은 각 필드의 의미.

```
### [TODO-번호] 제목

owner: human | agent
priority: P0 (blocker) | P1 (core) | P2 (standard) | P3 (nice-to-have)
module: {서브 프로젝트 모듈명}
status: backlog | in-progress | review | done | deferred | cancelled
branch: {git 브랜치명} (아래 "branch 필드 규약" 참조)
depends: TODO-번호 (선행 의존성, 없으면 none)
started: YYYY-MM-DD HH:MM:SS  (status가 in-progress로 전환된 시점에 추가)
completed: YYYY-MM-DD HH:MM:SS  (status가 done이 된 시점에 추가)
deferred: YYYY-MM-DD HH:MM:SS  (status가 deferred로 전환된 시점에 추가)
context: 이 작업이 필요한 이유 1줄
spec: 구체적 구현 요구사항 (계획 단계에서 구현할 클래스/인터페이스의 수도코드 및 설계 구조 명세 기입, 수도코드는 요청 시에만 작성)
done-criteria: 완료 판단 기준
```

### branch 필드 규약

`branch` 필드는 해당 TODO를 진행할 git 브랜치명을 지정한다. TODO 작성 시점에 정한다.

- TODO와 branch는 **별개 체계**이다. branch는 보통 work item 단위로 잡히고, 한 브랜치에서 여러 TODO가 진행될 수 있다.
- branch 명명 규칙은 `conventions/code-style.md` "Git Convention" 참조 — `{type}/{YYYYMMDD}-{WORK_ITEM_ID}` 패턴.
- 동일 work item 컨텍스트의 TODO는 같은 branch 값을 공유한다.
- branch 값이 없는 TODO는 작성 단계에서 `branch: TBD` 표시 후, 진행 직전에 결정한다.

### owner 분배 기준

<!-- bootstrap-project 시 사용자 답변 또는 기본값으로 채워진다 -->
<!-- 기본값: defaults/owner-template.md 참조 -->

### 우선순위 기준
- **P0**: 이게 없으면 다른 작업 진행 불가
- **P1**: 서비스 핵심 기능. MVP 필수
- **P2**: MVP 포함이지만 핵심 의존성 없음
- **P3**: MVP 이후 또는 있으면 좋은 것

### 전체 플로우 원칙

모든 TODO는 작은 작업이라도 동일 절차를 따른다.
계획(수도코드 및 설계 포함) → 사용자 검토 → 승인 → 작업 → 알림.
외부 review는 사용자가 명시 전달했을 때만 응답 사이클 진입.

이유: 미스언더스탠딩 cost > ping-pong cost.
비효율이 검증되면 그때 escape hatch를 도입한다.

### STOP 게이트 원칙

자연어 instruction은 100% 강제되지 않는다. 따라서:

- `[o]` 명시 표식 없이 단계 전환 금지
- "OK", "좋아" 같은 모호한 응답은 승인으로 간주하지 않음 — 명시 표식 재요청
- 표식 부재 시 default는 "대기"

### 언어 규약

- TODO 백로그 및 엔트리 파일 작성 시 한국어 사용을 허용한다.
- 단, 파일명 slug(`TODO-{N}-{slug}.md`)와 기술 식별자(클래스명, API 엔드포인트, 변수명, 수도코드 등)는 오역 방지 및 코드 일치성을 위해 영어로 기입한다.
