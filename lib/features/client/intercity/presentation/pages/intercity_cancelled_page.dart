import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Intercity-taxi flow — order-cancelled / not-accepted status screen
/// (Figma node 2183:10489). A red wrapper sheet pinned to the bottom over the
/// dark map backdrop: a red "Qabul qilinmadi" status bar, then a light content
/// area with two stacked white cards — the first explaining the order was not
/// confirmed (with cancel / re-search actions), the second the order summary.
/// Shown as a real modal bottom sheet over the previous screen.
Future<void> showIntercityCancelledSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99282828),
    builder: (_) => const _CancelledSheetBody(),
  );
}

class _CancelledSheetBody extends StatelessWidget {
  const _CancelledSheetBody();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
              heightFactor: 0.93,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.logoutRed,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x147D8184),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Status bar text.
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        child: Center(
                          child: Text('intercity.cancelled_not_accepted'.tr(),
                              style: AppText.subtitle.copyWith(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnDark)),
                        ),
                      ),
                      // Light content area.
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.r)),
                          ),
                          child: Column(
                            children: [
                              const _StatusCard(),
                              SizedBox(height: 8.h),
                              const Expanded(child: _OrderSummaryCard()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

/// Top white card: "not confirmed" message + cancel / re-search action buttons.
class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                Text('intercity.cancelled_title'.tr(),
                    textAlign: TextAlign.center,
                    style: AppText.subtitle.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 26 / 18,
                        color: AppColors.textDark)),
                SizedBox(height: 4.h),
                Text('intercity.cancelled_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp, color: AppColors.primary)),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: AppColors.border),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon: 'od_close',
                label: 'intercity.cancelled_cancel'.tr(),
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(width: 24.w),
              _ActionButton(
                icon: 'refresh',
                label: 'intercity.cancelled_research'.tr(),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(52.r),
            ),
            child: SvgPicture.asset('$_icons/$icon.svg',
                width: 24.r, height: 24.r),
          ),
          SizedBox(height: 4.h),
          Text(label,
              style: AppText.label.copyWith(
                  fontSize: 12.sp, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

/// Bottom white card: order number, seat count, price, time, route.
class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: order number + seats.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('#168-98',
                          style: GoogleFonts.unbounded(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              height: 26 / 16,
                              color: AppColors.textDark)),
                      SizedBox(width: 4.w),
                      SvgPicture.asset('$_icons/arrow_right.svg',
                          width: 20.r,
                          height: 20.r,
                          colorFilter: const ColorFilter.mode(
                              AppColors.textDark, BlendMode.srcIn)),
                    ],
                  ),
                  Text('intercity.cancelled_order_number'.tr(),
                      style: AppText.label.copyWith(
                          fontSize: 12.sp, color: AppColors.textMuted)),
                ],
              ),
              const _SeatGrid(),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: AppColors.border),
          SizedBox(height: 12.h),
          // Price + time tiles.
          IntrinsicHeight(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MetaTile(
                  label: 'intercity.cancelled_price'.tr(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('400 000',
                          style: GoogleFonts.unbounded(
                              fontSize: 12.sp,
                              height: 16 / 12,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough)),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '350 000 ',
                                style: GoogleFonts.unbounded(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 26 / 16,
                                    color: AppColors.textDark)),
                            TextSpan(
                                text: 'so‘m',
                                style: GoogleFonts.unbounded(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 26 / 16,
                                    color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MetaTile(
                  label: 'intercity.cancelled_time'.tr(),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: '16:00',
                            style: GoogleFonts.unbounded(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                height: 26 / 16,
                                color: AppColors.textDark)),
                        TextSpan(
                            text: ', 15 aprel',
                            style: GoogleFonts.unbounded(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                height: 26 / 16,
                                color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: AppColors.border),
          SizedBox(height: 12.h),
          // Route rows.
          _RouteRow(
            label: 'intercity.cancelled_from'.tr(),
            value: 'Toshkent shahri',
          ),
          SizedBox(height: 8.h),
          _RouteRow(
            label: 'intercity.cancelled_to'.tr(),
            value: 'Sirdaryo tumani, Guliston',
          ),
        ],
      ),
    );
  }
}

/// The 1-active + 3-inactive seat indicator in the card header.
class _SeatGrid extends StatelessWidget {
  const _SeatGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _seat(AppColors.ctaBlue),
        SizedBox(height: 2.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _seat(const Color(0xFFCBD5E1)),
            SizedBox(width: 2.w),
            _seat(const Color(0xFFCBD5E1)),
            SizedBox(width: 2.w),
            _seat(const Color(0xFFCBD5E1)),
          ],
        ),
      ],
    );
  }

  Widget _seat(Color color) => Container(
        width: 24.r,
        height: 24.r,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6.r),
        ),
      );
}

class _MetaTile extends StatelessWidget {
  final String label;
  final Widget child;
  const _MetaTile({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp,
                  height: 20 / 14,
                  color: AppColors.textDark)),
          child,
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  final String label;
  final String value;
  const _RouteRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14.sp, height: 20 / 14, color: AppColors.textDark)),
        Text(value,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 14,
                color: AppColors.textDark)),
      ],
    );
  }
}
