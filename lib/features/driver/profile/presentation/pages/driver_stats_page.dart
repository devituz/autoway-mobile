import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Driver statistics (Statistika). No dedicated Figma frame exists for this
/// screen, so it follows the app's card conventions and shows the driver's
/// headline metrics (rating, activity, completed orders, earnings) with
/// placeholder values until the backend exposes them.
@RoutePage()
class DriverStatsPage extends StatelessWidget {
  const DriverStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        label: 'driver.stats.rating'.tr(),
        value: '7.9',
        color: AppColors.orange,
        icon: Icons.star_rounded,
      ),
      (
        label: 'driver.stats.activity'.tr(),
        value: '69%',
        color: const Color(0xFFA855F7),
        icon: Icons.bolt_rounded,
      ),
      (
        label: 'driver.stats.completed'.tr(),
        value: '128',
        color: AppColors.statusGreen,
        icon: Icons.check_circle_rounded,
      ),
      (
        label: 'driver.stats.earnings'.tr(),
        value: '4 250 000',
        color: AppColors.selectBlue,
        icon: Icons.account_balance_wallet_rounded,
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          _Header(title: 'driver.stats.title'.tr()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.2,
                children: [
                  for (final c in cards)
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44.r,
                            height: 44.r,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: c.color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(c.icon, size: 24.sp, color: c.color),
                          ),
                          const Spacer(),
                          Text(c.value,
                              style: AppText.bodyLarge.copyWith(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 2.h),
                          Text(c.label,
                              style: AppText.subtitle.copyWith(
                                  fontSize: 13.sp, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 6,
              offset: const Offset(0, 4)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 48.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.router.maybePop(),
                  child: SvgPicture.asset('$_icons/arrow_left.svg',
                      width: 24.sp, height: 24.sp),
                ),
                Expanded(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: AppText.subtitle.copyWith(
                          fontSize: 15.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(width: 24.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
