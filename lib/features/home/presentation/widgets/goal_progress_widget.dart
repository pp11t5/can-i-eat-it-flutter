import 'package:flutter/material.dart';

/// 오늘의 목표 달성률 위젯.
class GoalProgressWidget extends StatelessWidget {
  const GoalProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('오늘의 목표 달성률'),
            SizedBox(height: 8),
            LinearProgressIndicator(value: 0.6),
            SizedBox(height: 4),
            Text('60% 달성'),
          ],
        ),
      ),
    );
  }
}
