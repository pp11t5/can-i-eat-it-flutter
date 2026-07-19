import 'dart:async';

import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalLoadingController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('초기값은 0(로딩 아님)', () {
      expect(container.read(globalLoadingControllerProvider), 0);
    });

    test('run() 실행 동안 카운터가 1이고, 완료 후 0으로 돌아온다', () async {
      final completer = Completer<void>();
      final future = container
          .read(globalLoadingControllerProvider.notifier)
          .run(() => completer.future);

      expect(container.read(globalLoadingControllerProvider), 1);

      completer.complete();
      await future;

      expect(container.read(globalLoadingControllerProvider), 0);
    });

    test('중첩 호출 시 모든 호출이 끝나야 0으로 돌아온다(카운터 안전)', () async {
      final c1 = Completer<void>();
      final c2 = Completer<void>();
      final notifier = container.read(globalLoadingControllerProvider.notifier);

      final f1 = notifier.run(() => c1.future);
      final f2 = notifier.run(() => c2.future);
      expect(container.read(globalLoadingControllerProvider), 2);

      c1.complete();
      await f1;
      // 다른 호출이 아직 진행 중이므로 카운터는 여전히 > 0.
      expect(container.read(globalLoadingControllerProvider), 1);

      c2.complete();
      await f2;
      expect(container.read(globalLoadingControllerProvider), 0);
    });

    test('action이 예외를 던져도 카운터는 0으로 회복되고 예외는 rethrow 된다', () async {
      final notifier = container.read(globalLoadingControllerProvider.notifier);

      await expectLater(
        notifier.run<void>(() => Future<void>.error(Exception('boom'))),
        throwsA(isA<Exception>()),
      );

      expect(container.read(globalLoadingControllerProvider), 0);
    });
  });

  group('GlobalLoadingOverlay', () {
    // MaterialApp의 Navigator가 라우트별로 투명(color: null) ModalBarrier를
    // 내부적으로 항상 하나 깔아두므로, 우리 오버레이가 얹은 비해제형+색상 배리어만
    // 구분해서 찾는다.
    Finder findOurBarrier() => find.byWidgetPredicate(
          (w) => w is ModalBarrier && w.color != null && !w.dismissible,
        );

    testWidgets('카운터 0이면 배리어/스피너 미표시', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GlobalLoadingOverlay(child: Text('content')),
          ),
        ),
      );

      expect(findOurBarrier(), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('카운터 > 0이면 배리어(비해제형)+스피너 표시', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 먼저 위젯 트리를 구독시켜(watch) autoDispose 스케줄링 타이머가 남지
      // 않게 한 뒤 카운터를 올리고 pump 로 재빌드한다.
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: GlobalLoadingOverlay(child: Text('content')),
          ),
        ),
      );
      container.read(globalLoadingControllerProvider.notifier).increment();
      await tester.pump();

      final barrier = tester.widget<ModalBarrier>(findOurBarrier());
      expect(barrier.dismissible, isFalse);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // 하위 콘텐츠는 여전히 트리에 존재(배리어가 위에 얹힐 뿐).
      expect(find.text('content'), findsOneWidget);
    });
  });
}
