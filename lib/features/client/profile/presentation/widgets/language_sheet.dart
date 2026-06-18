import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

/// Available app languages (code -> literal label, labels are NOT translated).
const _languages = <MapEntry<String, String>>[
  MapEntry('uz', 'O‘zbek tili'),
  MapEntry('ru', 'Русский язык'),
  MapEntry('en', 'English'),
];

/// Opens the "Ilova tili" language bottom sheet (Figma node 2066:14886).
/// Returns the selected locale code ('uz'|'ru'|'en') on "Saqlash",
/// or null on dismiss / "Ortga".
Future<String?> showLanguageSheet(
  BuildContext context, {
  required String current,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _LanguageSheet(current: current),
  );
}

class _LanguageSheet extends StatefulWidget {
  final String current;
  const _LanguageSheet({required this.current});

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  late String _selected = widget.current;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 112.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text('profile.app_language'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 16.h),
              for (var i = 0; i < _languages.length; i++) ...[
                if (i != 0) SizedBox(height: 12.h),
                _LanguageOption(
                  label: _languages[i].value,
                  selected: _selected == _languages[i].key,
                  onTap: () => setState(() => _selected = _languages[i].key),
                ),
              ],
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _SheetButton(
                      label: 'edit.back'.tr(),
                      filled: false,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SheetButton(
                      label: 'edit.save'.tr(),
                      filled: true,
                      onTap: () => Navigator.pop(context, _selected),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              width: 24.r,
              height: 24.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.textDark : AppColors.accent,
                shape: BoxShape.circle,
                border: selected
                    ? null
                    : Border.all(color: AppColors.border, width: 1.5),
              ),
              child: selected
                  ? Icon(Icons.check, size: 14.sp, color: AppColors.textOnDark)
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(label,
                style: AppText.subtitle
                    .copyWith(fontSize: 15.sp, color: AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _SheetButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.textDark : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: filled ? AppColors.textOnDark : AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
