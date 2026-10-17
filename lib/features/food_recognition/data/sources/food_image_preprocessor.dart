import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// MobileNetV3 입력 텐서 전처리 (`input_rules.md`).
/// 디코딩 → EXIF 보정 → center-crop → half-pixel bilinear 224×224 →
/// `[1,224,224,3]` float32, 0..255 그대로(정규화 금지).
class FoodImagePreprocessor {
  const FoodImagePreprocessor._();

  static const int inputSize = 224;

  /// 디코딩 실패 시 [ArgumentError].
  static List<List<List<List<double>>>> preprocess(Uint8List imageBytes) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw ArgumentError('이미지를 디코딩할 수 없습니다 (JPEG/PNG만 지원).');
    }
    final oriented = img.bakeOrientation(decoded);
    final crop = centerCropWindow(oriented.width, oriented.height);
    return [_resizeToTensor(oriented, crop)];
  }

  /// 짧은 변 기준 center-crop 윈도우. 홀수 차이는 오프셋을 내림한다.
  static ({int size, int offsetX, int offsetY}) centerCropWindow(
    int width,
    int height,
  ) {
    final size = width < height ? width : height;
    final offsetX = (width - size) ~/ 2;
    final offsetY = (height - size) ~/ 2;
    return (size: size, offsetX: offsetX, offsetY: offsetY);
  }

  /// TF bilinear(half-pixel center) 리사이즈의 소스 좌표. 저/고 인덱스는 `[0, inSize-1]`로 clamp.
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

  // ponytail: image 패키지 copyResize는 half-pixel 보간이 아니라 TF와 결과가 달라 직접 구현.
  // crop은 offset을 더해 한 번에 샘플링한다.
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
        // RGB만 사용(알파 제외).
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
