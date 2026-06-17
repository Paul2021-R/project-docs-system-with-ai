<!-- TWIN: CLAUDE.md ↔ GEMINI.md 쌍둥이. 한쪽 수정 시 다른 쪽도 동일 수정 — 구조·내용 동일, 지칭 명사(Claude↔Gemini)만 다르다. -->
# Gemini / Antigravity Instructions

This document serves as the system ruleset and guidelines for Antigravity, Antigravity CLI, and Gemini, performing the same function as `CLAUDE.md` does for Claude Code.

All conventions, architecture, and standards live in `project-docs/`.
Read `project-docs/README.md` first — it is the 1-depth index and entry point.

새 프로젝트 첫 셋업은 `@project-docs/tools/skills/bootstrap-project.md`를 1회 실행한다 (이후 상시 작업엔 불필요).

## Reasoning Loop

Before any tool call, edit, or status report — answer the questions in the
relevant stage. These are **questions, not rules**. The act of answering them
is the discipline; the questions themselves do not enumerate every failure mode.

### Pre-act — before acting

- Does the **path / file / identifier / command** I am about to use actually
  exist in this workspace? Have I verified, or am I assuming?
- Does the **function / API / config key / library** I am about to reference
  actually have an implementation backing it in the current codebase?
- What is the **responsibility boundary** of the file or component I am about
  to touch? Am I about to act outside it?

### Post-act — before reporting a result

- Did I **capture the real output** of what I just executed, or am I composing
  what the output likely was?
- Does the observed result match the intent, or am I rationalizing a mismatch
  into a success?

### Transition — before moving to the next step

- What **verifiable evidence** supports "this step is done"? (artifact on disk,
  captured command output, confirmed file existence, passing test)
- Have I already read this same file or asked this same question multiple
  times in this session? If yes, the next action is to **write intermediate
  state to disk and stop the loop**, not to re-read.

The loop is intentionally short. It exists so that self-query happens *before*
the action commits, not to cover every edge case with prescriptive rules.

## Required References

- `project-docs/README.md` — Entry point + 1-depth index
- `project-docs/architecture/overview.md` — Architecture
- `project-docs/conventions/code-style.md` — Code conventions (incl. comment rule)
- `project-docs/conventions/tool-usage-for-AI.md` — Tool usage rules (Filesystem/Plane MCP; incl. Plane↔TODO 연동 §2)
- `project-docs/workitem/README.md` + `workitem/backlog/INDEX.md` + `workitem/done/INDEX.md` — Task management
- `project-docs/decisions/` — ADRs (naming: `ADR-{NNN}-{TRACK}-{slug}.md`)
- `project-docs/context/setup/` — Setup guides (getting-started / secret-guide / troubleshooting)
- `project-docs/context/roadmap/` — Roadmap + scaling plans (reference, not active state)
- `project-docs/tools/` — Agent machinery: `skills/` (@멘션 절차 — catchup · bootstrap-path-align · bootstrap-project) + `templates/` (cp 스켈레톤)
- `project-docs/conventions/` — 위 code-style·tool-usage는 핵심 call-out이고, 하위 전체가 적용된다. 개발 중 새 컨벤션 확정 시 여기 파일을 추가하면 자동 in-scope (이 목록 갱신 불필요)

## Markers (status / approval shorthand)

- `[o]` — approved / completed / done
- `[/]` — revise / deferred / blocked

## TODO Flow

When given a TODO or a scoped task:

1. Read the TODO entry (`project-docs/workitem/backlog/data/{track}/TODO-{N}-{slug}.md`) and referenced docs.
2. Build a plan — file-by-file scope, role of each file, decision points the user must resolve. Include a high-level pseudo-code and architectural structure of the implementation inside the backlog TODO file (only when explicitly requested by the user).
3. Present the plan. For large or irreversible changes, wait for `[o]` before executing.
4. Execute. While editing the entry file:
   - set `status: in-progress`
   - add `started: YYYY-MM-DD HH:MM:SS`
5. On completion:
   - `mv` the entry to `done/data/{track}/`
   - set `status: done` and add `completed: YYYY-MM-DD HH:MM:SS`
   - update `backlog/INDEX.md` (remove line) and `done/INDEX.md` (add to track section + chronological list)
6. On user-requested defer:
   - keep file at `backlog/data/{track}/`
   - set `status: deferred` and add `deferred: YYYY-MM-DD HH:MM:SS`
   - update `backlog/INDEX.md` (annotate deferred state)

## STOP / Approval

- **명시적 지시 준수**: 에이전트는 사용자가 명시적으로 요청한 요구사항만을 행동으로 옮기며, 명시적으로 지시하지 않은 자의적인 행동(임의의 문서/코드 수정, 불필요한 사전 수도코드 추가 등)을 스스로 판단하여 수행해서는 안 된다.
- Large changes, irreversible operations, work affecting shared state outside this workspace → present a plan and wait for `[o]`.
- Small targeted edits, file reads, status checks, doc freshening → proceed directly.
- The judgment is the agent's — err toward asking when blast radius is unclear, but don't ask before every file write.
- 에이전트는 자율 실행하지 않는다 — 트리거는 항상 명시 위임(대화 요청 · `/loop` · 작업 배정). 디렉토리 자동 polling 없음.

## Git Commit & Push & TODO Promotion Policy

- **MANDATORY**: Never perform `git commit` or `git push` (or run scripts that automate commit/push) unless the user explicitly requests or commands it in the conversation. (단, 사용자의 직접적이고 명시적인 요청이 있는 경우에는 에이전트가 직접 Git 커밋 및 푸시 작업을 대행하여 수행할 수 있다.)
- **MANDATORY**: Do NOT automatically perform `git commit` or `git push` even if a checklist, workflow, or task description mentions it, unless the user writes a direct, explicit command in their conversational message (e.g., "commit and push now").
- **MANDATORY**: Never move TODO files (e.g., from `backlog/` to `done/`) or update `INDEX.md` files (to promote backlog tasks to done) unless the user explicitly commands or requests it in the conversation.
- **MANDATORY**: During the planning phase (such as inside `implementation_plan.md` or `task.md`), all git commit/push and TODO status promotion/moving steps must be clearly separated and marked with "Only upon explicit user request".
- **MANDATORY**: N/A 내의 빌드 번호, `newTag`/`imageTag` 등 GitOps 배포와 연관된 이미지 태그나 커밋 해시 값은 절대 AI가 임의로 수정하거나 되돌려서는 안 된다. (이러한 값은 CI/CD 파이프라인이나 사용자가 관리하므로 수정 대상에서 제외한다.)
- Drafting changes, updating status artifacts, and validating setups locally are allowed, but commit, push, and TODO promotion actions require explicit user commands.

## Tracks

Track names use UPPERCASE. Two separate namespaces (do not mix):

- **ADR tracks** (`decisions/ADR-{NNN}-{TRACK}-{slug}.md`): single-word — GAMEPLAY, TECH, PROCESS
- **TODO tracks** (`workitem/{backlog,done}/data/{TRACK}/`): single-word or hyphenated subscope — GAMEPLAY, ART, AUDIO, ENGINE, BUILD

ADR tracks are broader bundles; TODO tracks include the subscope.

## Document Immutability

- Significant document rewrites: back up the original first as `<filename>.bak.{YYYYMMDD-HHMM}-{short-reason}`.
- If a `.bak` (or matching suffix) already exists for that file, ask the user before overwriting, chaining, or splitting.
- ADRs (`decisions/`) are immutable and append-only. Change a decision by writing a new ADR with a Superseded reference.
- `work-journal/` work logs (when used): `##` sections never modified in place — append a new section instead.
- `workitem/` entry files use cut-and-paste between `backlog/` and `done/` per the TODO Flow above — this is the explicit exception to immutability.
- Never create `_v2` files — accumulate under headings in the same file, or rotate via versioned `.bak`.

## Work Log (`work-journal/`)

The `work-journal/YYYY-MM-DD.md` work log is **optional**, not required per turn. Write to it only when the user explicitly requests a turn-by-turn record. When written, follow the immutability rule above.

## Source Comments

- Mandatory: every method/class/interface gets a 1-2 line comment explaining intent ("what + why"). See `conventions/code-style.md` §4.
- Forbidden: action-log style comments in source (no "added 2026-05-13", no "fixes #123", no "used by feature X"). Record what/why/impact in the work log or PR description, not in source.

## Workspace Environments

- Directory: `/home/hansol/workspace/holygrail`
- **⚠️ 주의: 워크스페이스 최상단 폴더 자체가 Git 레포지토리가 아닐 수 있다.** 그 경우 Git 작업은 아래 각 하위 디렉토리(개별 레포) 내에서 수행한다.
- Sub-repos: project-holygrail (Godot 4.6 게임), project-docs (문서 시스템)
- `project-docs/`: 개발 문서·참조.
- `CLAUDE.md` / `GEMINI.md`: 에이전트 지시문 (워크스페이스 루트).

## Task Execution Guidelines

### 1. Preparation (Before starting a task)
- **Understand Context**: Analyze user requests, the current date, and previous context.
- **Read Conventions**: Read `project-docs/conventions/tool-usage-for-AI.md` to understand workspace tool usage instructions.
- **Consult Previous Work Logs**: Refer to the previous day's work log under `project-docs/work-journal/{YYYY-MM-DD.md}`.
- **Analyze Backlog**: Consult `project-docs/workitem/backlog/INDEX.md` to evaluate the current active task state and prepare for planning.

### 2. Planning
- **Update INDEX**: Write plan details in `project-docs/workitem/backlog/INDEX.md` for rapid overview.
- **Create TODO File**: Create `TODO-{N}-{slug}.md` under the corresponding track folder in `backlog/data/{TRACK}/` following the existing format. **Include pseudo-code and architectural layout of the target code in this file before implementation only if explicitly requested by the user.**
- **Human Review**: Share the plan with the Human, obtain approval (`[o]`), and then proceed to execution.

### 3. Cleanup & Completion (After completing a task)
- **Update INDEX**: Remove the completed task line from `backlog/INDEX.md` and move/append it to `done/INDEX.md`.
- **Move Data Files**: Move the TODO data file from `backlog/data/{TRACK}/` to `done/data/{TRACK}/` using `mv`.
