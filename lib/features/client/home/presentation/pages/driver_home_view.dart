import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Driver-mode home (Figma 2193:20944 offline / 2222:28540 online "Siz
/// liniyadasiz"). Shown inside [HomePage] when the role toggle is set to
/// Haydovchi. Offline shows three service cards with go-online buttons; once
/// online a red banner appears and an active offer card replaces them.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerDark,
      body: Stack(
        children: [
          Column(
            children: [
              Container(height: 300.h, color: AppColors.headerDark),
              Expanded(child: Container(color: AppColors.accent)),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _Header(
                  role: widget.role,
                  online: _online,
                  onRoleChanged: widget.onRoleChanged,
                  onBellTap: () =>
                      context.router.push(const NotificationsRoute()),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.r)),
                  ),
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CarCard(),
                      SizedBox(height: 8.h),
                      const _DashLine(),
                      SizedBox(height: 16.h),
                      if (_online)
                        _OfferCard(onBack: () => setState(() => _online = false))
                      else
                        _ServiceCards(onGoOnline: () =>
                            setState(() => _online = true)),
                      SizedBox(height: 16.h),
                      Text('home.driver_services'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark)),
                      SizedBox(height: 16.h),
                      const _HizmatlarRow(),
                    ],
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

// ─────────────────────────── Header ───────────────────────────

class _Header extends StatelessWidget {
  final int role;
  final bool online;
  final ValueChanged<int> onRoleChanged;
  final VoidCallback onBellTap;
  const _Header(
      {required this.role,
      required this.online,
      required this.onRoleChanged,
      required this.onBellTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AutoWay',
                        style: AppText.bodyLarge.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w800)),
                    Text('home.tagline'.tr(),
                        style: AppText.label
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                if (online) ...[
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      height: 32.h,
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        color: AppColors.badgeRed,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.logoutRed,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('home.driver_you_online'.tr(),
                                style: AppText.subtitle.copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.textOnDark,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(width: 6.w),
                            Icon(Icons.bolt,
                                size: 16.sp, color: AppColors.textOnDark),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ] else
                  const Spacer(),
                _BellButton(count: 9, onTap: onBellTap),
              ],
            ),
            SizedBox(height: 16.h),
            _RoleToggle(role: role, onChanged: onRoleChanged),
            SizedBox(height: 16.h),
            const _StatsRow(),
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
            Icon(Icons.notifications_none,
                size: 28.sp, color: AppColors.textOnDark),
            Positioned(
              right: -2.w,
              top: -2.h,
              child: Container(
                padding: EdgeInsets.all(4.r),
                constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
                decoration: const BoxDecoration(
                    color: AppColors.error, shape: BoxShape.circle),
                child: Text('$count',
                    textAlign: TextAlign.center,
                    style: AppText.label.copyWith(
                        color: AppColors.textOnDark,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700)),
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
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
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
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: AppText.button.copyWith(
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textOnDark)),
              SizedBox(width: 8.w),
              Icon(icon,
                  size: 18.sp,
                  color:
                      selected ? AppColors.textPrimary : AppColors.textOnDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined,
                  size: 24.sp, color: AppColors.textOnDark),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('50 000 ${'home.currency'.tr()}',
                        style: AppText.bodyMedium.copyWith(
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w700)),
                    Text('home.balance'.tr(),
                        style: AppText.label
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  size: 20.sp, color: AppColors.textOnDark),
            ],
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
        color: const Color(0xFF334155),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

// ─────────────────────────── Car card ───────────────────────────

class _CarCard extends StatelessWidget {
  const _CarCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    Text('01 B 125 YC',
                        style: AppText.bodyMedium.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: 2.h),
                    Text('Cobalt LTZ | Oq',
                        style: AppText.subtitle
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              Image.asset('assets/images/dr_car.png',
                  width: 145.w, height: 60.h, fit: BoxFit.contain),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 32.r,
              height: 32.r,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: AppColors.accent, shape: BoxShape.circle),
              child: Icon(Icons.settings_outlined,
                  size: 18.sp, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashLine extends StatelessWidget {
  const _DashLine();

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
            (_) => Container(width: dashW, height: 2, color: AppColors.border),
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
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          _ServiceCard(
            icon: 'c_driving',
            label: 'home.intercity_taxi'.tr(),
            buttonLabel: 'home.driver_accept_order'.tr(),
            dark: false,
            onTap: onGoOnline,
          ),
          SizedBox(width: 8.w),
          _ServiceCard(
            icon: 'c_box',
            label: 'home.cargo'.tr(),
            buttonLabel: 'home.driver_go_online'.tr(),
            dark: false,
            onTap: onGoOnline,
          ),
          SizedBox(width: 8.w),
          _ServiceCard(
            icon: 'c_routing',
            label: 'home.route_taxi'.tr(),
            buttonLabel: 'home.driver_go_online'.tr(),
            dark: true,
            onTap: onGoOnline,
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String icon;
  final String label;
  final String buttonLabel;
  final bool dark;
  final VoidCallback onTap;
  const _ServiceCard(
      {required this.icon,
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
                    color: Color(0xFFF8FAFC), shape: BoxShape.circle),
                child: SvgPicture.asset('$_icons/$icon.svg',
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                        dark ? AppColors.pink : AppColors.selectBlue,
                        BlendMode.srcIn)),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(label,
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        height: 16 / 14,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600)),
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
                border: dark
                    ? null
                    : Border.all(color: AppColors.selectBlue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(buttonLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.subtitle.copyWith(
                            fontSize: 14.sp,
                            color: dark
                                ? AppColors.textOnDark
                                : AppColors.selectBlue,
                            fontWeight: FontWeight.w500)),
                  ),
                  if (dark) ...[
                    SizedBox(width: 4.w),
                    Icon(Icons.bolt, size: 18.sp, color: AppColors.textOnDark),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.ctaBlue,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('home.intercity_taxi'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 15.sp,
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w500)),
                SvgPicture.asset('$_icons/ia_taxi.svg',
                    width: 24.r,
                    height: 24.r,
                    colorFilter: const ColorFilter.mode(
                        AppColors.textOnDark, BlendMode.srcIn)),
              ],
            ),
          ),
          Container(
            color: AppColors.fieldFill,
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Pickup / dropoff card.
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.r),
                              child: SvgPicture.asset('$_icons/mt_location.svg',
                                  width: 20.r, height: 20.r),
                            ),
                            Expanded(
                              child: Container(
                                  width: 1.5, color: AppColors.border),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.r),
                              child: SvgPicture.asset('$_icons/mt_flag.svg',
                                  width: 20.r, height: 20.r),
                            ),
                          ],
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
                                  child: Text('Toshkent shahri',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.subtitle.copyWith(
                                          fontSize: 16.sp,
                                          color: AppColors.textDark,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              Divider(height: 1.h, color: AppColors.border),
                              SizedBox(
                                height: 37.h,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Andijon shahri, Andijon viloyati',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.subtitle.copyWith(
                                          fontSize: 16.sp,
                                          color: AppColors.textDark,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Taxi / Posilka selectors.
                Row(
                  children: [
                    Expanded(
                      child: _TypeRow(
                          label: 'home.driver_taxi'.tr(), checked: true),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _TypeRow(
                          label: 'home.driver_parcel'.tr(), checked: false),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Divider(height: 1.h, color: AppColors.border),
                SizedBox(height: 12.h),
                // Back-to-accept button.
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack,
                  child: Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.logoutRed,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.badgeRed, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('home.driver_back_to_accept'.tr(),
                              textAlign: TextAlign.center,
                              style: AppText.subtitle.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.textOnDark,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Icon(Icons.bolt, size: 22.sp, color: AppColors.textOnDark),
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

class _TypeRow extends StatelessWidget {
  final String label;
  final bool checked;
  const _TypeRow({required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: AppText.subtitle
                  .copyWith(fontSize: 16.sp, color: AppColors.textDark)),
        ),
        Container(
          width: 28.r,
          height: 28.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: checked ? AppColors.ctaBlue : const Color(0xFFF8FAFC),
            shape: BoxShape.circle,
          ),
          child: Icon(checked ? Icons.check : Icons.remove,
              size: 14.sp,
              color: checked ? AppColors.textOnDark : AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─────────────────────────── Hizmatlar ───────────────────────────

class _HizmatlarRow extends StatelessWidget {
  const _HizmatlarRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HizmatCard(icon: 'dr_cpu', label: 'home.driver_servis'.tr()),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _HizmatCard(icon: 'c_flash', label: 'home.energy'.tr()),
        ),
      ],
    );
  }
}

class _HizmatCard extends StatelessWidget {
  final String icon;
  final String label;
  const _HizmatCard({required this.icon, required this.label});

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
                    color: Color(0xFFF8FAFC), shape: BoxShape.circle),
                child: SvgPicture.asset('$_icons/$icon.svg',
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                        AppColors.textDark, BlendMode.srcIn)),
              ),
              Icon(Icons.chevron_right,
                  size: 20.sp, color: AppColors.textSecondary),
            ],
          ),
          const Spacer(),
          Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.subtitle.copyWith(
                  fontSize: 14.sp,
                  height: 16 / 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
