import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../condition_profile/presentation/providers/condition_providers.dart';
import '../providers/food_check_providers.dart';
import '../widgets/verdict_card.dart';

/// 메인 화면: 음식/성분을 입력해 "먹어도 돼?"를 판별한다.
class FoodCheckScreen extends ConsumerStatefulWidget {
  const FoodCheckScreen({super.key});

  @override
  ConsumerState<FoodCheckScreen> createState() => _FoodCheckScreenState();
}

class _FoodCheckScreenState extends ConsumerState<FoodCheckScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() => ref.read(foodCheckControllerProvider.notifier).check(_controller.text);

  @override
  Widget build(BuildContext context) {
    final verdict = ref.watch(foodCheckControllerProvider);
    final selectedCount = ref.watch(selectedConditionsProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('먹어도 돼?'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: selectedCount > 0,
              label: Text('$selectedCount'),
              child: const Icon(Icons.medical_information_outlined),
            ),
            tooltip: '내 기저질환',
            onPressed: () => context.push('/conditions'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: '음식 또는 성분',
                hintText: '예: 아메리카노, 라면, 바나나',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _check(),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: verdict.isLoading ? null : _check,
              icon: const Icon(Icons.search),
              label: const Text('판별하기'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: verdict.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('오류: $error')),
                data: (result) => result == null
                    ? const Center(child: Text('음식을 입력하고 판별해 보세요.'))
                    : SingleChildScrollView(child: VerdictCard(verdict: result)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
