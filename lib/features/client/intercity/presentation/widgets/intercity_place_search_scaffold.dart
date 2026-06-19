import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

/// Shared layout for the intercity address-picker list screens (Figma nodes
/// 2124:9527 "Qayerdan" and 2124:9824 region drill-down). A rounded white top
/// bar with back arrow + centered title, then a rounded white card holding a
/// search field with a "Karta" (map) chip and a scrollable list of [items].
class IntercityPlaceSearchScaffold extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const IntercityPlaceSearchScaffold({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border,
      body: Column(
        children: [
          _TopBar(title: title),
          SizedBox(height: 4.h),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 0),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  const _SearchBar(),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: items,
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

class _TopBar extends StatelessWidget {
  final String title;
  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x147D8184),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.maybePop(),
                child: SvgPicture.asset('assets/icons/mt_back.svg',
                    width: 32.r, height: 32.r),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppText.screenTitle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
                ),
              ),
              SizedBox(width: 32.r),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/ia_search.svg',
              width: 24.r, height: 24.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'intercity.addr_search'.tr(),
              style: AppText.subtitle.copyWith(
                  fontSize: 16.sp, color: AppColors.textSecondary),
            ),
          ),
          GestureDetector(
            onTap: () => context.router.push(const IntercityAddressRoute()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.textDark,
                borderRadius: BorderRadius.circular(80.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'intercity.addr_map'.tr(),
                    style: AppText.label.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textOnDark),
                  ),
                  SizedBox(width: 4.w),
                  SvgPicture.asset('assets/icons/ia_pin_chip.svg',
                      width: 16.r, height: 16.r),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
