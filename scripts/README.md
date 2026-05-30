# Scripts — Lightweight Tool Layer

This directory holds small bash utilities that agents can invoke directly.

Think of it as a layer **below MCP**:

- MCP servers expose rich capabilities through a protocol — heavier, structured.
- These scripts are single-purpose shell commands — lightweight, immediate.

When an action is small enough to fit in a few lines of bash and doesn't
need MCP's structured I/O, it lives here. Agents call them as plain commands.

> ⚠️ 본 시스템 추출본에는 스크립트 본체(`.sh`)를 포함하지 않는다.
> 도구는 프로젝트별로 추가한다. 아래 규약만 시스템 레이어로 유지한다.

## Current Tools

| Script | Purpose |
|--------|---------|
| (프로젝트별 추가) | — |

## Logs

Tool invocation logs are written to `scripts/logs/YYYY-MM-DD_{tool}.log`.

## Adding a New Tool

1. Single responsibility — one script, one job.
2. Read configuration from root `.env` (never hardcode credentials).
3. Write logs to `scripts/logs/YYYY-MM-DD_{tool}.log` when the action has
   external effect (network call, file system change, etc.).
4. Exit non-zero on failure so callers can detect it.
5. Document usage at the top of the script as a comment.
6. Add an entry to the table above.

## Naming Convention

- Lowercase, hyphenated: `notify.sh`, `slice.sh`, `archive-old.sh`
- Prefer verb-form names that describe the action.
