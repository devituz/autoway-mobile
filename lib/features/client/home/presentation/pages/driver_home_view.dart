import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';

const _icons = 'assets/icons';

/// Driver-mode home (Figma 2193:20944 offline / 2222:28540 online "Siz
/// liniyadasiz"). Shown inside [HomePage] when the role toggle is set to
/// Haydovchi. Offline shows three service cards with go-online buttons; once
/// online a red pill appears in the pinned bar and an active offer card
/// replaces the cards row.
///
/// Mirrors the client home structure exactly (pinned logo bar + clamping
/// scroll + pull-to-refresh) so toggling Yo'lovchi/Haydovchi never jumps.
class DriverHomeView extends StatefulWidget {
  final int role;
  final ValueChanged<int> onRoleChanged;
  const DriverHomeView(
      {super.key, required this.role, required this.onRoleChanged});

  @override
  State<DriverHomeView> createState() => _DriverHomeViewState();
}

class _DriverHomeViewState extends State<DriverHomeView> {
  bool _online = false;

  Future<void> _goOnline() async {
    // Open the "Liniyaga chiqish" form; flip online only when it confirms.
    final ok =
        await context.router.push<bool>(const DriverGoOnlineRoute());
    if (ok == true && mounted) setState(() => _online = true);
  }

  @override
  Widget build(BuildContext context) {
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
              // Same scroll behavior as the client home: hard boundary, no
              // bounce, always scrollable so pull-to-refresh works.
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              child: Column(
                children: [
                  // Toggle block — identical geometry to the client home so
                  // the Yo'lovchi/Haydovchi switch stays in place.
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
                        child: _RoleToggle(
                          role: widget.role,
                          onChanged: widget.onRoleChanged,
                        ),
                      ),
                    ),
                  ),
                  // 24 — same toggle→panel gap as the client home, so the
                  // balance panel doesn't jump when switching roles.
                  SizedBox(height: 24.h),
                  const _BalancePanel(),
                  Container(
                    width: double.infinity,
                    // Panel color shows through the sheet's rounded corners.
                    color: AppColors.homePanel,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const _CarCard(),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            // Indicator is inset 16 inside the card edges
                            // (Figma 2193:21288: x 272..598).
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: const _PageIndicator(count: 3, active: 0),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const _DashedLine(color: AppColors.border),
                          ),
                          SizedBox(height: 16.h),
                          if (_online)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: _OfferCard(
                                onBack: () => setState(() => _online = false),
                              ),
                            )
                          else
                            _ServiceCards(onGoOnline: _goOnline),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'home.driver_services'.tr(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                height: 26 / 18,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const _HizmatlarRow(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Pinned logo bar (same as client; red pill appears when online).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _PinnedBar(
              online: _online,
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
  final bool online;
  final VoidCallback onBellTap;
  const _PinnedBar({required this.online, required this.onBellTap});

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
                if (online)
                  const Expanded(child: Center(child: _OnlinePill()))
                else
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

/// "Siz liniyadasiz ⚡" pill (Figma 2222:28811): 2px #FB7185 ring around a
/// #E11D48 body, r24, Poppins 500/15 white text + white flash.
class _OnlinePill extends StatelessWidget {
  const _OnlinePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: AppColors.rose40,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: AppColors.logoutRed,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'home.driver_you_online'.tr(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 15,
                color: AppColors.textOnDark,
              ),
            ),
            SizedBox(width: 6.w),
            SvgPicture.asset(
              '$_icons/c_flash.svg',
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                AppColors.textOnDark,
                BlendMode.srcIn,
              ),
            ),
          ],
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

// ─────────────────────── Balance + stats panel ───────────────────────

class _BalancePanel extends StatelessWidget {
  const _BalancePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.homePanel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          SvgPicture.asset('$_icons/wallet.svg', width: 24.r, height: 24.r),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unbounded 500/14 (Figma 2193:20950).
              Text(
                '50 000 ${'home.currency'.tr()}',
                style: AppText.balance.copyWith(color: AppColors.textOnDark),
              ),
              SizedBox(height: 4.h),
              Text(
                'home.balance'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          SvgPicture.asset(
            '$_icons/arrow_right.svg',
            width: 20.r,
            height: 20.r,
          ),
          const Spacer(),
          _StatTile(
            value: '7.9',
            valueColor: AppColors.orange,
            label: 'home.driver_rating'.tr(),
          ),
          SizedBox(width: 8.w),
          _StatTile(
            value: '69%',
            valueColor: AppColors.purpleStat,
            label: 'home.driver_activity'.tr(),
          ),
        ],
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
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.softDark,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unbounded 500/14 (Figma 2193:21242).
          Text(value, style: AppText.balance.copyWith(color: valueColor)),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Car card ───────────────────────────

class _CarCard extends StatelessWidget {
  const _CarCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plate — Unbounded 500/16 (Figma 2193:21366).
                      Text(
                        '01 B 125 YC',
                        style: AppText.serviceTitle.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Cobalt LTZ | Oq',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/dr_car.png',
                  width: 145.w,
                  height: 60.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Positioned(
            right: 8.w,
            top: 8.h,
            child: Container(
              width: 32.r,
              height: 32.r,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                '$_icons/settings.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.textDark,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carousel page indicator under the car card (Figma 2193:21288): three
/// 103x3 bars, active #0F172A, inactive #CBD5E1.
class _PageIndicator extends StatelessWidget {
  final int count;
  final int active;
  const _PageIndicator({required this.count, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 3.h,
              decoration: BoxDecoration(
                color: i == active ? AppColors.textDark : AppColors.gray30,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
        ],
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

// ─────────────────────── Offline: service cards ───────────────────────

class _ServiceCards extends StatelessWidget {
  final VoidCallback onGoOnline;
  const _ServiceCards({required this.onGoOnline});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        children: [
          _ServiceCard(
            icon: 'c_driving',
            iconColor: AppColors.selectBlue,
            label: 'home.intercity_taxi'.tr(),
            buttonLabel: 'home.driver_accept_order'.tr(),
            dark: false,
            onTap: onGoOnline,
          ),
          SizedBox(width: 8.w),
          _ServiceCard(
            icon: 'c_box',
            iconColor: AppColors.iconAmber,
            label: 'home.cargo'.tr(),
            buttonLabel: 'home.driver_go_online'.tr(),
            dark: false,
            onTap: onGoOnline,
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String label;
  final String buttonLabel;
  final bool dark;
  final VoidCallback onTap;
  const _ServiceCard(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.buttonLabel,
      required this.dark,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240.w,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldFill, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  '$_icons/$icon.svg',
                  width: 24.r,
                  height: 24.r,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 16 / 14,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: dark ? AppColors.textDark : const Color(0xFFF0F2FA),
                borderRadius: BorderRadius.circular(12.r),
                border: dark ? null : Border.all(color: AppColors.selectBlue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      buttonLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 20 / 14,
                        color:
                            dark ? AppColors.textOnDark : AppColors.selectBlue,
                      ),
                    ),
                  ),
                  if (dark) ...[
                    SizedBox(width: 4.w),
                    // Orange flash on the dark pill (Figma 249,115,22).
                    SvgPicture.asset(
                      '$_icons/c_flash.svg',
                      width: 20.r,
                      height: 20.r,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFF97316),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Online: offer card ───────────────────────

class _OfferCard extends StatelessWidget {
  final VoidCallback onBack;
  const _OfferCard({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ctaBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 32.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'home.intercity_taxi'.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      height: 24 / 15,
                      color: AppColors.textOnDark,
                    ),
                  ),
                  SvgPicture.asset(
                    '$_icons/ia_taxi.svg',
                    width: 24.r,
                    height: 24.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textOnDark,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
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
                const _PickupDropOffBox(
                  from: 'Toshkent shahri',
                  to: 'Andijon shahri, Andijon viloyati',
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _TypeRow(
                        label: 'home.driver_taxi'.tr(),
                        checked: true,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _TypeRow(
                        label: 'home.driver_parcel'.tr(),
                        checked: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                const _DashedLine(color: AppColors.gray30),
                SizedBox(height: 12.h),
                // Back-to-accepting-orders button.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack,
                  child: Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.logoutRed,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.rose40, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'home.driver_back_to_accept'.tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              height: 20 / 14,
                              color: AppColors.textOnDark,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          '$_icons/c_flash.svg',
                          width: 24.r,
                          height: 24.r,
                          colorFilter: const ColorFilter.mode(
                            AppColors.textOnDark,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickupDropOffBox extends StatelessWidget {
  final String from;
  final String to;
  const _PickupDropOffBox({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 28.r,
              child: Column(
                children: [
                  SizedBox(
                    width: 28.r,
                    height: 28.r,
                    child: Center(
                      child: SvgPicture.asset(
                        '$_icons/mt_location.svg',
                        width: 20.r,
                        height: 20.r,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: _DashedVerticalLine(color: AppColors.textDark),
                  ),
                  SizedBox(
                    width: 28.r,
                    height: 28.r,
                    child: Center(
                      child: SvgPicture.asset(
                        '$_icons/mt_flag.svg',
                        width: 20.r,
                        height: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 37.h,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        from,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 22 / 16,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  SizedBox(
                    height: 37.h,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        to,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 22 / 16,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  final String label;
  final bool checked;
  const _TypeRow({required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
              color: AppColors.textDark,
            ),
          ),
        ),
        Container(
          width: 28.r,
          height: 28.r,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.cardLight,
            shape: BoxShape.circle,
          ),
          child: checked
              ? Icon(Icons.check, size: 16.sp, color: AppColors.selectBlue)
              : Icon(Icons.remove, size: 16.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

/// Vertical dashed connector between route points (Figma: 4/4 dash, #0F172A).
/// CustomPaint (not LayoutBuilder) so it is safe inside IntrinsicHeight —
/// LayoutBuilder cannot report intrinsic dimensions and crashes layout there.
class _DashedVerticalLine extends StatelessWidget {
  final Color color;
  const _DashedVerticalLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(1, double.infinity),
      painter: _DashedVerticalLinePainter(color),
    );
  }
}

class _DashedVerticalLinePainter extends CustomPainter {
  final Color color;
  _DashedVerticalLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const dashH = 4.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final x = size.width / 2;
    double y = 0;
    while (y < size.height) {
      final end = (y + dashH) > size.height ? size.height : y + dashH;
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedVerticalLinePainter old) =>
      old.color != color;
}

// ─────────────────────────── Hizmatlar ───────────────────────────

class _HizmatlarRow extends StatelessWidget {
  const _HizmatlarRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HizmatCard(
            icon: 'dr_cpu',
            iconColor: AppColors.selectBlue,
            label: 'home.driver_servis'.tr(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _HizmatCard(
            icon: 'c_flash',
            iconColor: AppColors.iconTeal,
            label: 'home.energy'.tr(),
          ),
        ),
      ],
    );
  }
}

class _HizmatCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String label;
  const _HizmatCard(
      {required this.icon, required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
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
                  '$_icons/$icon.svg',
                  width: 24.r,
                  height: 24.r,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
    );
  }
}
