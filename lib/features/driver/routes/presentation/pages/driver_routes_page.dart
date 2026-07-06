import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// A single saved route (from -> to) shown in the routes card.
class _RouteData {
  final String from;
  final String to;
  const _RouteData(this.from, this.to);
}

/// Driver — "Mening marshrutlarim" (My routes). 1:1 with Figma node 2232:10804:
/// light background, white top bar with a circular back button + centered title
/// + blue circular "+", a white "Profil malumotlari" card listing saved routes
/// (from/to with a vertical swap arrow and an edit icon), and an outlined
/// full-width "Yangi manzil qoshish +" button. Static placeholder data only.
@RoutePage()
class DriverRoutesPage extends StatelessWidget {
  const DriverRoutesPage({super.key});

  static const List<_RouteData> _routes = [
    _RouteData('Toshkent,', 'Sirdaryo tumani, Guliston'),
    _RouteData(
        'Samarqand viloyati, Samarqand shahri', 'Sirdaryo viloyati, Guliston shahri'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: _RoutesCard(routes: _routes),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
                child: SvgPicture.asset('$_icons/mt_back.svg',
                    width: 32.r, height: 32.r),
              ),
              Expanded(
                child: Text(
                  'driver.routes.title'.tr(),
                  textAlign: TextAlign.center,
                  style: AppText.subtitle.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.push(const CreateRouteRoute()),
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.selectBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, size: 20.sp, color: AppColors.textOnDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutesCard extends StatelessWidget {
  final List<_RouteData> routes;
  const _RoutesCard({required this.routes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'driver.routes.section'.tr(),
            style: AppText.subtitle.copyWith(
              fontSize: 18.sp,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          for (var i = 0; i < routes.length; i++) ...[
            _RouteItem(
              data: routes[i],
              onEdit: () => context.router.push(const CreateRouteRoute()),
            ),
            SizedBox(height: 8.h),
          ],
          _AddButton(
            onTap: () => context.router.push(const CreateRouteRoute()),
          ),
        ],
      ),
    );
  }
}

class _RouteItem extends StatelessWidget {
  final _RouteData data;
  final VoidCallback onEdit;
  const _RouteItem({required this.data, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final lineStyle = AppText.subtitle.copyWith(
      fontSize: 14.sp,
      color: AppColors.textDark,
      fontWeight: FontWeight.w500,
      height: 16 / 14,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.from, style: lineStyle),
                SizedBox(height: 4.h),
                Icon(Icons.swap_vert,
                    size: 20.sp, color: AppColors.textDark),
                SizedBox(height: 4.h),
                Text(data.to, style: lineStyle),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onEdit,
            child: SizedBox(
              width: 36.r,
              height: 36.r,
              child: Center(
                child: SvgPicture.asset(
                  '$_icons/edit.svg',
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                      AppColors.textMuted, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.only(left: 16.w, right: 8.w),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.selectBlue, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'driver.routes.add'.tr(),
              style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: AppColors.selectBlue,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset(
              '$_icons/ia_add.svg',
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                  AppColors.selectBlue, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
