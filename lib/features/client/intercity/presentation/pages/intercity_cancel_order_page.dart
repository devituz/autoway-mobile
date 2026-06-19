import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Intercity-taxi flow — cancel-order confirmation bottom sheet
/// (Figma node 2185:14014). Asks the user to confirm cancelling an order, with
/// a destructive note that the deposit is non-refundable, then a "Bekor qilish"
/// (cancel) / "Ortga qaytish" (go back) button pair.
///
/// Designed as a page (@RoutePage) but visually a bottom sheet floating over a
/// dimmed dark backdrop, mirroring the Figma frame.
@RoutePage()
class IntercityCancelOrderPage extends StatelessWidget {
  const IntercityCancelOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x99282828),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('intercity.cancel_confirm_title'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark)),
                      SizedBox(height: 16.h),
                      // Destructive note banner.
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1F2),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset('$_icons/info_circle.svg',
                                width: 24.r,
                                height: 24.r,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.badgeRed, BlendMode.srcIn)),
                            SizedBox(height: 10.h),
                            Text('intercity.cancel_deposit_note'.tr(),
                                textAlign: TextAlign.center,
                                style: AppText.subtitle.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.textDark)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Buttons.
                      Row(
                        children: [
                          Expanded(
                            child: _SheetButton(
                              label: 'intercity.cancel_confirm'.tr(),
                              filled: false,
                              onTap: () => context.router.push(const IntercityCancelledRoute()),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _SheetButton(
                              label: 'intercity.cancel_go_back'.tr(),
                              filled: true,
                              onTap: () => context.router.maybePop(),
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
                color: filled ? AppColors.textOnDark : AppColors.logoutRed)),
      ),
    );
  }
}
