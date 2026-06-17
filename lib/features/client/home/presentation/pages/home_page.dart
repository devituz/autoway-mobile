import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../widgets/home_app_bar.dart';

/// Main client screen body (Bosh sahifa tab) hosted inside [MainShellPage].
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HomeAppBar(
              onLeadingTap: () {},
              onBellTap: () => context.router.push(const NotificationsRoute()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _RoleToggle(),
                    SizedBox(height: 18.h),
                    Center(
                      child: Text(
                        'home.greeting'.tr(namedArgs: {'name': 'Jamshid'}),
                        style: AppText.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const Center(child: _WalletCard(balance: '50 000')),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text('home.choose_service'.tr(),
                          style: AppText.screenTitle
                              .copyWith(color: AppColors.textPrimary)),
                    ),
                    SizedBox(height: 16.h),
                    const _ServiceGrid(),
                    SizedBox(height: 24.h),
                    Text('home.active_orders'.tr(),
                        style: AppText.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700)),
                    SizedBox(height: 12.h),
                    _OrderCard(
                      title: 'home.region_taxi'.tr(),
                      status: 'home.status_pending'.tr(),
                      timeLabel: 'home.departure_time'.tr(),
                    ),
                    SizedBox(height: 16.h),
                    _OrderCard(
                      title: 'home.parcel'.tr(),
                      status: 'home.status_active'.tr(),
                      timeLabel: 'home.send_time'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleToggle extends StatefulWidget {
  const _RoleToggle();

  @override
  State<_RoleToggle> createState() => _RoleToggleState();
}

class _RoleToggleState extends State<_RoleToggle> {
  int _index = 0;

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
          _seg('home.client'.tr(), 0),
          _seg('home.driver'.tr(), 1),
        ],
      ),
    );
  }

  Widget _seg(String label, int i) {
    final selected = _index == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _index = i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(label,
              style: AppText.button.copyWith(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String balance;
  const _WalletCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.account_balance_wallet,
              size: 20.sp, color: AppColors.textPrimary),
          SizedBox(width: 8.w),
          Text(balance,
              style: AppText.bodyMedium.copyWith(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
          SizedBox(width: 10.w),
          Text('home.top_up'.tr(),
              style: AppText.subtitle.copyWith(
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline)),
        ],
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'home.intercity_taxi'.tr(), enabled: true),
      (label: 'home.post'.tr(), enabled: true),
      (label: 'home.companion_taxi'.tr(), enabled: true),
      (label: 'AutoWay', enabled: false),
      (label: 'AutoWay', enabled: false),
      (label: 'AutoWay', enabled: false),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.7,
      ),
      itemBuilder: (_, i) =>
          _ServiceCard(label: items[i].label, enabled: items[i].enabled),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String label;
  final bool enabled;

  const _ServiceCard({required this.label, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtitle.copyWith(
                        color: enabled
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                if (enabled)
                  Icon(Icons.chevron_right,
                      size: 20.sp, color: AppColors.textPrimary)
                else
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text('home.coming_soon'.tr(),
                        style: AppText.label
                            .copyWith(color: AppColors.textSecondary)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String title;
  final String status;
  final String timeLabel;

  const _OrderCard({
    required this.title,
    required this.status,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: AppText.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(status,
                    style: AppText.label.copyWith(color: AppColors.textOnDark)),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const _RouteBlock(
            from: 'Toshkent shahri',
            to: 'Sirdaryo tumani, Guliston',
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(timeLabel,
                  style: AppText.subtitle
                      .copyWith(color: AppColors.textSecondary)),
              Text('16:00 | 15 mart',
                  style: AppText.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(height: 1, color: AppColors.border),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('home.price'.tr(),
                      style: AppText.subtitle
                          .copyWith(color: AppColors.textSecondary)),
                  SizedBox(height: 2.h),
                  Text('400 000 som',
                      style: AppText.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.chevron_right,
                    size: 22.sp, color: AppColors.textPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteBlock extends StatelessWidget {
  final String from;
  final String to;

  const _RouteBlock({required this.from, required this.to});

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
          _row(Icons.circle, from, filled: true),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: SizedBox(
              height: 18.h,
              child: VerticalDivider(width: 1, color: AppColors.border),
            ),
          ),
          _row(Icons.arrow_downward, to, filled: false),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text, {required bool filled}) {
    return Row(
      children: [
        Icon(icon, size: filled ? 12.sp : 16.sp, color: AppColors.textPrimary),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(text,
              style:
                  AppText.bodyMedium.copyWith(color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}

