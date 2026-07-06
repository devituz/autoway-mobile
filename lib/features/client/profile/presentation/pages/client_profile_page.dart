import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/language_sheet.dart';
import '../widgets/logout_sheet.dart';

const _icons = 'assets/icons';

/// Formats an amount with thin-space thousands separators: 50000 -> "50 000".
String _money(num value) {
  final s = value.toInt().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// Client app — Profile tab (Profil). 1:1 with the Figma design (node 2232:24130).
class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load the real profile from /me the first time the tab is shown.
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<ProfileCubit>().load());
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showLogoutSheet(context);
    if (confirmed != true || !context.mounted) return;
    await context.read<ProfileCubit>().logout();
    if (context.mounted) {
      context.router.replaceAll([const LanguageRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Split background so over-scroll matches (dark top, light bottom).
          Column(
            children: [
              Container(height: 250.h, color: AppColors.primary),
              Expanded(child: Container(color: AppColors.lightGrey)),
            ],
          ),
          RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().load(force: true),
            color: AppColors.primary,
            child: SingleChildScrollView(
            // Hard scroll boundary — no overscroll bounce, so the split
            // background can never peek out weirdly past the content edges.
            physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics()),
            child: Column(
              children: [
          // Dark header with rounded bottom (Figma 2232:24130).
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(24.r)),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Title + notifications bell.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('profile.title'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.textOnDark,
                                fontWeight: FontWeight.w600)),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              context.router.push(const NotificationsRoute()),
                          child: SizedBox(
                            width: 48.r,
                            height: 48.r,
                            child: Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  _svg('bell', color: AppColors.textOnDark),
                                  Positioned(
                                    top: -4.r,
                                    right: -4.r,
                                    child: Container(
                                      width: 16.r,
                                      height: 16.r,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: AppColors.badgeRed,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text('9',
                                          style: AppText.subtitle.copyWith(
                                              fontSize: 10.sp,
                                              color: AppColors.textOnDark,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // User row + edit button.
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                final avatarUrl = state.user?.avatarUrl ?? '';
                                final fallback = Container(
                                  width: 48.r,
                                  height: 48.r,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Colors.white24,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.person,
                                      size: 26.sp, color: Colors.white),
                                );
                                if (avatarUrl.isEmpty) return fallback;
                                return ClipOval(
                                  child: Image.network(
                                    avatarUrl,
                                    width: 48.r,
                                    height: 48.r,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => fallback,
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                final u = state.user;
                                final name = (u?.fullName.isNotEmpty ?? false)
                                    ? u!.fullName
                                    : '—';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name,
                                        style: AppText.subtitle.copyWith(
                                            fontSize: 18.sp,
                                            color: AppColors.textOnDark,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        'profile.id'.tr(namedArgs: {
                                          'id': '${u?.idBalance ?? 0}'
                                        }),
                                        style: AppText.subtitle.copyWith(
                                            fontSize: 14.sp,
                                            color: AppColors.textOnDark)),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              context.router.push(const EditProfileRoute()),
                          child: SizedBox(
                            width: 44.r,
                            height: 44.r,
                            child: Center(
                              child: _svg('edit', color: AppColors.textOnDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider.
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  // Wallet / balance row.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.router.push(const TopUpRoute()),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _svg('wallet', color: AppColors.textOnDark),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocBuilder<ProfileCubit, ProfileState>(
                                    builder: (context, state) => Text(
                                        '${_money(state.user?.balance ?? 0)} ${'home.currency'.tr()}',
                                        style: AppText.subtitle.copyWith(
                                            fontSize: 14.sp,
                                            color: AppColors.textOnDark,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Text('Balansingiz',
                                      style: AppText.subtitle.copyWith(
                                          fontSize: 12.sp,
                                          color: Colors.white
                                              .withValues(alpha: 0.5))),
                                ],
                              ),
                            ],
                          ),
                          _svg('chevron',
                              size: 20, color: AppColors.textOnDark),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Body (scrolls together with the header).
          Container(
            color: AppColors.lightGrey,
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
            child: Column(
              children: [
                    _MenuCard(items: [
                      _MenuData(
                        'orders_history',
                        'profile.orders_history',
                        onTap: () =>
                            context.router.push(const PaymentHistoryRoute()),
                      ),
                      _MenuData(
                        'bell',
                        'profile.messages',
                        onTap: () =>
                            context.router.push(const NotificationsRoute()),
                      ),
                      _MenuData(
                        'language',
                        'profile.app_language',
                        onTap: () => _openLanguageSheet(context),
                      ),
                    ]),
                    SizedBox(height: 8.h),
                    _MenuCard(
                      items: [
                        const _MenuData('about', 'profile.rules'),
                        const _MenuData('guide', 'profile.video_guide'),
                        const _MenuData('offer', 'profile.public_offer'),
                        const _MenuData('privacy', 'profile.privacy'),
                        const _MenuData('about', 'profile.about'),
                        const _MenuData('messages', 'profile.suggestions'),
                        _MenuData(
                          'logout',
                          'profile.logout',
                          danger: true,
                          onTap: () => _handleLogout(context),
                        ),
                      ],
                      footer: const _SocialFooter(),
                    ),
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

class _MenuData {
  final String icon;
  final String labelKey;
  final bool danger;
  final VoidCallback? onTap;
  const _MenuData(this.icon, this.labelKey, {this.danger = false, this.onTap});
}

class _MenuCard extends StatelessWidget {
  final List<_MenuData> items;
  final Widget? footer;
  const _MenuCard({required this.items, this.footer});

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
          for (final it in items) _MenuTile(data: it),
          ?footer,
        ],
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
              child: _svg(data.icon,
                  color: data.danger ? AppColors.logoutRed : null),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(data.labelKey.tr(),
                  style: AppText.bodyMedium.copyWith(
                      fontSize: 14.sp,
                      color: data.danger
                          ? AppColors.logoutRed
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w400)),
            ),
            _svg('chevron'),
          ],
        ),
      ),
    );
  }
}

class _SocialFooter extends StatelessWidget {
  const _SocialFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          color: AppColors.border,
        ),
        Text('profile.follow_us'.tr(),
            textAlign: TextAlign.center,
            style: AppText.subtitle
                .copyWith(fontSize: 14.sp, color: AppColors.textMuted)),
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
                .copyWith(fontSize: 14.sp, color: AppColors.textMuted)),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          height: 48.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.fieldFill,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('profile.call_center'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500)),
              SizedBox(width: 4.w),
              _svg('headphone', size: 20),
            ],
          ),
        ),
      ],
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
