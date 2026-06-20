import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';
const _images = 'assets/images';

/// Cargo (Pochta / Yuk yetkazma) flow — courier list along the route, with a
/// two-state tab toggle (Figma nodes 2187:19248 "Avtomatik" and 2237:9276
/// "Kuryerni tanlash"). Both states share the dark header + orange wrapper, so
/// they are modelled as one page that switches its body on the active tab.
@RoutePage()
class CargoDriversPage extends StatefulWidget {
  const CargoDriversPage({super.key});

  @override
  State<CargoDriversPage> createState() => _CargoDriversPageState();
}

enum _Tab { auto, pick }

class _CargoDriversPageState extends State<CargoDriversPage> {
  _Tab _tab = _Tab.pick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border, // Gray/20 #E2E8F0
      body: Column(
        children: [
          const _CargoHeader(),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Container(
                color: AppColors.orange, // Warning/50 #F59E0B wrapper edge
                child: Container(
                  color: AppColors.border,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        color: AppColors.accent,
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          children: [
                            _TabSwitcher(
                              tab: _tab,
                              onChanged: (t) => setState(() => _tab = t),
                            ),
                            SizedBox(height: 12.h),
                            if (_tab == _Tab.auto)
                              const _AutoState()
                            else
                              const _PickState(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header (dark wrapper + white title bar)
// ---------------------------------------------------------------------------
class _CargoHeader extends StatelessWidget {
  const _CargoHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textDark, // Gray/90 #0F172A
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
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(16.r)),
          ),
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
                  'cargo.cdrivers_title'.tr(),
                  textAlign: TextAlign.center,
                  style: AppText.screenTitle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
                ),
              ),
              SizedBox(width: 32.r),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab switcher (Avtomatik / Kuryerni tanlash) — sits on an orange card
// ---------------------------------------------------------------------------
class _TabSwitcher extends StatelessWidget {
  final _Tab tab;
  final ValueChanged<_Tab> onChanged;
  const _TabSwitcher({required this.tab, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.orange, // Warning/50
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Pill toggle.
          Container(
            height: 48.h,
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: 'cargo.cdrivers_tab_auto'.tr(),
                    active: tab == _Tab.auto,
                    trailingPause: tab == _Tab.auto,
                    onTap: () => onChanged(_Tab.auto),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: 'cargo.cdrivers_tab_pick'.tr(),
                    active: tab == _Tab.pick,
                    onTap: () => onChanged(_Tab.pick),
                  ),
                ),
              ],
            ),
          ),
          // Status strip (white text on orange).
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tab == _Tab.auto
                      ? 'cargo.cdrivers_searching'.tr()
                      : 'cargo.cdrivers_drivers'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textOnDark),
                ),
                Row(
                  children: [
                    SvgPicture.asset('$_icons/taxi_row.svg',
                        width: 24.r,
                        height: 24.r,
                        colorFilter: ColorFilter.mode(
                            AppColors.textOnDark, BlendMode.srcIn)),
                    SizedBox(width: 8.w),
                    Text(
                      tab == _Tab.auto
                          ? '4/13'
                          : 'cargo.cdrivers_count'
                              .tr(namedArgs: {'count': '13'}),
                      style: AppText.subtitle.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textOnDark),
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

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final bool trailingPause;
  final VoidCallback onTap;
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.trailingPause = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: const Color(0x14000000),
                      blurRadius: 4),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: AppText.subtitle.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: active ? AppColors.textDark : AppColors.textMuted)),
            if (trailingPause) ...[
              SizedBox(width: 6.w),
              SvgPicture.asset('$_icons/ib_pause_circle.svg',
                  width: 22.r,
                  height: 22.r,
                  colorFilter: ColorFilter.mode(
                      AppColors.textDark, BlendMode.srcIn)),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// State A — Avtomatik (auto search in progress)
// ---------------------------------------------------------------------------
class _AutoState extends StatelessWidget {
  const _AutoState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('cargo.cdrivers_wait_title'.tr(),
                textAlign: TextAlign.center,
                style: AppText.subtitle.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 26 / 18,
                    color: AppColors.textDark)),
            SizedBox(height: 4.h),
            Text('cargo.cdrivers_wait_sub'.tr(),
                textAlign: TextAlign.center,
                style: AppText.subtitle.copyWith(
                    fontSize: 14.sp,
                    height: 16 / 14,
                    color: AppColors.textPrimary)),
          ],
        ),
        SizedBox(height: 12.h),
        // Price row.
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('cargo.cdrivers_price'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 14.sp, color: AppColors.textDark)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '100 000 ',
                        style: AppText.screenTitle.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark)),
                    TextSpan(
                        text: 'cargo.cdrivers_currency'.tr(),
                        style: AppText.screenTitle.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 24.h, color: AppColors.fieldFill),
        // Cancel button.
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.router.maybePop(),
            child: Container(
              height: 48.h,
              padding: EdgeInsets.only(left: 16.w, right: 8.w),
              decoration: BoxDecoration(
                color: AppColors.accent,
                border: Border.all(color: AppColors.logoutRed),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('cargo.cdrivers_cancel'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.logoutRed)),
                  SizedBox(width: 4.w),
                  SvgPicture.asset('$_icons/od_close.svg',
                      width: 20.r,
                      height: 20.r,
                      colorFilter: ColorFilter.mode(
                          AppColors.logoutRed, BlendMode.srcIn)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// State B — Kuryerni tanlash (offer-card list)
// ---------------------------------------------------------------------------
class _PickState extends StatelessWidget {
  const _PickState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OfferCard(
          mode: _CardMode.pickup,
          avatar: 'ic_driver1',
          name: 'Akbar Yoldoshev',
          rating: '8.6',
          price: '60 000 som',
          car: 'Cobalt LTZ | Oq',
        ),
        SizedBox(height: 16.h),
        _OfferCard(
          mode: _CardMode.pickup,
          avatar: 'ic_driver2',
          name: 'Akbar Yoldoshev',
          rating: '8.6',
          price: '60 000 som',
          car: 'Cobalt LTZ | Oq',
        ),
        SizedBox(height: 16.h),
        _OfferCard(
          mode: _CardMode.deliver,
          avatar: 'ic_driver3',
          name: 'Akbar Yoldoshev',
          rating: '8.6',
          price: '60 000 som',
          car: 'Cobalt LTZ | Oq',
        ),
      ],
    );
  }
}

enum _CardMode { pickup, deliver }

class _OfferCard extends StatelessWidget {
  final _CardMode mode;
  final String avatar;
  final String name;
  final String rating;
  final String price;
  final String car;

  const _OfferCard({
    required this.mode,
    required this.avatar,
    required this.name,
    required this.rating,
    required this.price,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    final bool pickup = mode == _CardMode.pickup;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.router.push(const CargoDriverDetailRoute()),
      child: Container(
        decoration: BoxDecoration(
          color: pickup
              ? const Color(0xFF3B82F6) // Blue/50
              : AppColors.textSecondary, // Gray/40 #94A3B8
          border: pickup
              ? Border.all(color: AppColors.ctaBlue) // Blue/60
              : null,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            // Banner row.
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      pickup
                          ? 'cargo.coffer_pickup_from'.tr()
                          : 'cargo.coffer_you_deliver'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 15.sp,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textOnDark)),
                  SvgPicture.asset(
                      pickup
                          ? '$_icons/cb_truck.svg'
                          : '$_icons/cb_directbox.svg',
                      width: 24.r,
                      height: 24.r,
                      colorFilter: ColorFilter.mode(
                          AppColors.textOnDark, BlendMode.srcIn)),
                ],
              ),
            ),
            // White body.
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  // Time row.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('cargo.coffer_leaving_at'.tr(),
                          style: AppText.bodyMedium.copyWith(
                              fontSize: 16.sp, color: AppColors.textMuted)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.fieldFill,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '15 aprel, ',
                                  style: AppText.bodyMedium.copyWith(
                                      fontSize: 16.sp,
                                      color: AppColors.textMuted)),
                              TextSpan(
                                  text: '16:00',
                                  style: AppText.bodyMedium.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24.h, color: AppColors.fieldFill),
                  // Price + car.
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(price,
                                style: AppText.screenTitle.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark)),
                            SizedBox(height: 2.h),
                            Text(car,
                                style: AppText.label.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24.h, color: AppColors.fieldFill),
                  // Driver + arrow.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset('$_images/$avatar.png',
                                width: 48.r, height: 48.r, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: AppText.bodyMedium.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark)),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 16.r,
                                      color: AppColors.accentYellow),
                                  SizedBox(width: 2.w),
                                  Text(rating,
                                      style: AppText.subtitle.copyWith(
                                          fontSize: 14.sp,
                                          color: AppColors.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 52.r,
                        width: 52.r,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          border: Border.all(color: AppColors.fieldFill),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: SvgPicture.asset('$_icons/ia_arrow_right.svg',
                            width: 20.r, height: 20.r),
                      ),
                    ],
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
