#!/usr/bin/env bash
# 프로젝트 셋업 스크립트 — 클론 직후 1회 실행.
#
# ⚠️ SwiftPM 재발 가드:
# iOS는 SwiftPM을 끄고 CocoaPods로 플러그인을 관리한다. Firebase iOS SDK
# (12.x, iOS 15 요구)와 Flutter가 생성하는 SwiftPM umbrella
# (FlutterGeneratedPluginSwiftPackage, .iOS "13.0" 하드코딩)가 충돌하기 때문이다.
# `flutter config`는 머신 전역 설정이라 레포에 담기지 않으므로 여기서 강제한다.
# SwiftPM을 다시 켜면 iOS 빌드가
#   "requires minimum platform version 15.0 ... but this target supports 13.0"
# 로 깨진다. (배경: PR #147)
set -euo pipefail

echo "▶ SwiftPM 비활성화 (Firebase 15.0 vs umbrella 13.0 충돌 방지)"
flutter config --no-enable-swift-package-manager

echo "▶ flutter pub get"
flutter pub get

if command -v pod >/dev/null 2>&1; then
  echo "▶ iOS pod install"
  ( cd ios && pod install )
else
  echo "⚠ CocoaPods(pod) 미설치 — iOS pod install 건너뜀 ('sudo gem install cocoapods')"
fi

echo "✓ 셋업 완료 — iOS 플러그인은 CocoaPods 관리 (SwiftPM OFF 유지)"
