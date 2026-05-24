import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/condition_providers.dart';

/// 기저질환 선택 화면. 선택은 [selectedConditionsProvider] 에 보관된다.
class ConditionProfileScreen extends ConsumerWidget {
  const ConditionProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConditions = ref.watch(availableConditionsProvider);
    final selected = ref.watch(selectedConditionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('내 기저질환')),
      body: asyncConditions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('불러오기 실패: $error')),
        data: (conditions) => ListView(
          children: [
            for (final condition in conditions)
              CheckboxListTile(
                title: Text(condition.name),
                value: selected.any((e) => e.id == condition.id),
                onChanged: (_) => ref
                    .read(selectedConditionsProvider.notifier)
                    .toggle(condition),
              ),
          ],
        ),
      ),
    );
  }
}
