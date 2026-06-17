# skill: catchup

세션 시작 시 **"지금 어디까지 왔고 다음에 뭘 하나"를 빠르게 읽어 정리**하는 절차다. 순수 **읽기 전용**(어떤 파일도 변경하지 않는다). 자동 인식 skill이 아니라 `@project-docs/tools/skills/catchup.md` **멘션 실행** 문서다.

## 작업 닫기와의 페어 (시작-끝)

- 작업 닫기(work-wrap-up 류) = workitem 정리·동기화·커밋 직전까지.
- **본 catchup** = 작업 열기: 직전 상태를 읽어 진입점을 잡는다. 변경 없음, 보고만.

## 읽는 대상 — SoT 위계 (혼동 방지)

1. **`workitem/backlog/INDEX.md` = 작업 상태 SoT (1순위).** workitem 이동마다 갱신되는 live 문서라 "현재 상황"의 진실 기준이다. active·in-progress·deferred·진입점은 **여기서** 읽는다.
2. **최근 `work-journal/{YYYY-MM-DD}.md`의 `## 미완 / 다음` = 보조(cross-check).** append-only 스냅샷이라 그날 이후 INDEX가 움직이면 **뒤처질 수 있다**. "마지막 세션의 의도" 맥락 + INDEX와의 정합 확인용으로만. 단독으로 현재 상태를 단정하지 않는다.

## 절차

1. **INDEX 읽기 (SoT)**: `workitem/backlog/INDEX.md` 상단 진입점 마커와 active 블록.
   - in-progress: `grep -rl 'status: in-progress' workitem/backlog/data/`
   - deferred: `grep -rl 'status: deferred' workitem/backlog/data/` (⚠️ INDEX 본문을 `grep deferred`로 긁지 말 것 — 결정 본문·주석까지 섞여 노이즈가 된다. status 필드 기준으로.)
2. **최근 work-journal 선택 (보조)**: 존재하는 최신 파일을 택한다.
   - ⚠️ "어제"를 날짜 계산으로 잡지 말 것 — 그날 작업이 없으면 파일이 없다. `ls work-journal/ | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$' | sort | tail -1`.
3. **미완/다음 cross-check**: 그 파일의 `## 미완 / 다음`을 INDEX 진입점과 대조.
   - **일치** → 확신 신호. 진입점 그대로.
   - **불일치** → 그 diff 자체가 핵심 정보(INDEX가 journal 이후 이동했거나, journal이 INDEX 미반영 맥락 보유). 보고에 **명시**.
4. **요약 보고** (3블록, 덤프 아닌 진입점 중심):
   - **지금 위치**: (INDEX) active 블록 / in-progress entry.
   - **다음 진입점**: (INDEX) 진입점 지점 — 최근 journal `미완/다음`과 일치/불일치 명시.
   - **열린 항목**: (INDEX) `status: deferred` / 착수 시 확정 대기 결정.

   모든 상태 판단의 근거는 INDEX, journal은 보강·정합 신호로만.

## 참고 실행 예

```bash
cd <workspace>/project-docs
grep -nE '진입점|Currently active' workitem/backlog/INDEX.md
grep -rl 'status: in-progress' workitem/backlog/data/ || echo "(in-progress 없음)"
grep -rl 'status: deferred'    workitem/backlog/data/ || echo "(deferred 없음)"
LATEST=$(ls work-journal/ | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.md$' | sort | tail -1)
echo "최근 journal: $LATEST"
awk '/^## 미완 \/ 다음/{p=1} p' "work-journal/$LATEST"
```

> ⚠️ 본 skill은 읽기만 한다. workitem 이동·status 변경·커밋 등 mutation은 범위 밖이다(그건 work-wrap-up 또는 명시 지시). 트리거 = `@project-docs/tools/skills/catchup.md`.
