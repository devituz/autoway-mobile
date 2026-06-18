import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';

/// Main client screen body (Bosh sahifa tab) hosted inside [MainShellPage].
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _role = 0; // 0 = passenger, 1 = driver

  @override
  Widget build(BuildContext context) {
    // The whole page scrolls — the dark header scrolls away with the content.
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: Stack(
        children: [
          // Background split: top is dark, bottom is white.
          // This ensures that top overscroll bounces show dark and bottom overscroll shows white.
          Column(
            children: [
              Container(
                height: 380.h,
                color: AppColors.headerDark,
              ),
              Expanded(
                child: Container(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _Header(
                  role: _role,
                  onRoleChanged: (i) => setState(() => _role = i),
                  onBellTap: () => context.router.push(const NotificationsRoute()),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28.r)),
                  ),
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FeaturedGrid(),
                  SizedBox(height: 14.h),
                  Text('home.my_active_orders'.tr(),
                      style: AppText.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 14.h),
                  _OrderCard(
                    headerColor: AppColors.blue,
                    status: 'home.status_driver_coming'.tr(),
                    headerIcon: Icons.directions_car_filled,
                    service: 'home.intercity_taxi'.tr(),
                  ),
                  SizedBox(height: 16.h),
                  _OrderCard(
                    headerColor: AppColors.statusGreen,
                    status: 'home.status_accepted'.tr(),
                    headerIcon: Icons.local_taxi,
                    service: 'home.cargo'.tr(),
                  ),
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
  final ValueChanged<int> onRoleChanged;
  final VoidCallback onBellTap;

  const _Header({
    required this.role,
    required this.onRoleChanged,
    required this.onBellTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 18.h),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const Spacer(),
                _BellButton(count: 9, onTap: onBellTap),
              ],
            ),
            SizedBox(height: 16.h),
            _RoleToggle(role: role, onChanged: onRoleChanged),
            SizedBox(height: 18.h),
            _WalletRow(balance: '50 000'),
            SizedBox(height: 14.h),
            const _DashedLine(),
            SizedBox(height: 14.h),
            _ActiveOrderBanner(service: 'home.intercity_taxi'.tr()),
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
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
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

class _WalletRow extends StatelessWidget {
  final String balance;
  const _WalletRow({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.account_balance_wallet_outlined,
            size: 26.sp, color: AppColors.textOnDark),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$balance ${'home.currency'.tr()}',
                style: AppText.bodyMedium.copyWith(
                    color: AppColors.textOnDark, fontWeight: FontWeight.w700)),
            Text('home.balance'.tr(),
                style:
                    AppText.label.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Text('home.top_up'.tr(),
                  style: AppText.subtitle.copyWith(
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.w600)),
              SizedBox(width: 6.w),
              Icon(Icons.chevron_right,
                  size: 18.sp, color: AppColors.textOnDark),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

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
            (_) => Container(
              width: dashW,
              height: 1,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        );
      },
    );
  }
}

class _ActiveOrderBanner extends StatelessWidget {
  final String service;
  const _ActiveOrderBanner({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'home.active_order_banner'.tr(namedArgs: {'service': service}),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppText.button.copyWith(color: AppColors.textOnDark),
            ),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.chevron_right, size: 20.sp, color: AppColors.textOnDark),
        ],
      ),
    );
  }
}

// ─────────────────────── Service cards ───────────────────────

class _FeaturedGrid extends StatelessWidget {
  const _FeaturedGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'home.intercity_taxi'.tr(), iconPath: 'assets/images/ill_taxi.png', arrow: false),
      (label: 'home.cargo'.tr(), iconPath: 'assets/images/ill_box.png', arrow: false),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (_, i) => _FeaturedCard(
        label: items[i].label,
        iconPath: items[i].iconPath,
        showArrow: items[i].arrow,
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool showArrow;

  const _FeaturedCard({
    required this.label,
    required this.iconPath,
    required this.showArrow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 110.w,
              child: Text(label,
                  style: AppText.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              iconPath,
              height: 60.h,
              fit: BoxFit.contain,
            ),
          ),
          if (showArrow)
            Align(
              alignment: Alignment.bottomLeft,
              child: Icon(Icons.chevron_right,
                  size: 22.sp, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _CompactGrid extends StatelessWidget {
  const _CompactGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'home.intercity_short'.tr(), icon: Icons.local_taxi_outlined, color: AppColors.blue),
      (label: 'home.cargo'.tr(), icon: Icons.inventory_2_outlined, color: AppColors.orange),
      (label: 'home.route_taxi'.tr(), icon: Icons.route_outlined, color: AppColors.pink),
      (label: 'home.energy'.tr(), icon: Icons.bolt_outlined, color: AppColors.statusGreen),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, i) => _CompactCard(
        label: items[i].label,
        icon: items[i].icon,
        color: items[i].color,
      ),
    );
  }
}

class _CompactCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _CompactCard({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20.sp, color: color),
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
                  color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─────────────────────────── Order card ───────────────────────────

class _OrderCard extends StatelessWidget {
  final Color headerColor;
  final String status;
  final IconData headerIcon;
  final String service;

  const _OrderCard({
    required this.headerColor,
    required this.status,
    required this.headerIcon,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: headerColor, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: headerColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status,
                    style: AppText.bodyMedium.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w700)),
                Icon(headerIcon, size: 22.sp, color: AppColors.textOnDark),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.r),
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
                          Text(service,
                              style: AppText.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 4.h),
                          Text(
                              'home.depart_at'
                                  .tr(namedArgs: {'time': '16:00, 15 aprel'}),
                              style: AppText.subtitle.copyWith(
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(Icons.chevron_right,
                          size: 24.sp, color: AppColors.textPrimary),
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
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          _row(Icons.location_on, from),
          Padding(
            padding: EdgeInsets.only(left: 9.w),
            child: SizedBox(
              height: 16.h,
              child: VerticalDivider(
                  width: 1, thickness: 1, color: AppColors.border),
            ),
          ),
          _row(Icons.flag, to),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.blue),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(text,
              style: AppText.bodyMedium.copyWith(color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
