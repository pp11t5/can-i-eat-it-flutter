import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 홈 화면 날씨 배너 (목 데이터).
///
/// 날씨 API 연동 전까지 고정 목 데이터를 표시한다.
/// [weatherCondition]에 따라 설명 문구가 달라진다.
class WeatherBanner extends StatelessWidget {
  const WeatherBanner({
    super.key,
    this.weatherCondition = 'sunny',
  });

  /// 날씨 상태 코드. `'sunny'` / `'rainy'` / `'cloudy'` 지원.
  final String weatherCondition;

  String get _description => switch (weatherCondition) {
        'sunny' => '맑은 날엔 산책 후 가벼운 식사가 좋아요.',
        'rainy' => '비 오는 날엔 따뜻한 국물 요리가 좋아요.',
        'cloudy' => '흐린 날엔 소화가 잘 되는 음식을 드세요.',
        _ => '오늘 날씨에 맞는 식사를 드세요.',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wb_sunny,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '맑음 · 23°C',
                style: AppTextStyles.body1Medium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _description,
                style: AppTextStyles.body2Regular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
