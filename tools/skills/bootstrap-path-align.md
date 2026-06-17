# skill: bootstrap-path-align

프로젝트의 인덱스·지시 문서(`CLAUDE.md`·`GEMINI.md`·`README.md`·각 디렉토리 `README.md`)가 **참조하는 경로**를 **실제 on-disk 구조**와 대조해 정렬하는 절차다. 경로는 프로젝트마다 다르고 시간이 지나며 drift하므로(참조했는데 없음 / 있는데 미참조 / 나열 순서 어긋남), 이를 자동 검출·교정한다.

자동 인식 skill이 아니라 `@project-docs/tools/skills/bootstrap-path-align.md` **멘션 실행** 문서다. **검출·제안은 자유, 실제 수정은 인덱스/지시 문서에 한정하고 사용자 승인 후** 적용한다 (content 디렉토리 불가침).

## 언제 쓰나

- 새 프로젝트에 본 시스템을 적용한 직후 (bootstrap-project Step 4 검증).
- 디렉토리를 추가·개명·이동한 뒤 (cross-ref가 따라왔는지 확인).
- "참조가 깨진 것 같다" / 주기적 정합 점검.

## 검출 3종 (buckets)

1. **broken (참조했는데 없음)** — 지시·인덱스 문서가 가리키는 경로가 disk에 없음. 가장 위험 — 에이전트가 헛 경로를 신뢰하게 된다.
2. **undocumented (있는데 미참조)** — disk에 있는 top-level 디렉토리·핵심 문서가 어떤 인덱스에도 안 잡힘.
3. **order drift (순서 어긋남)** — README 디렉토리 가이드/읽는 순서의 나열이 실제 트리와 불일치.

## 절차

1. **on-disk 경로 집합 수집**
   ```bash
   cd <workspace>/project-docs
   find . -not -path './.git/*' | sort
   ```
   워크스페이스 루트의 `CLAUDE.md`·`GEMINI.md`도 대상(이들이 `project-docs/` 하위를 참조).

2. **참조 경로 집합 추출** — 지시·인덱스 문서에서 경로·링크를 뽑는다.
   ```bash
   grep -rInE 'project-docs/[A-Za-z0-9_./-]+' <indices>   # project-docs/ 형태 경로
   grep -roE '\]\(([^)]+)\)' <indices>                    # 마크다운 상대링크
   ```
   대상: `CLAUDE.md` `GEMINI.md` `README.md` + 각 디렉토리 `README.md`.

3. **3-bucket diff**
   - broken: 참조 경로를 상대 resolve(`realpath -m`) 후 `[ -e ]` 실패분.
   - undocumented: disk top-level 디렉토리 중 README 디렉토리 가이드에 없는 것.
   - order drift: README 트리/읽는 순서 나열 ↔ 실제 디렉토리 순서 대조.

4. **보고** — bucket별 `파일:라인 → 경로` 형태. 추정 말고 검출된 것만.

5. **정렬안 제시 → 승인 후 적용** — 수정은 인덱스/지시 문서에 한정. broken은 "참조 교정" vs "대상 생성" 중 사용자 선택. content 파일은 건드리지 않는다.

## 참고 실행 예 (broken 검출 한 방)

```bash
cd <workspace>/project-docs
while IFS= read -r f; do
  d=$(dirname "$f")
  while IFS= read -r link; do
    case "$link" in http*|\#*|"") continue;; esac
    t="${link%%#*}"; [ -z "$t" ] && continue
    r=$(cd "$d" && realpath -m "$t")
    [ -e "$r" ] || echo "BROKEN  $f -> $link"
  done < <(grep -oE '\]\(([^)]+)\)' "$f" | sed -E 's/^\]\(//; s/\)$//')
done < <(find . -name '*.md' -not -path './.git/*')
```

> ⚠️ 본 skill은 인덱스/지시 문서의 **경로 정합**만 본다. 내용의 옳고 그름·문서 품질은 범위 밖이다. 트리거 = `@project-docs/tools/skills/bootstrap-path-align.md`.
