import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';

/// 마이페이지 프로필 이미지 선택 위젯.
///
/// - [image]가 null이면 `Icons.person` 플레이스홀더를 표시한다.
/// - [image]가 있으면 원형으로 표시한다.
/// - 우측 하단 카메라 아이콘 탭 시 갤러리에서 이미지를 선택한다.
/// - 선택된 이미지는 [onImageSelected] 콜백으로 전달한다.
class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
    this.image,
    required this.onImageSelected,
    this.size = 96,
  });

  /// 현재 선택된 이미지. null이면 플레이스홀더 표시.
  final File? image;

  /// 이미지 선택 완료 콜백.
  final ValueChanged<File> onImageSelected;

  /// 원형 위젯 지름 (기본 96).
  final double size;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 원형 이미지 / 플레이스홀더
          CircleAvatar(
            radius: size / 2,
            backgroundColor: AppColors.surfaceMuted,
            backgroundImage: image != null ? FileImage(image!) : null,
            child: image == null
                ? Icon(
                    Icons.person,
                    size: size * 0.5,
                    color: AppColors.textSecondary,
                  )
                : null,
          ),

          // 우측 하단 카메라 아이콘 오버레이
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 카메라 오버레이 버튼의 시맨틱 래퍼 포함 버전.
///
/// [ProfileImagePicker]에 접근성 레이블을 추가한 래퍼.
class AccessibleProfileImagePicker extends StatelessWidget {
  const AccessibleProfileImagePicker({
    super.key,
    required this.picker,
  });

  final ProfileImagePicker picker;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '프로필 사진 변경',
      button: true,
      child: picker,
    );
  }
}
