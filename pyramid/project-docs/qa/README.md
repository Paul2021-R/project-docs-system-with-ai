# qa — QA 스크립트의 원본 결과

`scripts/qa-run.sh`만 쓴다. 사람과 세션은 읽기만 한다.

```
qa/{{SLUG_UPPER}}-{n}/run-{k}-{YYYYMMDD-HHMMSS}.log   # 테스트 출력 원본
qa/{{SLUG_UPPER}}-{n}/run-{k}-{YYYYMMDD-HHMMSS}.json  # 판정
```

판정은 각 저장소 `scripts/test.sh`의 종료 코드로 정한다.

| 종료 코드 | 판정 | 다음 |
|:--|:--|:--|
| 0 | `pass` | 리드가 work-review |
| 1 | `test-fail` | 리드가 개선(`fix-*`) 기동 |
| 2 | `env-fail` | infra 리드에게 보고 |
| 그 밖 | `unknown` | 리드가 원본을 보고 판단 |
