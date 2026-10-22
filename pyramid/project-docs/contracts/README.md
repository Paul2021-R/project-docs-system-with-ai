# contracts — 역할 사이의 계약

역할이 서로 만나는 지점은 계약으로만 정한다. **총괄만 고친다.** 리드가 바꿔야 하면 `handoff/requests/`에 `kind: proposal`로 올린다.

- `api.md` — server가 app · web에 주는 API
- `db.md` — 스키마
- `generation-ledger.md` — 생성물 메타데이터 장부(생성 단위마다 남길 필드)

계약이 바뀌면 영향받는 리드에게 `orders/`로 알린다.
