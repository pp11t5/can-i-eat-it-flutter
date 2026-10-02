import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// 음식 사진 전처리 — TFLite MobileNetV3 입력 텐서 생성 (ADR-0009 §4, `input_rules.md`).
///
/// JPEG/PNG 디코딩 → EXIF 방향 반영(bake) → RGB(알파 제외) center-crop →
/// TensorFlow bilinear(half-pixel center) 224×224 리사이즈 → `[1,224,224,3]`
/// float32, 픽셀 범위 `0..255` 그대로(정규화 금지)의 순서를 그대로 따른다.
///
/// 모든 수학 연산은 [centerCropWindow]·[halfPixelSource]로 쪼개 `Interpreter` 없이
/// 단위 테스트 가능하다.
class FoodImagePreprocessor {
  const FoodImagePreprocessor._();

  static const int inputSize = 224;

  /// 사진 1장([imageBytes])을 `[1,224,224,3]` float32 텐서로 변환한다.
  ///
  /// 디코딩 실패 시 [ArgumentError] (JPEG/PNG 외 포맷 또는 손상된 데이터).
  static List<List<List<List<double>>>> preprocess(Uint8List imageBytes) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw ArgumentError('이미지를 디코딩할 수 없습니다 (JPEG/PNG만 지원).');
    }
    // EXIF 방향 정보를 이미지에 반영(bake) — input_rules.md §1.
    final oriented = img.bakeOrientation(decoded);
    final crop = centerCropWindow(oriented.width, oriented.height);
    return [_resizeToTensor(oriented, crop)];
  }

  /// 짧은 변 기준 정사각형 center-crop 윈도우. 홀수 픽셀 차이는 왼쪽/위쪽
  /// 오프셋을 내림한다 (`input_rules.md` §3).
  static ({int size, int offsetX, int offsetY}) centerCropWindow(
    int width,
    int height,
  ) {
    final size = width < height ? width : height;
    final offsetX = (width - size) ~/ 2;
    final offsetY = (height - size) ~/ 2;
    return (size: size, offsetX: offsetX, offsetY: offsetY);
  }

  /// TensorFlow bilinear(half-pixel center) 리사이즈의 소스 좌표 계산
  /// (`input_rules.md` §4). [outIndex]에 대응하는 원본 축의 저/고 인덱스와
  /// 보간 가중치를 반환한다. 둘 다 `[0, inSize-1]`로 clamp되어, clamp로
  /// low == high가 되는 경계에서는 TF 구현과 동일하게 가중치가 결과에
  /// 영향을 주지 않는다.
  static (int low, int high, double frac) halfPixelSource(
    int outIndex,
    int outSize,
    int inSize,
  ) {
    final scale = inSize / outSize;
    final src = (outIndex + 0.5) * scale - 0.5;
    final clamped = src.clamp(0.0, (inSize - 1).toDouble());
    final low = clamped.floor();
    final high = (low + 1) > inSize - 1 ? inSize - 1 : low + 1;
    final frac = clamped - low;
    return (low, high, frac);
  }

  // ponytail: image 패키지의 copyResize는 half-pixel center 보간이 아니라
  // TF 출력과 어긋나(ADR-0009 §5) 직접 구현한다. crop을 별도 Image로 잘라내지
  // 않고 원본 좌표에 offset을 더해 그대로 샘플링해 center-crop과 resize를
  // 한 번에 처리한다.
  static List<List<List<double>>> _resizeToTensor(
    img.Image source,
    ({int size, int offsetX, int offsetY}) crop,
  ) {
    return List.generate(inputSize, (oy) {
      final (y0, y1, fy) = halfPixelSource(oy, inputSize, crop.size);
      return List.generate(inputSize, (ox) {
        final (x0, x1, fx) = halfPixelSource(ox, inputSize, crop.size);
        final p00 = source.getPixel(crop.offsetX + x0, crop.offsetY + y0);
        final p10 = source.getPixel(crop.offsetX + x1, crop.offsetY + y0);
        final p01 = source.getPixel(crop.offsetX + x0, crop.offsetY + y1);
        final p11 = source.getPixel(crop.offsetX + x1, crop.offsetY + y1);
        // RGB만 사용, 알파 채널 제외 (input_rules.md §2) — p.a를 읽지 않는다.
        return [
          _bilerp(p00.r, p10.r, p01.r, p11.r, fx, fy),
          _bilerp(p00.g, p10.g, p01.g, p11.g, fx, fy),
          _bilerp(p00.b, p10.b, p01.b, p11.b, fx, fy),
        ];
      });
    });
  }

  static double _bilerp(
    num c00,
    num c10,
    num c01,
    num c11,
    double fx,
    double fy,
  ) {
    final top = c00 + (c10 - c00) * fx;
    final bottom = c01 + (c11 - c01) * fx;
    return (top + (bottom - top) * fy).toDouble();
  }
}
