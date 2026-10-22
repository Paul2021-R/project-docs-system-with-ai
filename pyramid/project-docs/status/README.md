# status — 역할별 현재 상태

역할마다 `status/{역할}.md` 한 장만 쓴다. 덮어쓰기로 갱신한다(이 폴더만 예외).

```markdown
# lead-server
- 갱신: 2026-10-22 14:30
- 지금: {{SLUG_UPPER}}-12 설계 · plan-review 대기
- 막힘: 없음
- 다음: exec-server 기동
```

세션이 살아 있는지는 `claude agents --json`이 알려 준다. 이 파일은 **무엇을 하고 있는지**만 담는다.
