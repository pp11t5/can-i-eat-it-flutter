import 'package:flutter/material.dart';

import '../../../../app/widgets/medical_disclaimer.dart';
import '../../domain/entities/eat_verdict.dart';

/// 판별 결과 카드. 수위별 색/아이콘 + 근거 + 출처 + 면책 고지를 함께 보여준다.
class VerdictCard extends StatelessWidget {
  const VerdictCard({required this.verdict, super.key});

  final EatVerdict verdict;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, icon, label) = switch (verdict.level) {
      VerdictLevel.safe => (Colors.green, Icons.check_circle, '먹어도 괜찮아요'),
      VerdictLevel.caution => (Colors.orange, Icons.warning_amber, '주의가 필요해요'),
      VerdictLevel.avoid => (Colors.red, Icons.do_not_disturb_on, '피하는 게 좋아요'),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(label, style: theme.textTheme.titleMedium?.copyWith(color: color)),
              ],
            ),
            const SizedBox(height: 8),
            Text(verdict.reason, style: theme.textTheme.bodyMedium),
            if (verdict.sources.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '근거: ${verdict.sources.join(', ')}',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const Divider(height: 24),
            const MedicalDisclaimer(),
          ],
        ),
      ),
    );
  }
}
