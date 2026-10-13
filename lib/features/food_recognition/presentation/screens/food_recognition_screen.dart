import 'dart:math' as math;

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_recognition/data/food_recognition_providers.dart';
import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/capture_button.dart';
import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/recognition_candidate_card.dart';
import 'package:can_i_eat_it/features/food_recognition/presentation/widgets/recognition_failure_card.dart';

/// 음식 사진 인식 화면.
///
/// 촬영 → 미리보기 → 인식 중 → 후보/실패 카드를 한 화면 안에서 상태로 전환한다.
/// [recordContext] 가 null 이면 단순 판정, 있으면 식단 기록 흐름이며
/// 섭취 시각은 촬영 시각으로 바꾼다.
class FoodRecognitionScreen extends ConsumerStatefulWidget {
  const FoodRecognitionScreen({super.key, this.recordContext});

  final MealRecordContext? recordContext;

  @override
  ConsumerState<FoodRecognitionScreen> createState() =>
      _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends ConsumerState<FoodRecognitionScreen>
    with WidgetsBindingObserver {
  static const _permissionErrorCodes = {
    'CameraAccessDenied',
    'CameraAccessDeniedWithoutPrompt',
    'CameraAccessRestricted',
  };

  CameraController? _camera;
  Uint8List? _photo;
  DateTime? _capturedAt;
  int? _selectedIndex;

  bool _initializing = false;
  bool _capturing = false;

  /// '검색하기' 직후 로딩 프레임이 그려질 때까지의 구간 ([_recognize] 참고).
  bool _recognizing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _takeCamera()?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      final camera = _takeCamera();
      if (camera != null) {
        setState(() {});
        camera.dispose();
      }
    } else if (state == AppLifecycleState.resumed && _photo == null) {
      _initCamera();
    }
  }

  /// 필드를 비우고 컨트롤러를 넘겨준다 (dispose 는 호출부 책임).
  CameraController? _takeCamera() {
    final camera = _camera;
    _camera = null;
    return camera;
  }

  Future<void> _initCamera() async {
    if (_camera != null || _initializing) return;
    _initializing = true;
    CameraController? controller;
    try {
      final cameras = await availableCameras();
      final back = cameras
          .where((c) => c.lensDirection == CameraLensDirection.back)
          .firstOrNull;
      if (back == null) throw CameraException('NoCamera', '후면 카메라가 없습니다.');
      controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      // 초기화 도중 화면이 닫히거나 촬영이 끝났으면 버린다.
      if (!mounted || _photo != null) {
        await controller.dispose();
        return;
      }
      setState(() => _camera = controller);
    } catch (e) {
      await controller?.dispose();
      await _handleCameraError(e);
    } finally {
      _initializing = false;
    }
  }

  Future<void> _handleCameraError(Object error) async {
    if (!mounted) return;
    if (error is CameraException &&
        _permissionErrorCodes.contains(error.code)) {
      final action = await showConfirmModal(
        context,
        title: '카메라 권한이 필요해요',
        body: '음식 사진을 찍으려면 설정에서 카메라 권한을 허용해주세요.',
        primaryLabel: '설정으로 이동',
        primaryColor: AppColors.primary,
        secondaryLabel: '취소',
      );
      if (action == ConfirmModalAction.primary) {
        await AppSettings.openAppSettings();
      }
    } else {
      showAppToast(context, '카메라를 사용할 수 없어요.');
    }
    if (mounted) context.pop();
  }

  Future<void> _capture() async {
    final camera = _camera;
    if (camera == null || _capturing || !camera.value.isInitialized) return;
    _capturing = true;
    try {
      final bytes = await (await camera.takePicture()).readAsBytes();
      if (!mounted) return;
      final taken = _takeCamera();
      setState(() {
        _photo = bytes;
        _capturedAt = nowKst();
      });
      await taken?.dispose();
    } on CameraException {
      if (mounted) showAppToast(context, '사진을 찍지 못했어요. 다시 시도해 주세요.');
    } finally {
      _capturing = false;
    }
  }

  Future<void> _recognize() async {
    final photo = _photo;
    if (photo == null || _recognizing) return;
    setState(() => _recognizing = true);
    // 추론이 메인 isolate에서 동기 실행돼 프레임을 막으므로,
    // 로딩 화면이 먼저 그려진 뒤에 recognize 를 호출한다.
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    try {
      await ref
          .read(foodRecognitionControllerProvider.notifier)
          .recognize(photo);
    } finally {
      if (mounted) setState(() => _recognizing = false);
    }
  }

  void _retake() {
    ref.read(foodRecognitionControllerProvider.notifier).reset();
    setState(() {
      _photo = null;
      _capturedAt = null;
      _selectedIndex = null;
    });
    _initCamera();
  }

  /// 식단 기록 흐름이면 섭취 시각을 촬영 시각으로 바꿔 넘긴다.
  MealRecordContext? get _recordContext {
    final base = widget.recordContext;
    if (base == null) return null;
    return MealRecordContext(
      eatenAt: _capturedAt!,
      mealRecordId: base.mealRecordId,
    );
  }

  void _diagnose(String label) => context.push(
        '/verdict',
        extra: VerdictArgs(text: label, recordContext: _recordContext),
      );

  // 뒤로 가면 카드로 돌아오도록 push 한다.
  void _search() => context.push('/check', extra: _recordContext);

  @override
  Widget build(BuildContext context) {
    final photo = _photo;
    final recognition = ref.watch(foodRecognitionControllerProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.cameraBackground,
        body: photo == null
            ? _buildCapture()
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(photo, fit: BoxFit.cover, gaplessPlayback: true),
                  if (_recognizing || recognition.isLoading)
                    _buildLoading()
                  else if (recognition.hasError)
                    _buildFailure()
                  else if (recognition.value == null)
                    _buildPreview()
                  else if (recognition.value!.isEmpty)
                    _buildFailure()
                  else
                    _buildCandidates(
                      recognition.value!.map((c) => c.label).toList(),
                    ),
                ],
              ),
      ),
    );
  }

  // --- 촬영 ---

  Widget _buildCapture() {
    final camera = _camera;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (camera != null && camera.value.isInitialized)
          _CoverPreview(camera: camera),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Pill(
                label: '현재는 "한식"만 검색할 수 있어요!',
                color: AppColors.cameraLabel,
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              // 셔터 아래 23 + 돌아가기(34) + 23 = Figma 하단 여백 80.
              _BottomPanel(
                bottom: 23,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CaptureButton(onPressed: camera == null ? null : _capture),
                    const SizedBox(height: 23),
                    _Pill(
                      label: '돌아가기',
                      color: AppColors.captureRing,
                      onTap: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- 미리보기 ---

  Widget _buildPreview() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Pill(
            label: '사진이 흔들리지 않아야 인식이 정확해요.',
            horizontalPadding: 10,
            color: AppColors.cameraLabel,
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          _BottomPanel(
            bottom: 80,
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _retake,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.captureRing,
                    ),
                    child: const AppIcon(
                      AppIcons.reset,
                      size: AppIconSizes.s20,
                      semanticsLabel: '다시 찍기',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.itemGap),
                Expanded(
                  child: AppButton.primary(
                    label: '검색하기',
                    isExpanded: true,
                    onPressed: _recognize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 로딩 ---

  Widget _buildLoading() {
    return ColoredBox(
      color: AppColors.cameraScrim,
      child: Center(
        child: Text(
          '음식을 인식하고 있어요',
          style: AppTextStyles.body1Medium.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }

  // --- 후보 카드 ---

  Widget _buildCandidates(List<String> labels) {
    final selected = _selectedIndex;
    return _DimmedCard(
      child: RecognitionCandidateCard(
        labels: labels,
        selectedIndex: selected,
        onSelect: (i) => setState(() => _selectedIndex = i),
        onDiagnose: () {
          if (selected != null && selected < labels.length) {
            _diagnose(labels[selected]);
          }
        },
        onSearch: _search,
        onRetake: _retake,
      ),
    );
  }

  // --- 실패 카드 ---

  Widget _buildFailure() {
    return _DimmedCard(
      child: RecognitionFailureCard(onSearch: _search, onRetake: _retake),
    );
  }
}

/// 프리뷰를 화면 전체에 cover 로 채운다 (비율 유지 크롭).
class _CoverPreview extends StatelessWidget {
  const _CoverPreview({required this.camera});

  final CameraController camera;

  @override
  Widget build(BuildContext context) {
    // aspectRatio 는 센서 기준(가로/세로 > 1). 세로 화면에선 CameraPreview 가
    // 세로로 회전해 그려지므로 박스 비율도 뒤집어야 cover 크롭이 맞는다.
    final portrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    final ratio =
        portrait ? 1 / camera.value.aspectRatio : camera.value.aspectRatio;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: ratio * 100,
          height: 100,
          child: CameraPreview(camera),
        ),
      ),
    );
  }
}

/// Dim 오버레이 위 가운데 카드.
class _DimmedCard extends StatelessWidget {
  const _DimmedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cameraScrim,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// 카메라 화면 하단 패널.
///
/// [bottom] 은 홈 인디케이터 영역을 포함한 여백이라 SafeArea 를 더하지 않는다.
/// 기기 하단 인셋이 더 크면 인셋을 쓴다.
class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.bottom, required this.child});

  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cameraPanel,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.sectionGap,
        AppSpacing.screenPadding,
        math.max(bottom, MediaQuery.viewPaddingOf(context).bottom),
      ),
      child: child,
    );
  }
}

/// 사진·패널 위 라벨 박스. [onTap] 이 있으면 버튼으로 동작한다.
class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    this.color = AppColors.cameraScrim,
    this.horizontalPadding = 12,
    this.onTap,
  });

  final String label;
  final Color color;
  final double horizontalPadding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Text(
        label,
        style: AppTextStyles.body2Medium.copyWith(color: AppColors.onPrimary),
      ),
    );
    if (onTap == null) return pill;
    return Semantics(
      button: true,
      child: GestureDetector(onTap: onTap, child: pill),
    );
  }
}
