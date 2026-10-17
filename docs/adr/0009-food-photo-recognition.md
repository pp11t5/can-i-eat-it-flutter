# ADR-0009: 음식 사진 인식 — 온디바이스(MobileNetV3) ↔ Gemini(백엔드 경유) 교체 가능 구조

- **Status**: Proposed (domain/data 구현 완료)
- **Date**: 2026-10-02
- **Decider(s)**: 프로젝트 팀
- **작성 근거**: 실측 `food_check` 레이어 구조(`food_category_providers.dart` 등), `pubspec.yaml`(ML/카메라/Gemini 의존성 전무 확인), `mobilenet`(README.md·input_rules.md·top3_output.md·model_metadata.json·labels.txt) 모델 계약, `docs/adr/0003-verdict-model-and-auth.md`

> **범위**: 이번 라운드는 설계와 domain/data 구현(§6의 1~6단계)까지다. 화면(presentation)은 목업이 확정되지 않아 한 차례 구현했다가 되돌렸고, 확정 후 별도로 진행한다. 엔진 교체 방식은 초기안(사용자 트리거 단계적 확대)에서 **코드 상수 고정**으로 수정했다(결정 D).

## 1. 의사결정 요약

신규 feature `food_recognition`을 만든다. 사진 1장을 넣으면 음식명 후보(최대 3개)를 돌려주는 단일 책임만 갖고, 신호등 판정(recommend/caution/risk/unknown)은 하지 않는다 — 인식된 음식명은 기존 `food_check`의 `judgeByText`/`judgeById`로 넘겨 기존 판정 파이프라인을 그대로 탄다.

인식 엔진은 **두 구현체를 모두 만들고, 어느 쪽을 쓸지는 코드 상수 하나로 고르게** 한다:

- **OnDevice**: 전달받은 MobileNetV3 TFLite 모델(150클래스 분류)을 기기에서 직접 추론.
- **Gemini**: 사진을 **자체 백엔드 API**로 전송해 서버가 Gemini를 호출하고 결과를 받아온다. 클라이언트는 Gemini API 키나 SDK를 직접 갖지 않는다.

교체는 이미 쓰고 있는 "Riverpod provider가 구현체를 결정한다" 패턴(`food_category_providers.dart` 등)을 엔진 선택으로 확장한 것이다. 선택은 `kFoodRecognitionEngine` 상수 한 줄이며 기본값은 OnDevice(모델 파일이 이미 있고 오프라인 동작)다. 백엔드 `/foods/recognize`류 엔드포인트가 나오기 전까지 Gemini 구현체는 **Mock**으로 대체한다

## 2. 옵션 비교

### 결정 A — Feature 경계

**Option A1 — `food_check` 내부에 포함**
- 장점: 파일 수 최소.
- 단점: 모델 asset·카메라 권한·외부 AI 연동처럼 변경 이유가 전혀 다른 코드가 텍스트 검색/판정 feature에 섞인다. `meal_log`에서도 진입점이 필요해지면 결국 분리해야 한다.

**Option A2 — 신규 `food_recognition` feature (채택)**
- 장점: 변경 이유가 분리된다. 다른 feature와는 presentation 레벨 라우팅(go_router)으로만 연결되고 domain 간 의존이 생기지 않는다.
- 단점: feature 하나 추가(경미).

### 결정 B — Domain 인터페이스 스키마 (150클래스 닫힌 집합 vs Gemini 개방형 결과의 비대칭 흡수)

**Option B1 — 구현체별 결과 타입 분리**
- 장점: 비대칭을 숨기지 않아 정직하다.
- 단점: UI가 두 타입을 따로 분기해야 해서 "교체 가능"의 의미가 사라진다.

**Option B2 — 단일 최소공통 스키마 (채택)**

```dart
abstract interface class FoodRecognitionRepository {
  Future<FoodRecognitionResult> recognize(Uint8List imageBytes);
}

class FoodRecognitionResult {
  final List<FoodCandidate> candidates; // 0~3개
  final RecognitionSource source;
}
class FoodCandidate {
  final String label;      // 자유 문자열 — 150클래스 제약은 구현 내부 사정
  final double? score;     // OnDevice: softmax 원점수 / Gemini: null(확률 아님, 지어내지 않음)
}
enum RecognitionSource { onDevice, gemini }
```

- 장점: UI·컨트롤러가 엔진을 몰라도 된다. 교체가 실제로 provider 하나만 바꾸는 일이 된다.
- 단점: `score` nullable 의미를 호출부가 이해하고 있어야 한다(주석/문서로 고정).

### 결정 C — Gemini 호출 경로

**Option C1 — 클라이언트에서 Gemini 직접 호출 (Firebase AI Logic 등)**
- 장점: 백엔드 개발 없이 바로 프로토타입 가능.
- 단점: API 키/과금이 앱 바이너리에 노출(App Check로 완화해야 하는 추가 보안 작업 필요), 프롬프트·모델 버전을 서버가 통제하지 못해 배포 없이 바꿀 수 없다. 이 프로젝트는 판정(의료성 AI) 로직을 전부 서버가 소유하는 원칙(ADR-0003)을 이미 갖고 있는데, 인식 AI만 클라이언트가 직접 소유하면 원칙이 어긋난다.

**Option C2 — 자체 백엔드 API 경유 (채택, 사용자 확정)**
- 장점: 키는 서버에만 존재. 프롬프트/모델 교체가 앱 배포 없이 가능. 기존 `dio_client` 패턴 그대로 재사용되어 신규 네트워킹 의존성이 없다. 판정 파이프라인과 동일한 "AI는 서버가 소유" 철학을 유지한다.
- 단점: 백엔드 엔드포인트가 나올 때까지 Gemini 경로는 Mock으로만 선개발 가능(단, 이 저장소에서 이미 모든 feature가 쓰는 익숙한 패턴이라 추가 비용은 작다).

### 결정 D — 교체 메커니즘

**Option D1 — `overrideWithValue` 단순 교체**: 개발/테스트용으로만 쓸 수 있고, 런타임 정책적 선택이 안 된다.

**Option D2 — 전역 feature flag(Remote Config)로 1택**: 실험에는 좋지만 사용자별로 다른 엔진을 못 쓰고, `firebase_remote_config` 신규 의존성이 필요하다.

**Option D3 — 자동 폴백 체인(confidence threshold로 전환)**: 학습 밖 음식에도 softmax가 높게 나올 수 있어 임계값으로 못 거른다. 몰래 Gemini를 호출해 비용·지연이 이중으로 든다.

**Option D4 — 엔진을 인자로 받는 provider + 코드 상수로 엔진 고정 (채택)**

```dart
/// 이 값만 바꾸면 OnDevice ↔ Gemini가 전환된다.
const kFoodRecognitionEngine = RecognitionSource.onDevice;

@riverpod
Future<FoodRecognitionRepository> foodRecognitionRepository(
  Ref ref,
  RecognitionSource engine,
) async {
  switch (engine) {
    case RecognitionSource.onDevice:
      // Interpreter·labels는 keepAlive provider로 앱 전역 1회 로드
      return OnDeviceFoodRecognitionRepository(interpreter: ..., labels: ...);
    case RecognitionSource.gemini:
      return const MockGeminiFoodRecognitionRepository(); // 백엔드 계약 전
  }
}
```

호출부는 `foodRecognitionRepositoryProvider(kFoodRecognitionEngine)`만 쓴다. 런타임 자동 전환이나 사용자 트리거 전환은 없다.

## 3. 선택 근거

선택: **A2 + B2 + C2 + D4**

- **기존 패턴의 확장**: `food_category_providers.dart`가 보여주는 "provider가 구현체를 고른다" 패턴에 엔진 인자만 추가한 것이라, 이 저장소에 새로운 전역 아키텍처 패턴을 만들지 않는다.
- **비용 통제**: 엔진을 코드에서 하나로 고정하므로 Gemini 호출은 의도적으로 켠 경우에만 발생한다. 자동 폴백(D3)처럼 몰래 이중 호출이 나지 않는다.
- **오프라인 우선**: 기본 경로(OnDevice)가 네트워크 없이도 항상 동작한다.
- **보안/원칙 일치**: Gemini 키가 앱에 없다(C2). 이 저장소가 이미 "AI·의료성 로직은 서버가 소유"로 정한 원칙(ADR-0003의 판정 파이프라인)과 인식 AI도 같은 모양이 된다.
- **선개발 가능**: 백엔드 `/foods/recognize`가 나오기 전에도 OnDevice는 바로 구현·출시 가능하고, Gemini는 Mock으로 UI/흐름을 먼저 완성해둘 수 있다.

## 4. 위험·전제

**위험**:
- **150클래스 한계**: 학습 밖 음식도 확신에 찬 오답이 나올 수 있다. → 화면 단계에서 후보 확인과 "맞는 항목 없음"(검색 전환) 경로를 두어야 한다(단정 금지, ADR-0003의 `unknown` 철학과 동일. 화면은 미구현).
- **전처리 드리프트**: EXIF 보정·center-crop·bilinear resize·정규화(`0..255` 그대로, `/255` 금지)가 `input_rules.md`와 조금만 어긋나도 에러 없이 정확도만 조용히 떨어진다. → Python TF 기준 출력과 비교하는 golden test 필요.
- **백엔드 엔드포인트 미정**: `/foods/recognize`의 요청/응답 계약이 아직 없다. 계약이 늦어지면 Gemini 경로가 Mock 상태로 장기 방치될 위험이 있다.
- **라벨-DB 어휘 불일치**: 인식된 라벨은 ID가 아니라 검색어로 `food_check`에 넘어간다. 150개 라벨이 실제 음식 DB에서 몇 개나 검색되는지 사전 측정이 필요하다.
- **프라이버시**: 건강 앱에서 사진이 서버(그리고 Gemini)로 전송된다. Gemini 경로를 실제로 켜기 전에 고지·동의, 개인정보처리방침 갱신이 필요하다.

**전제**:
- OnDevice Top-3 정확도가 기본 경로로 쓸 만하다(아직 실측 전).
- 백엔드팀이 `/foods/recognize`류 엔드포인트를 합의된 일정 내에 제공한다.

**전제 깨짐 신호**:
- (화면 도입 후) "맞는 항목 없음" 선택률이 비정상적으로 높으면 OnDevice 모델/기본 엔진을 재검토한다.
- 백엔드 엔드포인트 일정이 장기 지연되면 1차 출시를 OnDevice 단독으로 축소하고 Gemini는 후속 릴리스로 분리한다.

## 5. 신규 의존성

| 패키지 | 역할 | 선택 이유 |
|---|---|---|
| `tflite_flutter` | TFLite 추론 | TensorFlow 공식 배포, 유지되는 사실상 유일한 선택 |
| `image` | decode/EXIF 보정/center-crop | 순수 Dart라 `Isolate`에서 동작, half-pixel bilinear resize는 계약 일치를 위해 직접 구현 |

Gemini 호출은 **신규 의존성이 없다** — 기존 `dio_client`를 그대로 재사용한다(C2 채택의 핵심 이점).

## 6. 구현 순서 (후속 액션)

- [ ] **(선행, 확인 필요)** 사진의 서버 전송(결국 Gemini로 연결)에 대한 고지/동의 문구를 PO·법무와 확정 — Gemini 경로를 실제로 켜기 전 블로커.
- [x] `food_mobilenetv3_fp16.tflite` + `labels.txt`를 `assets/ml/`로 이동·등록, `tflite_flutter`/`image` 의존성 추가.
- [x] domain: `food_recognition_result.dart`(FoodCandidate·RecognitionSource·FoodRecognitionResult, freezed), `food_recognition_repository.dart`(인터페이스).
- [x] data(OnDevice) `[TDD]`: 전처리(EXIF·center-crop·224 bilinear resize) + Top-3 추출 + 단위 테스트. Interpreter는 생성자 주입.
- [x] data(Gemini) `[None]`: `MockGeminiFoodRecognitionRepository`. 계약 확정 시 `dio` 기반 실 구현으로 교체(인터페이스 불변).
- [x] `food_recognition_providers.dart`: Interpreter/라벨 1회 로드 + 엔진 인자 provider + `kFoodRecognitionEngine`.
- [x] `android/build.gradle`: `tflite_flutter` Kotlin/Java JVM 타겟 불일치 보정.
- [ ] presentation: 목업 확정 후 진행. 컨트롤러(`recognize`/`reset`) + 캡처 화면 → 결과 확인 → 후보 선택 시 기존 `judgeByText`로 연결. 실기기에서 모델 로딩도 이때 확인.
- [ ] 카메라 의존성 선택 및 Android `CAMERA` 권한, iOS `NSCameraUsageDescription` 추가(화면과 함께).
- [ ] `[TDD]` golden test: 샘플 이미지 1장 기준 Python TF 출력과 OnDevice Top-3 일치 확인.
- [ ] `[Review]` pr-reviewer: 이미지 업로드·모델 로딩 경로, Gemini 실 구현 교체 시점에 보안 리뷰.

## 참고 (실측 근거 파일)

`lib/features/food_check/domain/repositories/food_repository.dart`, `lib/features/food_check/data/food_check_providers.dart`, `lib/core/network/dio_client.dart`, `pubspec.yaml`, `android/build.gradle`, 모델 번들(`mobilenet/`의 `README.md`·`input_rules.md`·`top3_output.md`·`model_metadata.json`·`labels.txt`), `docs/adr/0003-verdict-model-and-auth.md`(AI는 서버가 소유하는 원칙의 선례).
