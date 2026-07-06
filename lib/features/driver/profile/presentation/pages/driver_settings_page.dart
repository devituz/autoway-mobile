import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../../../client/profile/presentation/widgets/language_sheet.dart';

const _icons = 'assets/icons';

/// Driver app — Settings (Sozlamalar). 1:1 with Figma node 2232:17120:
/// light background, white top bar with a back button and centered title,
/// then a single white menu card with setting rows (Navigator / Xabarlar /
/// Ilova tili), each leading an icon and a trailing arrow.
@RoutePage()
class DriverSettingsPage extends StatelessWidget {
  const DriverSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          _Header(title: 'driver.settings.title'.tr()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
              child: _MenuCard(
                items: [
                  _MenuData(
                    'od_gps',
                    'driver.settings.navigator'.tr(),
                    onTap: () =>
                        context.router.push(const ChooseNavigatorRoute()),
                  ),
                  _MenuData(
                    'bell',
                    'driver.settings.messages'.tr(),
                    onTap: () =>
                        context.router.push(const NotificationsRoute()),
                  ),
                  _MenuData(
                    'language',
                    'driver.settings.app_language'.tr(),
                    onTap: () => _openLanguageSheet(context),
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

Future<void> _openLanguageSheet(BuildContext context) async {
  final code = await showLanguageSheet(
    context,
    current: context.locale.languageCode,
  );
  if (code != null && context.mounted) {
    await context.setLocale(Locale(code));
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
                          fontSize: 18.sp,
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

class _MenuData {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const _MenuData(this.icon, this.label, {required this.onTap});
}

class _MenuCard extends StatelessWidget {
  final List<_MenuData> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [for (final it in items) _MenuTile(data: it)],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MenuData data;
  const _MenuTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 56.h,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(12.r),
              child: _svg(data.icon),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(data.label,
                  style: AppText.bodyMedium.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400)),
            ),
            _svg('arrow_right'),
          ],
        ),
      ),
    );
  }
}

Widget _svg(String name, {double? size, Color? color}) {
  return SvgPicture.asset(
    '$_icons/$name.svg',
    width: (size ?? 24).sp,
    height: (size ?? 24).sp,
    colorFilter:
        color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
  );
}
