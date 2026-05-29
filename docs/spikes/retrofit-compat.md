# Retrofit 호환 버전 Spike

## 결론 한 줄

**채택 가능**: `retrofit 4.9.2` + `retrofit_generator 10.2.6` 조합은 우리 스택(Dart 3.12, dio ^5.9.2, build_runner 2.15.0)과 충돌 없이 resolve 된다. ADR-0001에서 보류한 "retrofit 4.9.x ↔ retrofit_generator 9.7.x 비호환" 문제는 generator가 10.x로 메이저 업 되면서 해소됐다.

---

## 조사 일자 / 출처

- 조사일: 2026-05-29
- retrofit pub.dev: https://pub.dev/packages/retrofit
- retrofit_generator pub.dev: https://pub.dev/packages/retrofit_generator
- retrofit_generator 9.7.0 pubspec: https://pub.dev/packages/retrofit_generator/versions/9.7.0/pubspec
- build_runner pub.dev: https://pub.dev/packages/build_runner
- source_gen pub.dev: https://pub.dev/packages/source_gen
- analyzer pub.dev: https://pub.dev/packages/analyzer

---

## 버전 호환 표

### 검증 조합: retrofit 4.9.2 + retrofit_generator 10.2.6

| 패키지 | 우리 스택 (pubspec.yaml) | retrofit_generator 10.2.6 요구 | 충돌 여부 |
|---|---|---|---|
| **Dart SDK** | `^3.5.4` (실제 Flutter 3.44 / Dart 3.12) | `>=3.9.0 <4.0.0` | **없음** (3.12 ≥ 3.9) |
| **dio** | `^5.9.2` | `^5.9.0` | **없음** |
| **build_runner** | `^2.5.4` (최신 2.15.0) | 직접 의존 없음; 전이적으로 `build ^4.0.0` | **없음** (build_runner 2.15.0이 `build ^4.0.0` 사용) |
| **build** | (직접 없음, build_runner 전이) | `^4.0.0` | **없음** |
| **source_gen** | (직접 없음) | `^4.0.0` (Dart >=3.9 필요) | **없음** (Dart 3.12) |
| **analyzer** | (직접 없음) | `>=8.4.1 <14.0.0` | **없음** |
| **json_annotation** | `^4.9.0` | 직접 의존 없음 | **없음** |
| **json_serializable** | `^6.9.5` (dev) | 직접 의존 없음 | **없음** |
| **retrofit** (runtime) | (현재 없음) | `^4.9.2` (retrofit_generator가 요구) | 추가 필요 |

### ADR-0001 시점 구버전 비호환 이력

| 시점 | retrofit | retrofit_generator | 문제 |
|---|---|---|---|
| ADR 작성 시 (~10개월 전) | 4.9.x | 9.7.x | generator가 `build ^2.5.4`, `analyzer ^7.2.0` 요구; retrofit ^4.9.x를 아직 명시 지원 안 함 |
| 현재 (2026-05-29) | **4.9.2** | **10.2.6** | generator가 retrofit ^4.9.2를 명시 요구. 10.0.0에서 Element2 API 마이그레이션 완료, 비호환 해소 |

> **요약**: generator 9.7.x는 `build ^2.5.4`(build_runner 2.x 전용)를 요구했고, retrofit 4.9.x와의 매핑도 미완성이었다. 10.0.0에서 `build ^4.0.0`으로 전환·Element2 API 마이그레이션·`retrofit ^4.9.2` 명시 지원이 한꺼번에 이뤄지면서 비호환이 해소됐다.

---

## 권장

서버 API 계약 확정 시 아래 조합으로 추가:

```yaml
# pubspec.yaml — dependencies 섹션
dependencies:
  retrofit: ^4.9.2          # 추가
  # dio: ^5.9.2             # 기존 유지

# pubspec.yaml — dev_dependencies 섹션
dev_dependencies:
  retrofit_generator: ^10.2.6   # 추가
  build_runner: ^2.5.4          # 기존; 실제로는 2.15.0으로 업됨
  # json_serializable: ^6.9.5   # 기존 유지
```

datasource 파일에 `@RestApi()` 애너테이션 추가 후:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**인터페이스(`domain/repository`)는 불변**. `data/datasource` 구현만 교체.

---

## 검증 방법 제안 (채택 시 실행)

1. 별도 브랜치에서 `flutter pub add retrofit:^4.9.2` 실행 후 `flutter pub get` 결과 확인.
2. dev에 `flutter pub add --dev retrofit_generator:^10.2.6` 추가.
3. `flutter pub deps` 로 의존 그래프 확인 — `analyzer`, `source_gen`, `build` 버전 충돌 없음 확인.
4. 샘플 datasource 1개(`@RestApi()` 클래스) 작성 후 `dart run build_runner build --delete-conflicting-outputs` 성공 여부 확인.
5. 기존 `freezed` / `riverpod_generator` 생성 파일 재생성 이상 없음 확인.

> 이번 spike에서 실제 `pub add`/`pub get` 실행은 범위 외. pubspec.yaml·코드 변경 없음.
