# {MODULE} API

> 우선순위 분포: P0 N건 / P1 N건 / P2 N건
> 상태: [구현 가능] 또는 [⚠️ 의도적 미결 — 사유 / 본격 진행은 TODO-N]
> 관련 도메인 spec: `specs/{Domain}_vX.X.md`
> 관련 공통 정책: [POLICIES.md](POLICIES.md) — [정책-N]

---

## 모듈 한정 정책

(모듈 내부에만 적용되는 정책. 없으면 섹션 생략.)

---

## API 항목

### N. {기능명}

- **우선순위**: P0
- **METHOD URI**: `POST /...`
- **인증**: Token=FALSE / Guest=FALSE
- **코인 사용**: FALSE
- **설명**: 한 줄 요약
- **비고**: TSV 비고 컬럼 그대로

**Request**

- Query: `(없음)` 또는 `param: type`
- Body:
  ```
  email: string
  password: string
  ```

**Response**

- Status:
  - 200 OK — 성공 케이스 설명
  - 400 Bad Request — 실패 케이스 설명
- Body:
  ```
  user.id: string
  user.handle: string
  ```

**DB 영향**

- user_auth (read): 이메일/비밀번호 검증
- user (read): 프로필 조회

**메모**

🚨 critical 메모

⚠️ 주의 메모

ℹ️ 참고 메모

---

## 작성 가이드

본 템플릿 사용 시 다음 룰을 지킬 것:

1. **원본 보존 원칙**: TSV 원본 셀의 내용을 *임의 추출/요약하지 않는다*. 형식 정돈(줄바꿈, 헤딩, 마커 분리)만 허용. 모듈 한정 정책 추출은 *해석 비용 영역*이라 본 entry 범위 밖 (후속 다듬기 라운드에서 처리).
2. **마커 일관성**:
   - 🚨 = TSV 원본의 🚨 (critical)
   - ⚠️ = TSV 원본의 ⚠️ (주의)
   - ℹ️ = TSV 원본에 마커 없는 일반 메모 (예: 🤪 같은 비공식 마커 포함)
3. **DB 영향 분기 표시**: 원본이 `[기존 회원 플로우]` 식 인라인 분기일 경우 markdown 서브헤딩으로 분리.
4. **Body 안 주석**: 타입 옆 부연 설명은 `#` 사용.
5. **상태 마킹**: 미결 영역은 헤더 `상태:` 라인에 `⚠️ 의도적 미결 — 사유 / 본격 진행은 TODO-N` 명시. 같은 사유를 stub 코드에서도 동일 문구로 박을 수 있도록.
