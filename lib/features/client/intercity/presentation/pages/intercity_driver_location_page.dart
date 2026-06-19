import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';
const _images = 'assets/images';

/// Intercity-taxi flow — live driver location on the map
/// (Figma node 2186:14128 "Driver Location"). The live map is currently
/// disabled, so the Figma map raster is used as a static background with the
/// driver marker / controls / driver sheet overlaid.
@RoutePage()
class IntercityDriverLocationPage extends StatelessWidget {
  const IntercityDriverLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: Stack(
        children: [
          // Static map background.
          Positioned.fill(
            child: Image.asset('$_images/ic_driver_map.png', fit: BoxFit.cover),
          ),
          // Driver (taxi) marker — roughly upper-centre.
          const Align(
            alignment: Alignment(-0.08, -0.28),
            child: _TaxiMarker(),
          ),
          // "Haydovchi joylashuvi" pill above the sheet.
          Positioned(
            left: 0,
            right: 0,
            bottom: 200.h,
            child: Center(child: const _LocationPill()),
          ),
          // Recenter button.
          Positioned(
            right: 16.w,
            bottom: 200.h,
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
              child: Transform.rotate(
                angle: -0.785398, // -45°
                child: SvgPicture.asset('$_icons/od_gps.svg',
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                        AppColors.textDark, BlendMode.srcIn)),
              ),
            ),
          ),
          // Header: back button (title hidden in Figma).
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.maybePop(),
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
                  child: SvgPicture.asset('$_icons/mt_back.svg',
                      width: 24.r, height: 24.r),
                ),
              ),
            ),
          ),
          // Driver sheet.
          const Align(
              alignment: Alignment.bottomCenter, child: _DriverSheet()),
        ],
      ),
    );
  }
}

class _TaxiMarker extends StatelessWidget {
  const _TaxiMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: const BoxDecoration(
        color: Color(0xFF5579EF),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset('$_icons/ia_taxi.svg',
          width: 24.r,
          height: 24.r,
          colorFilter:
              const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
    );
  }
}

class _LocationPill extends StatelessWidget {
  const _LocationPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.textDark,
        borderRadius: BorderRadius.circular(80.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('intercity.drvloc_driver_location'.tr(),
              style: AppText.label.copyWith(
                  fontSize: 12.sp, color: AppColors.textOnDark)),
          SizedBox(width: 4.w),
          SvgPicture.asset('$_icons/ia_loc_dot.svg',
              width: 16.r,
              height: 16.r,
              colorFilter:
                  ColorFilter.mode(AppColors.textOnDark, BlendMode.srcIn)),
        ],
      ),
    );
  }
}

class _DriverSheet extends StatelessWidget {
  const _DriverSheet();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset('$_images/ic_driver1.png',
                            width: 48.r, height: 48.r, fit: BoxFit.cover),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Akbar Yoldoshev',
                              style: AppText.bodyMedium.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark)),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Text('01 B 125 YC',
                                  style: AppText.subtitle.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.textMuted)),
                              Container(
                                width: 1,
                                height: 14.h,
                                margin:
                                    EdgeInsets.symmetric(horizontal: 8.w),
                                color: AppColors.lightGrey,
                              ),
                              Text('Cobalt LTZ Oq',
                                  style: AppText.subtitle.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.textMuted)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {}, // TODO(nav): -> call driver
                    child: Container(
                      height: 52.r,
                      width: 52.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.creditGreen,
                        border: Border.all(
                            color: AppColors.statusGreen, width: 2),
                        borderRadius: BorderRadius.circular(500.r),
                      ),
                      child: SvgPicture.asset('$_icons/od_call.svg',
                          width: 20.r,
                          height: 20.r,
                          colorFilter: ColorFilter.mode(
                              AppColors.textOnDark, BlendMode.srcIn)),
                    ),
                  ),
                ],
              ),
              Divider(height: 32.h, color: AppColors.border),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.maybePop(),
                child: Container(
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.ctaBlue,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text('intercity.drvloc_close'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textOnDark)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
