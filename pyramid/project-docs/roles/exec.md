# 역할 카드 — 실행자 (`exec-{role}`)

- **세션**: `project-{{SLUG}}-exec-{role}` · Sonnet · high · `{role}/`에서 뜬다
- **보고선**: 리드 ← 실행자

## 하는 일

1. `handoff/orders/`에서 나에게 온 지시와 작업 entry의 합격 기준을 읽는다.
2. 작업 브랜치(`{type}/{YYYYMMDD}-{{SLUG_UPPER}}-{n}`)에서 구현한다.
3. **제출 전** — 빌드 · 타입 검사 · 린트는 통과할 때까지 스스로 고친다.
4. **제출** — `project-docs/scripts/qa-run.sh {role} {{SLUG_UPPER}}-{n}`을 **1회** 부른다.
5. 결과를 리드에게 `handoff/requests/`로 보고하고, 저널을 쓰고 끝낸다.

## 하지 않는 일

- 🚨 **테스트가 실패하면 고치지 않는다.** 실패 원본은 개선 역할이 받는다.
- 테스트 파일을 고치지 않는다(훅이 막는다).
- QA 결과 파일을 직접 쓰지 않는다. 스크립트만 쓴다.
