import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Intercity-taxi flow — rate-the-driver sheet (Figma node 2186:14269).
/// A bottom sheet over the dark backdrop: a 5-star rating row, a list of
/// selectable complaint reasons with circular checkboxes, a "leave a comment"
/// field, and the "Etiroz bildirish" (dispute) / "Saqlash" (save) button pair.
/// Shown as a real modal bottom sheet.
Future<void> showIntercityRateDriverSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99282828),
    builder: (_) => const _RateSheetBody(),
  );
}

class _RateSheetBody extends StatefulWidget {
  const _RateSheetBody();

  @override
  State<_RateSheetBody> createState() => _RateSheetBodyState();
}

class _RateSheetBodyState extends State<_RateSheetBody> {
  int _rating = 2; // 1-based count of filled stars

  static const _reasons = [
    'intercity.rate_reason_door',
    'intercity.rate_reason_no_contact',
    'intercity.rate_reason_not_handed',
    'intercity.rate_reason_other',
    'intercity.rate_reason_other',
    'intercity.rate_reason_other',
  ];
  final _selected = <int>{1, 2};

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
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 12.h),
                  Container(
                    width: 112.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                    child: Column(
                      children: [
                        Text('intercity.rate_title'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        SizedBox(height: 16.h),
                        // Stars.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < 5; i++) ...[
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => setState(() => _rating = i + 1),
                                child: SvgPicture.asset(
                                  i < _rating
                                      ? '$_icons/ie_star_filled.svg'
                                      : '$_icons/ie_star.svg',
                                  width: 48.r,
                                  height: 48.r,
                                ),
                              ),
                              if (i != 4) SizedBox(width: 16.w),
                            ],
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(height: 1.h, color: AppColors.fieldFill),
                        // Reason rows.
                        for (var i = 0; i < _reasons.length; i++)
                          _ReasonRow(
                            label: _reasons[i].tr(),
                            checked: _selected.contains(i),
                            onTap: () => setState(() {
                              if (!_selected.add(i)) _selected.remove(i);
                            }),
                          ),
                        SizedBox(height: 16.h),
                        // Comment field.
                        Container(
                          height: 48.h,
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: AppColors.fieldFill,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text('intercity.rate_comment_hint'.tr(),
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 16 / 14,
                                  color: AppColors.textMuted)),
                        ),
                        SizedBox(height: 16.h),
                        // Buttons.
                        Row(
                          children: [
                            Expanded(
                              child: _SheetButton(
                                label: 'intercity.rate_dispute'.tr(),
                                filled: false,
                                onTap: () {}, // TODO(nav): -> dispute flow
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _SheetButton(
                                label: 'intercity.rate_save'.tr(),
                                filled: true,
                                                onTap: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const _ReasonRow(
      {required this.label, required this.checked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.fieldFill)),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14.sp,
                      height: 20 / 14,
                      color: AppColors.textDark)),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 28.r,
              height: 28.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: checked ? AppColors.ctaBlue : AppColors.accent,
                shape: BoxShape.circle,
                border: checked
                    ? null
                    : Border.all(
                        color: const Color(0xFFCBD5E1), width: 2),
              ),
              child: checked
                  ? SvgPicture.asset('$_icons/check.svg',
                      width: 12.r, height: 12.r)
                  : null,
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
                fontWeight: FontWeight.w500,
                color: filled ? AppColors.textOnDark : AppColors.textDark)),
      ),
    );
  }
}
