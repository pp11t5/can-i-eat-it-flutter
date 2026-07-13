import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';

/// 약관 상세 인앱 웹뷰 화면.
///
/// 약관 목록(가입 시 [TermsScreen], 마이페이지 약관 섹션)에서 진입한다.
/// 기존 TopBar 컨벤션(notification_settings_screen 미러: bg surface, elevation 0,
/// toolbarHeight 64, bottom stroke #F5F5F5 1px) 아래 [WebViewWidget]으로
/// [url] 을 로드해 외부 브라우저 이탈 없이 약관 전문을 보여준다.
class TermsDetailScreen extends StatefulWidget {
  const TermsDetailScreen({super.key, required this.title, required this.url});

  /// AppBar 타이틀(약관명, 접두어 없음).
  final String title;

  /// 로드할 약관 전문 URL.
  final String url;

  @override
  State<TermsDetailScreen> createState() => _TermsDetailScreenState();
}

class _TermsDetailScreenState extends State<TermsDetailScreen> {
  late final WebViewController _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() => _progress = progress / 100);
          },
          onPageStarted: (_) {
            setState(() => _progress = 0);
          },
          onPageFinished: (_) {
            setState(() => _progress = 1);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 64,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.chevronLeft,
            size: AppIconSizes.s24,
            color: AppColors.textPrimary,
            semanticsLabel: '뒤로',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
      ),
      body: Column(
        children: [
          if (_progress < 1)
            LinearProgressIndicator(
              value: _progress == 0 ? null : _progress,
              minHeight: 2,
              backgroundColor: AppColors.surfaceMuted,
              color: AppColors.primary,
            ),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
