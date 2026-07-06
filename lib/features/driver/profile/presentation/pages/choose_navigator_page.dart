import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Driver — choose default navigation app (Navigatorni tanlang).
/// Figma node 2232:17299. Selectable rows with a filled blue check circle on
/// the active option and a confirm/save button at the bottom.
@RoutePage()
class ChooseNavigatorPage extends StatefulWidget {
  const ChooseNavigatorPage({super.key});

  @override
  State<ChooseNavigatorPage> createState() => _ChooseNavigatorPageState();
}

class _ChooseNavigatorPageState extends State<ChooseNavigatorPage> {
  String _selected = 'yandex';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: Column(
        children: [
          _Header(title: 'driver.navigator.title'.tr()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('driver.navigator.subtitle'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp, color: AppColors.textPrimary)),
                  SizedBox(height: 16.h),
                  _NavTile(
                    label: 'driver.navigator.yandex'.tr(),
                    selected: _selected == 'yandex',
                    onTap: () => setState(() => _selected = 'yandex'),
                  ),
                  _NavTile(
                    label: 'driver.navigator.google'.tr(),
                    selected: _selected == 'google',
                    onTap: () => setState(() => _selected = 'google'),
                  ),
                  _NavTile(
                    label: 'driver.navigator.navigator2'.tr(),
                    selected: _selected == 'navigator2',
                    onTap: () => setState(() => _selected = 'navigator2'),
                  ),
                  SizedBox(height: 16.h),
                  _ConfirmButton(
                    onTap: () => context.router.maybePop(),
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

class _NavTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.fieldFill, width: 1),
          ),
        ),
        child: Row(
          children: [
            // Brand logo placeholder — generic gps icon in a grey rounded box.
            Container(
              width: 40.r,
              height: 40.r,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset('$_icons/od_gps.svg',
                  width: 24.r, height: 24.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(label,
                  style: AppText.subtitle.copyWith(
                      fontSize: 14.sp, color: AppColors.textDark)),
            ),
            // Radio / check indicator.
            Container(
              width: 28.r,
              height: 28.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.ctaBlue : AppColors.accent,
                shape: BoxShape.circle,
                border: selected
                    ? null
                    : Border.all(color: AppColors.lightGrey, width: 2),
              ),
              child: selected
                  ? Icon(Icons.check, size: 14.sp, color: AppColors.textOnDark)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ConfirmButton({required this.onTap});

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
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text('driver.navigator.confirm'.tr(),
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
