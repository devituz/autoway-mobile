import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../widgets/language_sheet.dart';

const _icons = 'assets/icons';

/// Client app — Profile tab (Profil). 1:1 with the Figma design (node 2066:14565).
class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldFill,
      body: Column(
        children: [
          // White title bar with rounded bottom (Figma 2066:14566).
          Container(
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(24.r)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x147D8184),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 48.h,
                child: Center(
                  child: Text('profile.title'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 15.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 16.h),
              child: Column(
                children: [
                  const _UserCard(
                      name: 'Jamshid Sobirov', id: '78946', balance: '50,000'),
                  SizedBox(height: 12.h),
                  _MenuCard(items: [
                    _MenuData(
                        'orders_history', 'profile.orders_history',
                        onTap: () =>
                            context.router.push(const PaymentHistoryRoute())),
                    _MenuData('language', 'profile.app_language',
                        onTap: () => _openLanguageSheet(context)),
                    const _MenuData('settings', 'profile.settings'),
                  ]),
                  SizedBox(height: 12.h),
                  _MenuCard(items: const [
                    _MenuData('guide', 'profile.guide'),
                    _MenuData('about', 'profile.about'),
                    _MenuData('offer', 'profile.public_offer'),
                    _MenuData('privacy', 'profile.privacy'),
                    _MenuData('logout', 'profile.logout', danger: true),
                  ]),
                  SizedBox(height: 12.h),
                  const _SocialCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

class _UserCard extends StatelessWidget {
  final String name;
  final String id;
  final String balance;

  const _UserCard({required this.name, required this.id, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.fieldFill,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person,
                    size: 26.sp, color: AppColors.textSecondary),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppText.subtitle.copyWith(
                            fontSize: 18.sp,
                            height: 20 / 18,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.h),
                    Text('profile.id'.tr(namedArgs: {'id': id}),
                        style: AppText.subtitle.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.push(const EditProfileRoute()),
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: _svg('edit'),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('profile.balance'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500)),
                Text('$balance so‘m',
                    style: AppText.subtitle.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _PillButton(
                    label: 'profile.payment_history'.tr(),
                    filled: false,
                    onTap: () =>
                        context.router.push(const PaymentHistoryRoute())),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _PillButton(
                    label: 'profile.top_up'.tr(),
                    filled: true,
                    onTap: () => context.router.push(const TopUpRoute())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _PillButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.textMuted : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: filled ? AppColors.textOnDark : AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _MenuData {
  final String icon;
  final String labelKey;
  final bool danger;
  final VoidCallback? onTap;
  const _MenuData(this.icon, this.labelKey, {this.danger = false, this.onTap});
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
      onTap: data.onTap ?? () {},
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
              child: Text(data.labelKey.tr(),
                  style: AppText.bodyMedium.copyWith(
                      fontSize: 16.sp,
                      height: 18 / 16,
                      color: data.danger ? AppColors.danger : AppColors.textDark,
                      fontWeight: FontWeight.w400)),
            ),
            _svg('chevron'),
          ],
        ),
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  const _SocialCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          Text('profile.follow_us'.tr(),
              textAlign: TextAlign.center,
              style: AppText.subtitle
                  .copyWith(fontSize: 14.sp, color: AppColors.textSecondary)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _social('instagram'),
              SizedBox(width: 16.w),
              _social('telegram'),
              SizedBox(width: 16.w),
              _social('facebook'),
            ],
          ),
          SizedBox(height: 12.h),
          Text('profile.supported_by'.tr(),
              textAlign: TextAlign.center,
              style: AppText.subtitle
                  .copyWith(fontSize: 14.sp, color: AppColors.textSecondary)),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.textDark,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('profile.call_center'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 4.w),
                  _svg('arrow_right', size: 20, color: AppColors.textOnDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _social(String name) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: const BoxDecoration(
        color: AppColors.fieldFill,
        shape: BoxShape.circle,
      ),
      child: _svg(name),
    );
  }
}
