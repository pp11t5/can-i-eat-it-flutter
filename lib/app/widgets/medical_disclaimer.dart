import 'package:flutter/material.dart';

/// 의료성 면책 고지. 판별 결과를 보여주는 모든 화면에 노출한다(제품 요건).
class MedicalDisclaimer extends StatelessWidget {
  const MedicalDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '이 결과는 일반적인 참고 정보이며 의학적 진단이나 처방을 대신하지 않습니다. '
            '증상이 지속되면 전문의와 상담하세요.',
            style: style,
          ),
        ),
      ],
    );
  }
}
