import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Driver — "Transportlarim" (My vehicles), Figma node 2232:11704.
/// Light screen: circular back button, centered title, blue "+" circle, a
/// white "Profil malumotlari" card listing vehicle cards (plate, model|color,
/// car image, gear), then an outlined "Yangi transport qoshish +" button.
@RoutePage()
class TransportsPage extends StatelessWidget {
  const TransportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const vehicles = <_Vehicle>[
      _Vehicle(
        plate: '01 B 125 YC',
        model: 'Cobalt LTZ | Oq',
        image: 'assets/images/ic_car1.png',
      ),
      _Vehicle(
        plate: '01 B 777 YC',
        model: 'Malibu Turbo LTZ | Qora',
        image: 'assets/images/ic_car2.png',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          _Header(
            title: 'driver.transports.title'.tr(),
            onAdd: () => context.router.push(const EditVehicleRoute()),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: AppColors.accent,
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('driver.transports.section'.tr(),
                        style: AppText.subtitle.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 16.h),
                    for (final v in vehicles) ...[
                      _VehicleCard(
                        vehicle: v,
                        onTap: () =>
                            context.router.push(const EditVehicleRoute()),
                        onSettings: () =>
                            context.router.push(const EditVehicleRoute()),
                      ),
                      SizedBox(height: 16.h),
                    ],
                    _AddButton(
                      label: 'driver.transports.add'.tr(),
                      onTap: () =>
                          context.router.push(const EditVehicleRoute()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Vehicle {
  final String plate;
  final String model;
  final String image;
  const _Vehicle(
      {required this.plate, required this.model, required this.image});
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  const _Header({required this.title, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 12,
              offset: const Offset(0, 4)),
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
                child: SvgPicture.asset('$_icons/mt_back.svg',
                    width: 32.sp, height: 32.sp),
              ),
              Expanded(
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: AppText.subtitle.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600)),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onAdd,
                child: Container(
                  width: 32.sp,
                  height: 32.sp,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.selectBlue,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset('$_icons/ia_add.svg',
                      width: 20.sp,
                      height: 20.sp,
                      colorFilter: const ColorFilter.mode(
                          AppColors.textOnDark, BlendMode.srcIn)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final _Vehicle vehicle;
  final VoidCallback onTap;
  final VoidCallback onSettings;
  const _VehicleCard(
      {required this.vehicle, required this.onTap, required this.onSettings});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 120.h,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF1F5F9), Color(0xFFDAE3EB)],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.plate,
                          style: AppText.bodyMedium.copyWith(
                              fontSize: 16.sp,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 2.h),
                      Text(vehicle.model,
                          style: AppText.subtitle
                              .copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
                Image.asset(vehicle.image,
                    width: 145.w, height: 60.h, fit: BoxFit.contain),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSettings,
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: AppColors.accent, shape: BoxShape.circle),
                  child: SvgPicture.asset('$_icons/settings.svg',
                      width: 20.sp,
                      height: 20.sp,
                      colorFilter: const ColorFilter.mode(
                          AppColors.textDark, BlendMode.srcIn)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.selectBlue),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: AppText.subtitle.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.selectBlue,
                    fontWeight: FontWeight.w500)),
            SizedBox(width: 4.w),
            SvgPicture.asset('$_icons/ia_add.svg',
                width: 20.sp,
                height: 20.sp,
                colorFilter: const ColorFilter.mode(
                    AppColors.selectBlue, BlendMode.srcIn)),
          ],
        ),
      ),
    );
  }
}
