# Skill: Write Work Journal (작업 일지 작성 스킬)

This skill describes the exact steps an AI agent must follow when the user requests to write, update, or generate the daily work-journal entry.

## Execution Steps

### 1. Gather Context & Metadata
1. **Get Today's Date**: Determine today's date in `YYYY-MM-DD` format (using the system's local time).
2. **Target File Path**: The target journal path is `project-docs/work-journal/YYYY-MM-DD.md`.
3. **Check for Existing Journal**: Check if `project-docs/work-journal/YYYY-MM-DD.md` already exists.
   - If it exists, read it first so you can append or update the session details instead of overwriting.
4. **Detect Active Task**: Read `project-docs/todo/backlog/INDEX.md` and extract the currently active TODO (e.g., lines mentioning `Currently active`).
5. **Get Git Status**: Run `git status` in the workspace to find:
   - The current branch name.
   - Any modified or untracked files.
6. **Find Previous Journal**: Look at files in `project-docs/work-journal/` (e.g. `20*.md`), sort them, and identify the immediately preceding journal entry date to create a link `[[YYYY-MM-DD]]`.

### 2. Analyze Session History
1. Review the conversation logs (`overview.txt` or current chat messages) to extract:
   - What problems were discussed.
   - What design decisions were made.
   - What files were modified, created, or deleted.
   - Any key commands run.
   - Any issues resolved.

### 3. Draft the Journal Entry
Construct the markdown file matching the following standard layout.
**Do not insert Obsidian frontmatter** (no `---` / `tags:` block) — write plain markdown.

```markdown
# {{PROJECT_NAME}} 작업 일지 — YYYY-MM-DD

> 트랙: [Auto-detected Track or TODO ID]
> 브랜치: `[Auto-detected Branch]`
> 작성: YYYY-MM-DD HH:MM KST
> 참조: [List of modified files relative to workspace root]
> 이전 일지: [[PREVIOUS-YYYY-MM-DD]]

---

## 진행도 한눈에

| 범위 | 상태 |
|---|---|
| [Task / Step Name] | [✅ (Completed) or ⚪ (Pending)] |

---

## 현 상황 간단 정리

- [Brief summary of the session's key achievements and current state]

---

## 1. 상세 작업 내용

### 1-1. [First major milestone/action]
- [Details of what was done, errors encountered, solutions applied, commands run, etc.]
- [If code was changed, describe why and how]

### 1-2. [Second major milestone/action]
- ...

---

## 결정 사항 누적

| 항목 | 결정 |
|---|---|
| [Topic] | [Decision details and rationale] |

---

## 다음 세션 진입 큐

| 트랙 | 내용 | 비고 |
|---|---|---|
| [TRACK] | [Task description for next session] | [Context/Notes] |

---

## 회고

### [Key Takeaway/Retrospective Topic]
- [What went well, what caused delays, how to avoid similar issues in the future]
```

### 4. Apply Compromised Language Policy
- Write explanations, summaries, and retrospects in Korean (한국어).
- Technical terms (class names, API endpoints, git commands, variable names, architecture labels, and pseudo-code) must be written in English.

### 5. Write the File
- If creating a new file, construct it using the template in Step 3.
- If updating/appending to an existing file, follow the **Append Rules** below.
- Present the summary and path of the created/updated file to the user.

## Append Rules (동일 일자 추가 작업 발생 시 규약)

When the journal file for today (`project-docs/work-journal/YYYY-MM-DD.md`) already exists, do NOT overwrite it. Instead, append the new session's information using the following guidelines:

1. **Metadata Section (상단 메타데이터)**:
   - **트랙**: If the new task belongs to a different track/TODO, append it with `->` or a comma (e.g. `PRODUCT (TODO-35) -> CICD-INFRA (TODO-25)`).
   - **브랜치**: Append the new branch name if switched.
   - **작성**: Append the new session start time (e.g. `09:25 KST / 14:30 KST (DevPC 세션)`).
   - **참조**: Append the newly modified files to the comma-separated list.

2. **진행도 한눈에 (Progress Table)**:
   - Append new rows for the tasks completed or pending in this session at the bottom of the table.

3. **현 상황 간단 정리 (Summary)**:
   - Append a new bullet point summarizing the results of the additional session.

4. **상세 작업 내용 (Detailed Work)**:
   - Create a new heading level 2 for the additional session: `## 2. [추가 세션 주제 / 세션 2 상세 내용]` (or level 3 `### 1-X` if it directly continues the previous tasks).
   - Document the details, commands, errors, and solutions in this section.

5. **결정 사항 누적 (Decisions)**:
   - Append any new design or technical decisions to the bottom of the table.

6. **다음 세션 진입 큐 (Next Queue)**:
   - Update or append new items to the queue table.

7. **회고 (Retrospective)**:
   - Add a new subheading `### [세션 2 회고 주제]` under `## 회고` to record the retrospective of the additional session.
