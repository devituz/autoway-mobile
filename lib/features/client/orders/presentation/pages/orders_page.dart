import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'order_detail_page.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../domain/entities/order_status.dart';

/// "Buyurtmalar" tab body (Figma node 2190:24557) hosted inside MainShell.
///
/// No `@RoutePage` — the shell owns routing and the bottom nav.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _tab = 0; // 0 = Aktiv, 1 = Arhiv

  static const _active = <OrderStatus>[
    OrderStatus.coming,
    OrderStatus.accepted,
    OrderStatus.pending,
  ];

  static const _archive = <OrderStatus>[
    OrderStatus.delivered,
    OrderStatus.done,
  ];

  @override
  Widget build(BuildContext context) {
    final orders = _tab == 0 ? _active : _archive;
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: Column(
        children: [
          const _OrdersHeader(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: _SegmentedTabs(
              index: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('order.active_orders'.tr(),
                      style: AppText.bodyLarge.copyWith(
                          fontSize: 18.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 12.h),
                  for (final status in orders) ...[
                    _OrderCard(status: status),
                    SizedBox(height: 16.h),
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

// ─────────────────────────── Header ───────────────────────────

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x147D8184),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
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
                SizedBox(width: 24.sp),
                Expanded(
                  child: Text(
                    'home.nav_orders'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                SvgPicture.asset('assets/icons/filter.svg',
                    width: 24.sp, height: 24.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Segmented tabs ───────────────────────────

class _SegmentedTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _SegmentedTabs({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _seg('order.tab_active'.tr(), 0),
          _seg('order.tab_archive'.tr(), 1),
        ],
      ),
    );
  }

  Widget _seg(String label, int i) {
    final selected = index == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(label,
              style: AppText.subtitle.copyWith(
                  color: selected ? AppColors.textDark : AppColors.textMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
        ),
      ),
    );
  }
}

// ─────────────────────────── Order card ───────────────────────────

class _OrderCard extends StatelessWidget {
  final OrderStatus status;

  const _OrderCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final headerColor = status.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showOrderDetailSheet(context, status),
      child: Container(
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
                  Text(status.labelKey.tr(),
                      style: AppText.bodyMedium.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w700)),
                  Icon(status.headerIcon,
                      size: 22.sp, color: AppColors.textOnDark),
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
                            Text(_serviceLabel(status),
                                style: AppText.bodyLarge.copyWith(
                                    fontSize: 18.sp,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 4.h),
                            Text(
                                'home.depart_at'.tr(
                                    namedArgs: {'time': '16:00, 15 aprel'}),
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
      ),
    );
  }

  /// Cargo-flavoured statuses show "Yuk yetkazma", otherwise "Shaharlar aro taxi".
  String _serviceLabel(OrderStatus status) {
    final cargo = status == OrderStatus.delivering ||
        status == OrderStatus.delivered;
    return cargo ? 'home.cargo'.tr() : 'home.intercity_taxi'.tr();
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
