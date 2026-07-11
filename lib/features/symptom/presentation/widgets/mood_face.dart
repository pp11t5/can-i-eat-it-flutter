import 'package:flutter/widgets.dart';

import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

/// 증상 상태 5단계 무드 얼굴.
///
/// Figma "emoji" 컴포넌트 세트(래스터 이미지)를 [SymptomState] 로 매핑해 렌더한다.
/// 이모지 리터럴 금지 규칙에 따라 😊🙂😐😕😣 대신 이 위젯을 사용한다.
class MoodFace extends StatelessWidget {
  const MoodFace({super.key, required this.state, this.size = 40});

  final SymptomState state;
  final double size;

  static const Map<SymptomState, String> _asset = {
    SymptomState.comfortable: AppImages.moodComfortable,
    SymptomState.good: AppImages.moodGood,
    SymptomState.normal: AppImages.moodNormal,
    SymptomState.uncomfortable: AppImages.moodUncomfortable,
    SymptomState.severe: AppImages.moodSevere,
  };

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _asset[state]!,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
