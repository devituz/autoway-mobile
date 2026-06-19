import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../domain/intercity_trip_status.dart';

const _icons = 'assets/icons';

/// Configurable intercity (Viloyat taxi) trip-status screen — five states of the
/// same screen driven by [IntercityTripStatus] (Figma nodes 2174:14190,
/// 2177:14784, 2183:10043, 2183:10174, 2183:10297).
///
/// Layout: a dark full-screen background, then a bottom-anchored wrapper whose
/// top strip is the status-coloured header bar; below it a light-grey content
/// area holds the white status card (title/driver/actions) and the white
/// order-detail card (number/price/route/buttons). Per-state differences live
/// in [IntercityTripStatusX].
@RoutePage()
class IntercityTripStatusPage extends StatelessWidget {
  final IntercityTripStatus status;

  const IntercityTripStatusPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          // Status-bar spacer (dark area at the top).
          SizedBox(height: MediaQuery.of(context).padding.top + 20.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: status.color,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x147D8184),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _StatusHeaderBar(status: status),
                  Expanded(child: _ContentBar(status: status)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Coloured "Recomendation_Bar": the status label + a trailing icon (or
/// icon + time for the time-tracked states).
class _StatusHeaderBar extends StatelessWidget {
  final IntercityTripStatus status;
  const _StatusHeaderBar({required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            status.labelKey.tr(),
            style: AppText.subtitle.copyWith(
              fontSize: 15.sp,
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (status.headerTrailing == TripHeaderTrailing.time)
            Row(
              children: [
                _headerIcon(status),
                SizedBox(width: 8.w),
                Text(
                  status.headerTime,
                  style: AppText.subtitle.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          else
            _headerIcon(status),
        ],
      ),
    );
  }

  Widget _headerIcon(IntercityTripStatus status) => SvgPicture.asset(
        '$_icons/${status.headerIcon}.svg',
        width: 24.r,
        height: 24.r,
        colorFilter:
            const ColorFilter.mode(AppColors.textOnDark, BlendMode.srcIn),
      );
}

/// Light-grey rounded content area holding the two white cards.
class _ContentBar extends StatelessWidget {
  final IntercityTripStatus status;
  const _ContentBar({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _StatusCard(status: status),
            SizedBox(height: 8.h),
            _DetailsCard(status: status),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

/// Top white card: title/subtitle, driver row, action circles.
class _StatusCard extends StatelessWidget {
  final IntercityTripStatus status;
  const _StatusCard({required this.status});

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
          Text(
            status.titleKey.tr(),
            textAlign: TextAlign.center,
            style: AppText.subtitle.copyWith(
              fontSize: 18.sp,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              height: 26 / 18,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            status.subKey.tr(),
            textAlign: TextAlign.center,
            style: AppText.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
              height: 16 / 14,
            ),
          ),
          SizedBox(height: 12.h),
          const _Line(),
          SizedBox(height: 12.h),
          const _DriverRow(),
          SizedBox(height: 12.h),
          const _Line(),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final action in status.actions)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: _ActionCircle(action: action),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/driver_avatar.png',
                  width: 48.r,
                  height: 48.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akbar Yoldoshev',
                      style: AppText.subtitle.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          '01 B 125 YC',
                          style: AppText.subtitle.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 12.h,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          color: AppColors.border,
                        ),
                        Flexible(
                          child: Text(
                            'Cobalt LTZ Oq',
                            overflow: TextOverflow.ellipsis,
                            style: AppText.subtitle.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 52.h,
            height: 52.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.fieldFill),
            ),
            child: SvgPicture.asset(
              '$_icons/ia_arrow_right.svg',
              width: 20.r,
              height: 20.r,
              colorFilter:
                  const ColorFilter.mode(AppColors.textDark, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionCircle extends StatelessWidget {
  final TripAction action;
  const _ActionCircle({required this.action});

  String get _asset => switch (action) {
        TripAction.cancel => 'od_close',
        TripAction.location => 'od_gps',
        TripAction.telegram => 'telegram',
        TripAction.call => 'od_call',
      };

  Color? get _tint => switch (action) {
        TripAction.telegram => AppColors.blue,
        TripAction.call => AppColors.creditGreen,
        _ => null,
      };

  String get _labelKey => switch (action) {
        TripAction.cancel => 'intercity.tstatus_act_cancel',
        TripAction.location => 'intercity.tstatus_act_location',
        TripAction.telegram => 'intercity.tstatus_act_telegram',
        TripAction.call => 'intercity.tstatus_act_call',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => switch (action) {
        TripAction.location =>
          context.router.push(const IntercityDriverLocationRoute()),
        TripAction.cancel =>
          context.router.push(const IntercityCancelOrderRoute()),
        _ => null,
      },
      child: Column(
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.fieldFill,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              '$_icons/$_asset.svg',
              width: 24.r,
              height: 24.r,
              colorFilter: _tint == null
                  ? null
                  : ColorFilter.mode(_tint!, BlendMode.srcIn),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _labelKey.tr(),
            style: AppText.label.copyWith(
              fontSize: 12.sp,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom white card: order number + seat indicator, price/time, route rows,
/// bottom buttons.
class _DetailsCard extends StatelessWidget {
  final IntercityTripStatus status;
  const _DetailsCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#168-98',
                        style: AppText.subtitle.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      SvgPicture.asset(
                        '$_icons/ia_arrow_right.svg',
                        width: 20.r,
                        height: 20.r,
                        colorFilter: const ColorFilter.mode(
                            AppColors.textDark, BlendMode.srcIn),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'intercity.tstatus_order_number'.tr(),
                    style: AppText.label.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const _SeatIndicator(),
            ],
          ),
          SizedBox(height: 12.h),
          const _Line(),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _MiniCard(
                  label: 'intercity.tstatus_price'.tr(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (status.showOldPrice)
                        Text(
                          '400 000',
                          style: AppText.subtitle.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '350 000 ',
                              style: AppText.subtitle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'so‘m',
                              style: AppText.subtitle.copyWith(
                                fontSize: 16.sp,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MiniCard(
                  label: 'intercity.tstatus_time'.tr(),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '16:00',
                          style: AppText.subtitle.copyWith(
                            fontSize: 16.sp,
                            color: status.mutedTime
                                ? AppColors.textMuted
                                : AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ', 15 aprel',
                          style: AppText.subtitle.copyWith(
                            fontSize: 16.sp,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const _Line(),
          SizedBox(height: 12.h),
          _InfoRow(
            label: 'intercity.tstatus_from'.tr(),
            value: 'Toshkent shahri',
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            label: 'intercity.tstatus_to'.tr(),
            value: 'Sirdaryo tumani, Guliston',
          ),
          if (status.showStartTime) ...[
            SizedBox(height: 8.h),
            _InfoRow(
              label: 'intercity.tstatus_start_time'.tr(),
              value: '15:36, 5 aprel',
            ),
          ],
          if (status.showFinishTime) ...[
            SizedBox(height: 8.h),
            _InfoRow(
              label: 'intercity.tstatus_finish_time'.tr(),
              value: '17:50, 5 aprel',
            ),
          ],
          if (_buttons.isNotEmpty) ...[
            SizedBox(height: 12.h),
            const _Line(),
            SizedBox(height: 12.h),
            Row(
              children: [
                for (var i = 0; i < _buttons.length; i++) ...[
                  if (i > 0) SizedBox(width: 16.w),
                  Expanded(child: _buttons[i]),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> get _buttons => [
        if (status.showCancelButton)
          _BottomButton(
            label: 'intercity.tstatus_btn_cancel'.tr(),
            textColor: AppColors.danger,
            borderColor: AppColors.danger,
            trailingClose: true,
          ),
        if (status.showComplain)
          _BottomButton(
            label: 'intercity.tstatus_btn_complain'.tr(),
            textColor: AppColors.textDark,
            fillColor: AppColors.fieldFill,
          ),
        if (status.showRate)
          _BottomButton(
            label: 'intercity.tstatus_btn_rate'.tr(),
            textColor: AppColors.selectBlue,
            borderColor: AppColors.selectBlue,
            trailingLike: true,
          ),
      ];
}

class _SeatIndicator extends StatelessWidget {
  const _SeatIndicator();

  @override
  Widget build(BuildContext context) {
    Widget seat(Color color) => Container(
          width: 24.r,
          height: 24.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.r),
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        seat(AppColors.ctaBlue),
        SizedBox(height: 2.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            seat(const Color(0xFFCBD5E1)),
            SizedBox(width: 2.w),
            seat(const Color(0xFFCBD5E1)),
            SizedBox(width: 2.w),
            seat(const Color(0xFFCBD5E1)),
          ],
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final Widget child;
  const _MiniCard({required this.label, required this.child});

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
          Text(
            label,
            style: AppText.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.textDark,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.subtitle.copyWith(
            fontSize: 14.sp,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppText.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color? fillColor;
  final Color? borderColor;
  final bool trailingClose;
  final bool trailingLike;

  const _BottomButton({
    required this.label,
    required this.textColor,
    this.fillColor,
    this.borderColor,
    this.trailingClose = false,
    this.trailingLike = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (trailingClose) {
          context.router.push(const IntercityCancelOrderRoute());
        } else if (trailingLike) {
          context.router.push(const IntercityRateDriverRoute());
        }
      },
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor ?? AppColors.accent,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor == null ? null : Border.all(color: borderColor!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppText.subtitle.copyWith(
                  fontSize: 14.sp,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingClose) ...[
              SizedBox(width: 4.w),
              SvgPicture.asset(
                '$_icons/od_close.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
              ),
            ],
            if (trailingLike) ...[
              SizedBox(width: 4.w),
              SvgPicture.asset(
                '$_icons/id_ts_like.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.border);
  }
}
