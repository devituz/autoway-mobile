import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/role/role_cubit.dart';
import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import 'driver_home_view.dart';

/// Main client screen body (Bosh sahifa tab) hosted inside [MainShellPage].
/// Pixel specs from Figma node 2231:6225.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Role is app-wide and persisted (RoleCubit) so the choice survives
    // restarts and the Profile tab can mirror it.
    final role = context.watch<RoleCubit>().state;
    void setRole(int i) => context.read<RoleCubit>().setRole(i);

    // Driver mode shows a different home (Figma 2193:20944 / 2222:28540).
    if (role == 1) {
      return DriverHomeView(role: role, onRoleChanged: setRole);
    }
    // Figma proto 2165:9528: the logo bar (status bar + AutoWay + bell) is
    // pinned on top; toggle, wallet panel and the white sheet scroll under it.
    // Background is fully dark so any overscroll bounce reveals the same color.
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => context.read<ProfileCubit>().load(force: true),
            color: AppColors.ctaBlue,
            backgroundColor: AppColors.accent,
            // Spinner drops out from under the pinned logo bar.
            edgeOffset: MediaQuery.paddingOf(context).top + 48.h,
            child: SingleChildScrollView(
              // Hard scroll boundary — no overscroll bounce, so background
              // colors can never peek out past the content edges. Always
              // scrollable so pull-to-refresh works from the very top.
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              child: Column(
                children: [
                  // Scrolls away under the pinned bar. Same panel color so at
                  // rest it reads as one continuous block (Figma 2087327505).
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.homePanel,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16.r),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        // 56 = pinned logo row (48) + gap (8).
                        padding: EdgeInsets.fromLTRB(16.w, 56.h, 16.w, 8.h),
                        child: _RoleToggle(role: role, onChanged: setRole),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _WalletPanel(
                    balance: '50 000',
                    onTopUpTap: () {},
                    onBannerTap: () =>
                        context.router.push(const GoOnlineRoute()),
                  ),
                  Container(
                    width: double.infinity,
                    // Panel color shows through the sheet's rounded corners
                    // (Figma: the wallet panel extends behind the white sheet).
                    color: AppColors.homePanel,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _CompactGrid(),
                          SizedBox(height: 16.h),
                          const _DashedLine(color: AppColors.border),
                          SizedBox(height: 16.h),
                          Text(
                            'home.my_active_orders'.tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              height: 26 / 18,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _OrderCard(
                            headerColor: AppColors.orderBlue,
                            borderColor: AppColors.ctaBlue,
                            status: 'home.status_driver_coming'.tr(),
                            headerIcon: Icons.directions_car_filled,
                            service: 'home.intercity_taxi'.tr(),
                          ),
                          SizedBox(height: 16.h),
                          _OrderCard(
                            headerColor: AppColors.orderGreen,
                            borderColor: AppColors.orderGreen,
                            status: 'home.status_accepted'.tr(),
                            headerIcon: Icons.local_taxi,
                            service: 'home.cargo'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Pinned logo bar (Figma 2087327504: FIXED, 108h, bottom r16).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _PinnedBar(
              onBellTap: () => context.router.push(const NotificationsRoute()),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Pinned logo bar ───────────────────────

class _PinnedBar extends StatelessWidget {
  final VoidCallback onBellTap;

  const _PinnedBar({required this.onBellTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.homePanel,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            height: 48.h,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Two-tone logo: "Auto" white + "Way" #BFD1FF (Figma).
                    Text.rich(
                      TextSpan(
                        style: AppText.logo.copyWith(
                          color: AppColors.textOnDark,
                        ),
                        children: const [
                          TextSpan(text: 'Auto'),
                          TextSpan(
                            text: 'Way',
                            style: TextStyle(color: AppColors.logoWay),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'home.tagline'.tr(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _BellButton(count: 9, onTap: onBellTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _BellButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 34.r,
        height: 34.r,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications_none,
              size: 28.sp,
              color: AppColors.textOnDark,
            ),
            Positioned(
              right: -2.w,
              top: -2.h,
              child: Container(
                width: 16.r,
                height: 16.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.badgeRed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textOnDark,
                    fontSize: 10.sp,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleToggle extends StatelessWidget {
  final int role;
  final ValueChanged<int> onChanged;

  const _RoleToggle({required this.role, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: AppColors.homeBg,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 4)],
      ),
      child: Row(
        children: [
          _seg('home.passenger'.tr(), Icons.person_outline, 0),
          _seg('home.driver'.tr(), Icons.local_taxi_outlined, 1),
        ],
      ),
    );
  }

  Widget _seg(String label, IconData icon, int i) {
    final selected = role == i;
    final color = selected ? AppColors.textDark : AppColors.textMuted;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 15,
                  color: color,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(icon, size: 20.sp, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────── Wallet panel (dark) ───────────────────────

class _WalletPanel extends StatelessWidget {
  final String balance;
  final VoidCallback onTopUpTap;
  final VoidCallback onBannerTap;

  const _WalletPanel({
    required this.balance,
    required this.onTopUpTap,
    required this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homePanel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      child: Column(
        children: [
          _WalletRow(balance: balance, onTopUpTap: onTopUpTap),
          SizedBox(height: 12.h),
          const _DashedLine(color: AppColors.dashDark),
          SizedBox(height: 12.h),
          _ActiveOrderBanner(
            service: 'home.intercity_taxi'.tr(),
            onTap: onBannerTap,
          ),
        ],
      ),
    );
  }
}

class _WalletRow extends StatelessWidget {
  final String balance;
  final VoidCallback onTopUpTap;
  const _WalletRow({required this.balance, required this.onTopUpTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          size: 24.sp,
          color: AppColors.textOnDark,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$balance ${'home.currency'.tr()}',
              style: AppText.balance.copyWith(color: AppColors.textOnDark),
            ),
            SizedBox(height: 4.h),
            Text(
              'home.balance'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 10 / 12,
                color: AppColors.textOnDark,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTopUpTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 36.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(color: AppColors.softDark),
            ),
            child: Row(
              children: [
                Text(
                  'home.top_up'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const dashW = 6.0;
        final count = (c.maxWidth / (dashW * 2)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: dashW, height: 1, color: color),
          ),
        );
      },
    );
  }
}

class _ActiveOrderBanner extends StatelessWidget {
  final String service;
  final VoidCallback onTap;
  const _ActiveOrderBanner({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.ctaBlue,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'home.active_order_banner'.tr(namedArgs: {'service': service}),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDark,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.chevron_right, size: 20.sp, color: AppColors.textOnDark),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────── Service cards ───────────────────────

class _CompactGrid extends StatelessWidget {
  const _CompactGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        label: 'home.intercity_taxi'.tr(),
        icon: 'c_driving',
        color: AppColors.selectBlue,
        onTap: () => context.router.push(const IntercityAddressRoute()),
      ),
      (
        label: 'home.cargo'.tr(),
        icon: 'c_box',
        color: AppColors.iconAmber,
        onTap: () => context.router.push(const CargoAddressRoute()),
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 175 / 120,
      ),
      itemBuilder: (_, i) => _CompactCard(
        label: items[i].label,
        icon: items[i].icon,
        color: items[i].color,
        onTap: items[i].onTap,
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  const _CompactCard({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.cardLight,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    width: 24.sp,
                    height: 24.sp,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const Spacer(),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                height: 16 / 14,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Order card ───────────────────────────

class _OrderCard extends StatelessWidget {
  final Color headerColor;
  final Color borderColor;
  final String status;
  final IconData headerIcon;
  final String service;

  const _OrderCard({
    required this.headerColor,
    required this.borderColor,
    required this.status,
    required this.headerIcon,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 15,
                    color: AppColors.textOnDark,
                  ),
                ),
                Icon(headerIcon, size: 22.sp, color: AppColors.textOnDark),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                const _RouteBox(
                  from: 'Toshkent shahri',
                  to: 'Andijon shahri, Andijon viloyati',
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service,
                            style: AppText.serviceTitle.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            'home.depart_at'.tr(
                              namedArgs: {'time': '16:00, 15 aprel'},
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 18 / 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.fieldFill),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        size: 24.sp,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteBox extends StatelessWidget {
  final String from;
  final String to;

  const _RouteBox({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _row(Icons.location_on, from),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9.w),
                child: SizedBox(
                  height: 20.h,
                  child: const _DashedVerticalLine(color: AppColors.textDark),
                ),
              ),
              SizedBox(width: 11.w),
              const Expanded(
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border,
                ),
              ),
            ],
          ),
          _row(Icons.flag, to),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.selectBlue),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 21.76 / 16,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

/// Vertical dashed connector between route points (Figma: 4/4 dash, #0F172A).
class _DashedVerticalLine extends StatelessWidget {
  final Color color;
  const _DashedVerticalLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const dashH = 4.0;
        final count = (c.maxHeight / (dashH * 2)).floor().clamp(1, 100);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: 1, height: dashH, color: color),
          ),
        );
      },
    );
  }
}
