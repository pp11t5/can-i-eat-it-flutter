<!-- PR 본문: 무엇을·왜 바꿨는지 요약하고 관련 이슈를 닫아라. -->

## 요약

<!-- 변경 내용 1~3줄 -->

Closes #

## 체크리스트

### 공통
- [ ] `flutter analyze` 0 issues
- [ ] `dart run custom_lint` 0 issues
- [ ] `flutter test` 통과
- [ ] 애너테이션(freezed/riverpod/retrofit) 변경 시 `dart run build_runner build --delete-conflicting-outputs` 재생성 + 생성물 커밋

### 디자인 시스템 가드레일 (ADR-0005)
- [ ] **원시 색상값 직접 사용 없음** — `Color(0xFF...)`는 `lib/app/theme/tokens/` 안에서만. 위젯/화면은 `AppColors` 경유
- [ ] **원시 간격/반경 직접 사용 없음** — 숫자 `EdgeInsets`/`BorderRadius` 대신 `AppSpacing` 경유
- [ ] 텍스트 스타일은 `AppTextStyles`/`Theme.of(context).textTheme` 경유
- [ ] (검증) `grep -rn "Color(0xFF" lib/ --include="*.dart" | grep -v "lib/app/theme/tokens/"` → 0건
- [ ] 골든 테스트가 깨졌다면 의도된 변경인지 확인하고 diff를 PR에 첨부 (의도 시에만 `flutter test --update-goldens`)

### 의료성 카피
- [ ] "치료/진단/처방" 단정 표현 없음 (면책 고지의 부정형 제외), 결과 화면에 `MedicalDisclaimer` 노출
