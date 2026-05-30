# Work Journal — Claude Code Work Log

This directory holds Claude Code's daily work log: plans, executions,
and (when the user explicitly forwards a review) review responses.

External code review is handled by the **Gemini review-only agent**
(`GEMINI.md` in the project root). Gemini writes its reports to
`project-docs/reviews/`, NOT here.

## File Type (current)

| File | Author | Purpose |
|------|--------|---------|
| `YYYY-MM-DD.md` | Claude Code | Work log: plans + executions + review responses |

**One file per day, accumulated.** Multiple TODOs and rounds on the same
date go under new `##` headings inside the same file. Do NOT create
`_v2` suffixes.

## Deprecated File Types

The following files were produced by CGDS v1 and are no longer generated:

- `YYYY-MM-DD_REVIEW.md` — replaced by `reviews/YYYY-MM-DD_HHMMSS.md`
- `YYYY-MM-DD_RESULT.md` — merged into `YYYY-MM-DD.md` as a `(review-response)` section

Existing files of these types remain valid as historical records.
You may archive them to `specs/archive/` when convenient.

## Identifier Format

```
TODO-{NUMBER}-{HH:MM:SS}
```

Every utterance issues a fresh identifier at the moment of writing.
Identifiers serve as mention/reference anchors across files.
On same-second collision, append `-2`, `-3`, etc.

Example flow for TODO-042:

```
plan              :  TODO-042-14:32:15
execution         :  TODO-042-15:18:42
review-response   :  TODO-042-17:21:08    (ref reviews/2026-05-02_160511.md)
```

## Status Markers

- `[o]` done / approved
- `[/]` deferred by user decision

`[x]` is not used.

## Section Format

Every entry starts with a level-2 heading containing the identifier and a
parenthesized phase tag:

```markdown
## TODO-042-14:32:15  (plan)

scope: ...
files: ...
diagram: ...
done-criteria: ...
```

```markdown
## TODO-042-15:18:42  (execution)

what:   ...
why:    ...
impact: ...
files-changed:
  - src/foo.ts
  - src/bar.ts
```

```markdown
## TODO-042-17:21:08  (review-response)

ref: project-docs/reviews/2026-05-02_160511.md

### Critical
1. [o] [src/foo.ts:42] description
   change: ...

### Warning
1. [/] [src/bar.ts:88] description
   reason: deferred by user — out of scope for this TODO
```

## Rules

1. **Language**: 한국어 작성 허용 (단, 클래스명, API 엔드포인트, 변수명, 수도코드 등 기술 명세 및 식별자는 영어로 기입).
2. **Immutability**: Once written, an existing section is never edited
   in place. Corrections create a new section with a new identifier.
3. **Traceability**: Review responses must reference the originating
   review file path.
4. **No auto-trigger**: Claude Code does NOT poll `reviews/`. Review
   responses happen only when the user explicitly forwards a review.
5. **No frontmatter**: Plain markdown only — no Obsidian `---` / `tags:` block.

## Trigger & Automation

- AI agents run the work-log flow using the **Work Journal Writing Skill** guidelines defined in [skill-write-journal.md](../conventions/skill-write-journal.md).
- If multiple sessions or additional tasks occur on the same day, agents follow the **Append Rules** defined in the skill file to append new session details rather than overwriting.

For review responses, the user explicitly shares a review file path:

```
Read project-docs/reviews/YYYY-MM-DD_HHMMSS.md and propose a response plan.
```
