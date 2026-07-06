# can_i_eat_this

먹어도 돼? — 기저질환 기반 음식 섭취 판별 앱

## 셋업 (클론 직후 1회)

```bash
./scripts/bootstrap.sh
```

이 스크립트는 **SwiftPM을 끄고 CocoaPods로 iOS 플러그인을 관리**하도록 강제한다. Firebase iOS SDK(12.x, iOS 15 요구)와 Flutter가 생성하는 SwiftPM umbrella(`FlutterGeneratedPluginSwiftPackage`, `.iOS 13.0` 하한)가 충돌하기 때문이다. `flutter config`는 **머신 전역 설정**이라 레포에 담기지 않으므로 스크립트로 강제한다.

> ⚠️ **SwiftPM을 다시 켜지 말 것** (`flutter config --enable-swift-package-manager` 금지). 켜면 iOS 빌드가 `requires minimum platform version 15.0 ... but this target supports 13.0`로 깨진다. (배경: PR #147)

## 실행 방법

카카오 네이티브 앱키를 `--dart-define`으로 주입해 실행한다. 키는 비커밋 파일(예: `~/cieit-e2e.env`)에 보관 권장.

```bash
flutter run --dart-define=KAKAO_NATIVE_APP_KEY=<카카오_네이티브_앱키>
```

iOS 시뮬레이터 빌드만 확인할 경우:

```bash
flutter build ios --simulator --no-codesign --dart-define=KAKAO_NATIVE_APP_KEY=<카카오_네이티브_앱키>
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
