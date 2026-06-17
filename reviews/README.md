# Reviews — External Review Reports

이 디렉토리는 **리뷰 보고서 산출물**을 담는다 — 리뷰어가 명시적으로 staged diff + 변경 파일을 검토하도록 지정됐을 때 나오는 보고서다. 리뷰어는 리뷰 역할을 부여받은 에이전트, 외부 도구, 또는 사람일 수 있다. 본 디렉토리는 그 결과 보고서의 보관 장소일 뿐이다.

> Claude와 Gemini는 **동일 룰셋 위의 peer 실행 에이전트**다 (`CLAUDE.md` / `GEMINI.md` — 구조 동일, 지칭 명사만 다름). "리뷰"는 둘 중 누구에게든 부여할 수 있는 task이지, 별도의 상시 에이전트가 아니다.

## Naming

```
YYYY-MM-DD_HHMMSS.md
```

`HHMMSS`는 보고서 작성 시각. 하루 여러 리뷰는 독립 파일이다 (`work-journal/`과 달리 누적하지 않음).

## Lifecycle

- **Immutable**: 보고서는 작성 후 수정하지 않는다. 재리뷰는 새 파일을 만든다.
- **Append-only 디렉토리**: 새 보고서 파일만 추가한다. 기존 보고서는 수정·삭제하지 않는다.

## Forwarding (opt-in)

에이전트는 이 디렉토리를 자동으로 읽지 않는다. 리뷰에 대응시키려면 파일 경로를 명시 전달한다:

```
Read project-docs/reviews/YYYY-MM-DD_HHMMSS.md.
For each Critical and Warning, propose a response plan and wait for my approval.
```

그러면 에이전트는 오늘 `work-journal/YYYY-MM-DD.md`에 `(review-response)` 섹션을 누적한다.

## Cleanup

30일 지난 보고서는 사용자가 `specs/archive/`로 아카이브할 수 있다. 자동 삭제는 스크립트화하지 않는다 — 리뷰 history는 유용한 audit 자료다.
