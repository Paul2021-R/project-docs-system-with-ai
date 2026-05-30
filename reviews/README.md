# Reviews — External Gemini Review Reports

This directory holds reports from the **external Gemini review-only agent**
(`GEMINI.md` in the project root). Gemini is invoked manually by the user;
it reads the staged diff plus changed files, writes one report file here,
sends a Discord notification, and terminates.

## Naming

```
YYYY-MM-DD_HHMMSS.md
```

`HHMMSS` is the time the agent began writing. Multiple reviews per day
are independent files (no accumulation, unlike `work-journal/`).

## Lifecycle

- **Immutable**: reports are never modified after creation. Re-review
  produces a new file.
- **Append-only directory**: Gemini only creates files here. It does not
  delete or modify existing reports.

## Forwarding to Claude Code

Claude Code does NOT automatically read this directory.

When you want Claude Code to act on a review, share the file path
explicitly in conversation:

```
Read project-docs/reviews/YYYY-MM-DD_HHMMSS.md.
For each Critical and Warning, propose a response plan and wait for my approval.
```

Claude Code will then append a `(review-response)` section to today's
`work-journal/YYYY-MM-DD.md` work log.

## Cleanup

Reports older than 30 days may be archived to `specs/archive/` by the user.
Do not script automatic deletion — review history is useful audit material.
