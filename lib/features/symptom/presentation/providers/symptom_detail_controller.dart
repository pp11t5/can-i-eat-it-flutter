import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/symptom/data/symptom_providers.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';

part 'symptom_detail_controller.g.dart';

// ---------------------------------------------------------------------------
// SymptomDetailController
// ---------------------------------------------------------------------------

/// 증상 상세 컨트롤러.
///
/// [symptomId] 에 해당하는 [Symptom] 을 로드하고 삭제 액션을 제공한다.
/// 대응 API: GET /symptoms/{symptomId}, DELETE /symptoms/{symptomId}.
@riverpod
class SymptomDetailController extends _$SymptomDetailController {
  @override
  Future<Symptom> build(String symptomId) async {
    final repo = ref.watch(symptomRepositoryProvider);
    return repo.detail(symptomId);
  }

  /// 증상을 삭제한다.
  ///
  /// 대응 API: DELETE /symptoms/{symptomId}.
  Future<void> deleteSymptom() async {
    await ref.read(symptomRepositoryProvider).delete(symptomId);
  }
}
