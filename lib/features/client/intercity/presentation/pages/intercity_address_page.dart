import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Intercity-taxi flow — step 1: pick departure address on the map
/// (Figma node 2124:8964). Opened from the home "Shaharlar aro taxi" card.
@RoutePage()
class IntercityAddressPage extends StatelessWidget {
  const IntercityAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: Stack(
        children: [
          // Live Yandex map centered on Tashkent (Xadra area, as in Figma).
          Positioned.fill(
            child: YandexMap(
              onMapCreated: (controller) {
                controller.moveCamera(
                  CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      target: Point(latitude: 41.3123, longitude: 69.2787),
                      zoom: 15,
                    ),
                  ),
                );
              },
            ),
          ),
          // Top white fade for legibility.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 173.h,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
          // Center destination pin (slightly above middle).
          Align(
            alignment: const Alignment(0, -0.18),
            child: SvgPicture.asset('$_icons/mt_pin.svg',
                width: 40.r, height: 40.r),
          ),
          // Header: back + save + the "Manzilingiz" address label.
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RoundIconButton(
                        icon: 'mt_back',
                        onTap: () => context.router.maybePop(),
                      ),
                      _RoundIconButton(icon: 'mt_save', onTap: () {}),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Text('intercity.your_address'.tr(),
                          style: AppText.label.copyWith(
                              fontSize: 12.sp, color: AppColors.textDark)),
                      SizedBox(height: 4.h),
                      Text('Toshkent shahri, Abdulla Qodiriy 33',
                          textAlign: TextAlign.center,
                          style: AppText.subtitle.copyWith(
                              fontSize: 15.sp,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Locate button (above the sheet).
          Positioned(
            right: 16.w,
            bottom: 240.h,
            child: Container(
              width: 52.r,
              height: 52.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x14000000),
                      blurRadius: 6,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: SvgPicture.asset('$_icons/mt_locate.svg',
                  width: 26.r, height: 26.r),
            ),
          ),
          // Bottom address sheet.
          const Align(alignment: Alignment.bottomCenter, child: _AddressSheet()),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 48.r,
        height: 48.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: const Color(0x14000000),
                blurRadius: 6,
                offset: const Offset(0, 4)),
          ],
        ),
        child: SvgPicture.asset('$_icons/$icon.svg', width: 24.r, height: 24.r),
      ),
    );
  }
}

class _AddressSheet extends StatelessWidget {
  const _AddressSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 6,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    _AddressRow(
                      icon: 'mt_location',
                      label: 'intercity.from'.tr(),
                      value: 'Toshkent shahri',
                      onSelect: () => context.router
                          .push(IntercityRegionPickRoute(toDestination: false)),
                    ),
                    Divider(height: 16.h, color: AppColors.border),
                    _AddressRow(
                      icon: 'mt_flag',
                      label: 'intercity.to'.tr(),
                      value: 'Andijon viloyati, Andijon shahri',
                      onSelect: () => context.router
                          .push(IntercityRegionPickRoute(toDestination: true)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () => context.router.push(const IntercityOrderDetailsRoute()),
                child: Container(
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.ctaBlue,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('intercity.continue'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.textOnDark,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 4.w),
                      Icon(Icons.chevron_right,
                          size: 20.sp, color: AppColors.textOnDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final VoidCallback onSelect;
  const _AddressRow(
      {required this.icon,
      required this.label,
      required this.value,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(4.r),
          child: SvgPicture.asset('$_icons/$icon.svg',
              width: 20.r, height: 20.r),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: AppText.label.copyWith(
                      fontSize: 12.sp, color: AppColors.textSecondary)),
              Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.subtitle.copyWith(
                      fontSize: 15.sp, color: AppColors.textDark)),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSelect,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Text('intercity.select'.tr(),
                    style: AppText.label.copyWith(
                        fontSize: 12.sp, color: AppColors.selectBlue)),
                Icon(Icons.chevron_right,
                    size: 16.sp, color: const Color(0xFFC5D2FB)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
