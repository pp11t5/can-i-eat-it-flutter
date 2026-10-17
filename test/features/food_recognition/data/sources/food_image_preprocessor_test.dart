import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

import 'package:can_i_eat_it/features/food_recognition/data/sources/food_image_preprocessor.dart';

void main() {
  // ---------------------------------------------------------------------------
  group('centerCropWindow — 짧은 변 기준 정사각형, 홀수 차이는 내림 (input_rules.md §3)', () {
    test('정사각형 입력은 오프셋 0', () {
      final crop = FoodImagePreprocessor.centerCropWindow(100, 100);
      expect(crop.size, 100);
      expect(crop.offsetX, 0);
      expect(crop.offsetY, 0);
    });

    test('가로가 더 긴 경우 — 짝수 차이', () {
      final crop = FoodImagePreprocessor.centerCropWindow(100, 60);
      expect(crop.size, 60);
      expect(crop.offsetX, 20); // (100-60)/2 = 20
      expect(crop.offsetY, 0);
    });

    test('가로가 더 긴 경우 — 홀수 차이는 내림', () {
      // (101-50) = 51, 51 ~/ 2 = 25 (내림, 26이 아님)
      final crop = FoodImagePreprocessor.centerCropWindow(101, 50);
      expect(crop.size, 50);
      expect(crop.offsetX, 25);
      expect(crop.offsetY, 0);
    });

    test('세로가 더 긴 경우 — 홀수 차이는 내림', () {
      final crop = FoodImagePreprocessor.centerCropWindow(50, 101);
      expect(crop.size, 50);
      expect(crop.offsetX, 0);
      expect(crop.offsetY, 25);
    });
  });

  // ---------------------------------------------------------------------------
  group('halfPixelSource — TF bilinear half-pixel center (input_rules.md §4)', () {
    test('다운샘플 4→2: out=0 → src=0.5, out=1 → src=2.5', () {
      final s0 = FoodImagePreprocessor.halfPixelSource(0, 2, 4);
      expect(s0.$1, 0); // low
      expect(s0.$2, 1); // high
      expect(s0.$3, closeTo(0.5, 1e-9)); // frac

      final s1 = FoodImagePreprocessor.halfPixelSource(1, 2, 4);
      expect(s1.$1, 2);
      expect(s1.$2, 3);
      expect(s1.$3, closeTo(0.5, 1e-9));
    });

    test('업샘플 경계에서 clamp — low == high, out-of-range 없음', () {
      // inSize=2, outSize=4: 마지막 out index는 원시 src가 inSize-1을 넘는다.
      final last = FoodImagePreprocessor.halfPixelSource(3, 4, 2);
      expect(last.$1, lessThanOrEqualTo(1));
      expect(last.$2, lessThanOrEqualTo(1));
      expect(last.$1, greaterThanOrEqualTo(0));
    });

    test('동일 크기(224→224)는 모든 out이 정수 저점으로 매핑', () {
      final s = FoodImagePreprocessor.halfPixelSource(10, 224, 224);
      expect(s.$1, 10);
      expect(s.$2, 11);
      expect(s.$3, closeTo(0.0, 1e-9));
    });
  });

  // ---------------------------------------------------------------------------
  group('preprocess — 전체 파이프라인', () {
    test('출력 shape는 [1,224,224,3]', () {
      final image = img.Image(width: 50, height: 80);
      img.fill(image, color: img.ColorRgb8(10, 20, 30));
      final bytes = img.encodePng(image);

      final tensor = FoodImagePreprocessor.preprocess(bytes);

      expect(tensor.length, 1);
      expect(tensor[0].length, 224);
      expect(tensor[0][0].length, 224);
      expect(tensor[0][0][0].length, 3);
    });

    test('균일한 색상 입력 → 출력 픽셀 값도 그대로(정규화되지 않음, 0..255 유지)', () {
      final image = img.Image(width: 300, height: 200);
      img.fill(image, color: img.ColorRgb8(128, 64, 32));
      final bytes = img.encodePng(image);

      final tensor = FoodImagePreprocessor.preprocess(bytes);
      final center = tensor[0][112][112];

      // 128 → ~128.0 (0.5나 -1 근방이 아님 — /255, [-1,1] 정규화 금지).
      expect(center[0], closeTo(128.0, 1e-6));
      expect(center[1], closeTo(64.0, 1e-6));
      expect(center[2], closeTo(32.0, 1e-6));
      expect(center[0], isNot(closeTo(0.5, 0.1)));
      expect(center[0], isNot(closeTo(-1.0, 0.1)));
    });

    test('center-crop 오프셋이 실제로 적용된다 (가로가 더 긴 이미지)', () {
      // 300x200 → crop size=200, offsetX=50, offsetY=0 (centerCropWindow와 동일 계산).
      final image = img.Image(width: 300, height: 200);
      img.fill(image, color: img.ColorRgb8(0, 0, 0)); // crop 밖: 검정
      img.fillRect(
        image,
        x1: 50,
        y1: 0,
        x2: 249,
        y2: 199,
        color: img.ColorRgb8(200, 100, 50), // crop 안: 다른 색
      );
      final bytes = img.encodePng(image);

      final tensor = FoodImagePreprocessor.preprocess(bytes);

      // crop 영역이 균일한 색이므로 리사이즈 결과도 전부 그 색이어야 한다.
      // offsetX가 틀리면 검정(바깥) 영역이 섞여 값이 달라진다.
      for (final corner in [
        tensor[0][0][0],
        tensor[0][0][223],
        tensor[0][223][0],
        tensor[0][223][223],
        tensor[0][112][112],
      ]) {
        expect(corner[0], closeTo(200.0, 1.0));
        expect(corner[1], closeTo(100.0, 1.0));
        expect(corner[2], closeTo(50.0, 1.0));
      }
    });
  });
}
