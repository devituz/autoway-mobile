import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../../../client/profile/presentation/cubit/profile_cubit.dart';
import '../../../../client/profile/presentation/cubit/profile_state.dart';
import '../../../../client/profile/presentation/widgets/logout_sheet.dart';

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

/// Driver app — Profile tab (Profil). Shown in place of [ClientProfilePage]
/// when the role toggle is Haydovchi. 1:1 with Figma node 2222:29476: dark
/// header with avatar + balance + Rayting/Faollik stat tiles, a driver action
/// menu (routes / transports / statistics / settings) and the shared info menu.
class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({super.key});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  @override
  void initState() {
    super.initState();
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
          Column(
            children: [
              Container(height: 280.h, color: AppColors.primary),
              Expanded(child: Container(color: AppColors.lightGrey)),
            ],
          ),
          RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().load(force: true),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _Header(onEdit: () => context.router.push(const EditProfileRoute())),
                  Container(
                    color: AppColors.lightGrey,
                    padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 16.h),
                    child: Column(
                      children: [
                        _MenuCard(items: [
                          _MenuData(
                            'c_routing',
                            'driver.profile.my_routes'.tr(),
                            onTap: () =>
                                context.router.push(const DriverRoutesRoute()),
                          ),
                          _MenuData(
                            'cb_truck',
                            'driver.profile.my_transports'.tr(),
                            status: 'driver.profile.pending'.tr(),
                            onTap: () =>
                                context.router.push(const TransportsRoute()),
                          ),
                          _MenuData(
                            'orders_history',
                            'driver.profile.statistics'.tr(),
                            onTap: () =>
                                context.router.push(const DriverStatsRoute()),
                          ),
                          _MenuData(
                            'settings',
                            'driver.profile.settings'.tr(),
                            onTap: () =>
                                context.router.push(const DriverSettingsRoute()),
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
                          translate: true,
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
}

class _Header extends StatelessWidget {
  final VoidCallback onEdit;
  const _Header({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
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
                    onTap: onEdit,
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
            // Balance card + Rayting / Faollik stat tiles.
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.router.push(const TopUpRoute()),
                      child: Container(
                        height: 64.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.softDark,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            _svg('wallet', color: AppColors.textOnDark),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${_money(state.user?.balance ?? 0)} ${'home.currency'.tr()}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppText.bodyMedium.copyWith(
                                            color: AppColors.textOnDark,
                                            fontWeight: FontWeight.w700)),
                                    Text('home.balance'.tr(),
                                        style: AppText.label.copyWith(
                                            color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                            ),
                            _svg('chevron', size: 18, color: AppColors.textOnDark),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _StatTile(
                      value: '7.9',
                      valueColor: AppColors.orange,
                      label: 'home.driver_rating'.tr()),
                  SizedBox(width: 8.w),
                  _StatTile(
                      value: '69%',
                      valueColor: const Color(0xFFA855F7),
                      label: 'home.driver_activity'.tr()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final Color valueColor;
  final String label;
  const _StatTile(
      {required this.value, required this.valueColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.w,
      height: 64.h,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.softDark,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: AppText.bodyMedium
                  .copyWith(color: valueColor, fontWeight: FontWeight.w700)),
          Text(label,
              style: AppText.label.copyWith(color: AppColors.textSecondary)),
        ],
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

class _MenuData {
  final String icon;
  final String label;
  final String? status;
  final bool danger;
  final VoidCallback? onTap;
  const _MenuData(this.icon, this.label,
      {this.status, this.danger = false, this.onTap});
}

class _MenuCard extends StatelessWidget {
  final List<_MenuData> items;
  final Widget? footer;
  // Info menu reuses translation-key labels (translate=true); the driver
  // action menu passes already-translated strings.
  final bool translate;
  const _MenuCard(
      {required this.items, this.footer, this.translate = false});

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
          for (final it in items) _MenuTile(data: it, translate: translate),
          ?footer,
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final _MenuData data;
  final bool translate;
  const _MenuTile({required this.data, required this.translate});

  @override
  Widget build(BuildContext context) {
    final label = translate ? data.label.tr() : data.label;
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
              child: Row(
                children: [
                  Flexible(
                    child: Text(label,
                        style: AppText.bodyMedium.copyWith(
                            fontSize: 14.sp,
                            color: data.danger
                                ? AppColors.logoutRed
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w400)),
                  ),
                  if (data.status != null) ...[
                    SizedBox(width: 4.w),
                    Text(': ${data.status}',
                        style: AppText.bodyMedium.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.orange,
                            fontWeight: FontWeight.w400)),
                  ],
                ],
              ),
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
