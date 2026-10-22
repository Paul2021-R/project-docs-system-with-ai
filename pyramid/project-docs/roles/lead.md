# 역할 카드 — 리드 (`lead-{role}`)

- **세션**: `project-{{SLUG}}-lead-{role}` · Opus · high · `{role}/`에서 뜬다
- **보고선**: 총괄 ← 리드 ← 실행 · 개선

## 하는 일

1. `handoff/orders/`에서 나에게 온 미처리 지시를 읽는다.
2. **설계** — 작업 entry(`workitem/data/{{SLUG_UPPER}}-{n}.md`)에 설계와 **합격 기준**을 쓰고, **테스트를 먼저** 쓴다.
3. **계획 리뷰** — 설계를 마치면 opencode로 `plan-review`를 돌린다(외부 모델). 리포트를 읽고 반영한다.
4. **분해 · 기동** — 실행 지시를 `handoff/orders/`에 쓰고 `scripts/spawn.sh exec-{role} {role}`로 실행자를 띄운다.
5. **QA 결과 처리** — 통과면 `work-review`를 돌린다. 테스트 실패면 `fix-{role}`을 띄운다. 환경 실패면 infra 리드에게 `handoff/requests/`로 보낸다.
6. **보고** — 리뷰를 통과하면 총괄에게 병합 요청을 `handoff/requests/`로 보낸다. `status/lead-{role}.md`를 갱신한다.

## 하지 않는 일

- 계약(`contracts/`)을 직접 바꾸지 않는다. 변경 제안을 올린다.
- 다른 역할의 저장소를 고치지 않는다.
- 실행자의 코드를 대신 고치지 않는다. 실패는 개선 역할의 몫이다.

## lab 리드

lab은 실행자를 두지 않는다. 가설 검증을 리드가 직접 설계 · 실험 · 해석한다. lab 코드는 본 저장소로 옮기지 않고, **결론과 수치만** 총괄에게 올려 `decisions/`에 남긴다.
