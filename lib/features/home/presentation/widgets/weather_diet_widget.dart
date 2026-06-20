import 'package:flutter/material.dart';

/// 날씨 기반 식단 추천 섹션 위젯.
class WeatherDietWidget extends StatelessWidget {
  const WeatherDietWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny_outlined),
                SizedBox(width: 8),
                Text('오늘의 날씨 식단 추천'),
              ],
            ),
            SizedBox(height: 8),
            Text('맑음 · 27°C'),
            SizedBox(height: 4),
            Text('가벼운 샐러드나 두부 요리를 추천합니다.'),
          ],
        ),
      ),
    );
  }
}
