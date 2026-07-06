import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../widgets/payment_filter_sheet.dart';

const _icons = 'assets/icons';

/// Payment history (To'lovlar tarixi) — Figma node 2066:14805.
/// Reached from the Profile screen's "To'lovlar tarixi" button.
@RoutePage()
class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  static const _pageSize = 6;

  // Mock data — replaced by the API layer later.
  static final List<_Txn> _all = _buildMock();

  int _visible = _pageSize;

  static List<_Txn> _buildMock() {
    final list = <_Txn>[
      const _Txn('Viloyat taxi №106', '20 Mart, 20:38', '-6 000', false, false),
      const _Txn(
          'Bekor qilingan Taxi №102', '20 Mart, 20:38', '+1 500', true, false),
      const _Txn('Viloyat taxi №101', '15 Mart, 16:50', '-3 000', false, false),
      const _Txn('Posilka №99', '31 Fevral, 15:30', '-3 000', false, true),
      const _Txn('Posilka №98', '15 Yanvar, 20:00', '-9 000', false, true),
      const _Txn('Viloyat taxi №75', '3 Yanvar, 12:35', '-3 000', false, false),
    ];
    // Older history revealed via "Yana korish".
    const months = ['Dekabr', 'Noyabr', 'Oktyabr', 'Sentyabr', 'Avgust'];
    for (var i = 0; i < 15; i++) {
      final parcel = i % 3 == 0;
      final n = 74 - i;
      list.add(_Txn(
        parcel ? 'Posilka №$n' : 'Viloyat taxi №$n',
        '${(i % 28) + 1} ${months[i % months.length]}, 1${i % 9}:${i % 6}0',
        parcel ? '-5 000' : '-3 000',
        false,
        parcel,
      ));
    }
    return list;
  }

  void _seeMore() {
    setState(() => _visible = (_visible + _pageSize).clamp(0, _all.length));
  }

  @override
  Widget build(BuildContext context) {
    final items = _all.take(_visible).toList();
    final remaining = _all.length - _visible;
    return Scaffold(
      backgroundColor: AppColors.fieldFill,
      body: Column(
        children: [
          // White header bar with rounded bottom (Figma 2066:14806).
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => context.router.maybePop(),
                        child: SvgPicture.asset('$_icons/arrow_left.svg',
                            width: 24.sp, height: 24.sp),
                      ),
                      Expanded(
                        child: Text('profile.payment_history'.tr(),
                            textAlign: TextAlign.center,
                            style: AppText.subtitle.copyWith(
                                fontSize: 15.sp,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600)),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => showPaymentFilter(context),
                        child: SvgPicture.asset('$_icons/filter.svg',
                            width: 24.sp, height: 24.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text('profile.commission_title'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 18.sp,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 16.h),
                    for (final t in items) _TxnRow(txn: t),
                    if (remaining > 0) ...[
                      SizedBox(height: 16.h),
                      _SeeMoreButton(count: remaining, onTap: _seeMore),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Txn {
  final String title;
  final String date;
  final String amount;
  final bool credit; // green refund
  final bool parcel; // box icon instead of taxi
  const _Txn(this.title, this.date, this.amount, this.credit, this.parcel);
}

class _TxnRow extends StatelessWidget {
  final _Txn txn;
  const _TxnRow({required this.txn});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.fieldFill)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            // Figma exported only the taxi icon; parcel rows use a matching
            // box outline (no separate box asset was provided in the export).
            child: txn.parcel
                ? Icon(Icons.inventory_2_outlined,
                    size: 22.sp, color: AppColors.textMuted)
                : SvgPicture.asset('$_icons/taxi_row.svg',
                    width: 24.sp, height: 24.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(txn.title,
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 6.h),
                Text(txn.date,
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp, color: AppColors.textMuted)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text('${txn.amount} so‘m',
              style: AppText.subtitle.copyWith(
                  fontSize: 14.sp,
                  color: txn.credit ? AppColors.creditGreen : AppColors.textDark,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SeeMoreButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _SeeMoreButton({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text('profile.see_more'.tr(namedArgs: {'n': '$count'}),
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
