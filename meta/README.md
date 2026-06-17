# Meta

워크스페이스 운영 과정에서 나오는 메타 산출물(백업·스냅샷) 보관소. content(프로젝트가 *무엇인지*)도 tools(운용 도구)도 아닌, 운영의 흔적을 둔다.

## 담는 것 (예)

- `claude-backups/` — `CLAUDE.md` / `GEMINI.md`의 타임스탬프 백업.
- `skill-backups/` — 전역 등록 skill 백업 (PC 이식용, `{YYYY-MM-DD}/` + `_MANIFEST.md`).
- 마이그레이션 스냅샷 등 일회성 운영 산출물.

백업 본체는 프로젝트 인스턴스 데이터다 — `.gitignore` 또는 별도 보관 정책에 따른다. 본 README는 "무엇을 어디에 보관하는가"의 규약만 정의한다. 실제 백업/복원 절차가 필요하면 `tools/skills/`에 멘션 스킬로 둔다.
