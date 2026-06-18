import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

/// Opens the "Qo'shimcha" bottom sheet (Figma node 2235:16624). Returns true on
/// "Davom etish", or null on "Yopish"/dismiss.
Future<bool?> showExtraSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ExtraSheet(),
  );
}

class _ExtraSheet extends StatelessWidget {
  const _ExtraSheet();

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
              Text('extra.title'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 16.h),
              _InfoCard(
                title: 'extra.planned_taxi'.tr(),
                illustration: 'assets/images/ill_taxi.png',
              ),
              SizedBox(height: 12.h),
              _InfoCard(
                title: 'extra.companion'.tr(),
                illustration: 'assets/images/ill_pin.png',
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _SheetButton(
                      label: 'extra.close'.tr(),
                      filled: false,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SheetButton(
                      label: 'extra.continue'.tr(),
                      filled: true,
                      onTap: () => Navigator.pop(context, true),
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

class _InfoCard extends StatelessWidget {
  final String title;
  final String illustration;

  const _InfoCard({required this.title, required this.illustration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 6.h),
                Text('extra.msg'.tr(),
                    style: AppText.bodyMedium.copyWith(
                        fontSize: 13.sp, color: AppColors.textMuted)),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Image.asset(illustration, height: 48.h, fit: BoxFit.contain),
        ],
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
          color: filled ? AppColors.blue : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(label,
            style: AppText.button.copyWith(
                fontSize: 14.sp,
                color: filled ? AppColors.textOnDark : AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
