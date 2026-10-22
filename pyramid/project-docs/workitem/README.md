# workitem — 작업 번호와 작업 entry

- 번호는 `{{SLUG_UPPER}}-{n}`이다. **총괄만** `REGISTRY.md`에 한 줄을 추가해 발급한다.
- 일정 · 상태는 Phronesis 항목이 맡고, 항목 본문에 번호를 적는다. 여기는 **설계와 합격 기준**을 담는다.
- entry: `data/{{SLUG_UPPER}}-{n}.md`

```markdown
# {{SLUG_UPPER}}-{n} 제목
- 역할: server
- 브랜치: feature/{YYYYMMDD}-{{SLUG_UPPER}}-{n}

## 목표
## 합격 기준          ← 리드가 구현 전에 쓴다
## 테스트 위치        ← 리드가 먼저 쓴 테스트 경로
## 설계
## 리뷰               ← plan-review · work-review 리포트 경로
```
