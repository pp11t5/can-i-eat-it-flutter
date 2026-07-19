import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';

part 'global_loading.g.dart';

// ---------------------------------------------------------------------------
// GlobalLoadingController — 전역 로딩 카운터
// ---------------------------------------------------------------------------

/// 전역 차단형 로딩 카운터.
///
/// 값 > 0 이면 [GlobalLoadingOverlay]가 전체 화면 배리어 + 스피너를 띄운다.
/// 카운터 방식이므로 중첩/동시 API 호출에도 안전하다 — 모든 호출이 끝나야
/// (카운터가 0으로 돌아와야) 오버레이가 사라진다.
@riverpod
class GlobalLoadingController extends _$GlobalLoadingController {
  @override
  int build() => 0;

  void increment() => state++;

  void decrement() {
    if (state > 0) state--;
  }

  /// [action] 실행 동안 전역 로딩 오버레이를 표시한다.
  ///
  /// 진입 시 카운터++, 완료(성공/실패 무관) 시 `finally`에서 카운터--.
  /// [action]이 던진 예외는 그대로 rethrow 한다 — 호출부가 에러 처리를 담당.
  Future<T> run<T>(Future<T> Function() action) async {
    increment();
    try {
      return await action();
    } finally {
      decrement();
    }
  }
}

// ---------------------------------------------------------------------------
// GlobalLoadingOverlay — 앱 루트 마운트용 오버레이
// ---------------------------------------------------------------------------

/// 앱 루트([MaterialApp.router]의 `builder:`)에서 [child]를 감싸는 전역 로딩 오버레이.
///
/// [globalLoadingControllerProvider] 카운터 > 0 이면 [child] 위에 비해제형
/// [ModalBarrier](`dismissible: false`)와 중앙 [CircularProgressIndicator]를 얹는다.
/// 배리어가 하위 위젯의 탭 입력을 흡수해 중복 탭·추가 인터랙션을 막는다.
class GlobalLoadingOverlay extends ConsumerWidget {
  const GlobalLoadingOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(globalLoadingControllerProvider) > 0;

    return Stack(
      children: [
        child,
        if (isLoading) ...[
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withValues(alpha: 0.25),
          ),
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ],
      ],
    );
  }
}
