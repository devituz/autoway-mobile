import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Intercity-taxi flow — "Qo'shimcha" additional-options sheet (Figma node
/// 2167:10287). Shown as a real modal bottom sheet.
Future<void> showIntercityExtraSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99282828),
    builder: (_) => const _ExtraSheetBody(),
  );
}

class _ExtraSheetBody extends StatefulWidget {
  const _ExtraSheetBody();

  @override
  State<_ExtraSheetBody> createState() => _ExtraSheetBodyState();
}

class _ExtraSheetBodyState extends State<_ExtraSheetBody> {
  late final List<_ExtraOption> _options = [
    _ExtraOption(icon: 'personalcard', labelKey: 'intercity.extra_for_other'),
    _ExtraOption(icon: 'ib_snow', labelKey: 'intercity.extra_ac', selected: true),
    _ExtraOption(
        icon: 'ic_no_smoke',
        labelKey: 'intercity.extra_no_smoking',
        selected: true),
    _ExtraOption(icon: 'ib_pet', labelKey: 'intercity.extra_pets'),
    _ExtraOption(icon: 'ib_music', labelKey: 'intercity.extra_music'),
    _ExtraOption(
        icon: 'ib_pause_circle', labelKey: 'intercity.extra_silence'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Sheet(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('intercity.extra_title'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 18.sp,
                          height: 20 / 18,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 16.h),
                  for (var i = 0; i < _options.length; i++)
                    _OptionRow(
                      option: _options[i],
                      onTap: () => setState(
                          () => _options[i].selected = !_options[i].selected),
                    ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetButton(
                          label: 'intercity.extra_close'.tr(),
                          filled: false,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _SheetButton(
                          label: 'intercity.extra_continue'.tr(),
                          filled: true,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ],
      ),
    );
  }
}

class _ExtraOption {
  final String? icon;
  final String labelKey;
  bool selected;
  _ExtraOption({this.icon, required this.labelKey, this.selected = false});
}

class _OptionRow extends StatelessWidget {
  final _ExtraOption option;
  final VoidCallback onTap;
  const _OptionRow({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.fieldFill)),
        ),
        child: Row(
          children: [
            if (option.icon != null) ...[
              SvgPicture.asset('$_icons/${option.icon}.svg',
                  width: 24.r, height: 24.r),
              SizedBox(width: 8.w),
            ],
            Expanded(
              child: Text(option.labelKey.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      color: AppColors.textDark)),
            ),
            SizedBox(width: 8.w),
            _Checkbox(selected: option.selected),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool selected;
  const _Checkbox({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: selected ? AppColors.ctaBlue : AppColors.accent,
        shape: BoxShape.circle,
        border: selected
            ? null
            : Border.all(color: const Color(0xFFCBD5E1), width: 2),
      ),
      child: selected
          ? Icon(Icons.check, size: 16.r, color: AppColors.textOnDark)
          : null,
    );
  }
}

class _Sheet extends StatelessWidget {
  final Widget child;
  const _Sheet({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 6,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 112.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              child: child,
            ),
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
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.ctaBlue : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: filled ? AppColors.textOnDark : AppColors.textDark)),
      ),
    );
  }
}
