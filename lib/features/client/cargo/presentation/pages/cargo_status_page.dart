import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../domain/entities/cargo_status.dart';

const _icons = 'assets/icons';

/// Configurable cargo (Pochta / Yuk yetkazma) status screen — six states of the
/// same screen driven by [CargoStatus] (Figma nodes 2187:22022, 2187:20751,
/// 2189:23087, 2189:23381, 2189:23708, 2189:23844).
///
/// Layout: a dark full-screen background, then a bottom-anchored wrapper whose
/// top strip is the status-coloured header bar; below it a light-grey content
/// area holds the white status card (title/driver/price/actions) and the white
/// order-detail card (number/thumbnail/route/buttons). Per-state differences
/// live in [CargoStatusX].
@RoutePage()
class CargoStatusPage extends StatelessWidget {
  final CargoStatus status;

  const CargoStatusPage({super.key, required this.status});

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
/// icon + time for the awaiting state, nothing for [CargoStatus.found]).
class _StatusHeaderBar extends StatelessWidget {
  final CargoStatus status;
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
          if (status.headerTrailing == CargoHeaderTrailing.time)
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
          else if (status.headerTrailing == CargoHeaderTrailing.icon)
            _headerIcon(status),
        ],
      ),
    );
  }

  Widget _headerIcon(CargoStatus status) => SvgPicture.asset(
        '$_icons/${status.headerIcon}.svg',
        width: 24.r,
        height: 24.r,
        colorFilter:
            const ColorFilter.mode(AppColors.textOnDark, BlendMode.srcIn),
      );
}

/// Light-grey rounded content area holding the two white cards.
class _ContentBar extends StatelessWidget {
  final CargoStatus status;
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

/// Top white card: title/subtitle, driver row, price box, action circles.
class _StatusCard extends StatelessWidget {
  final CargoStatus status;
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
          SizedBox(height: 12.h),
          const _PriceBox(),
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
          onTap: () {}, // TODO(nav)
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

/// Grey "Narxi:" price row inside the status card.
class _PriceBox extends StatelessWidget {
  const _PriceBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'cargo.cstatus_price'.tr(),
            style: AppText.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.textDark,
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '100 000 ',
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
                    fontWeight: FontWeight.w500,
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

class _ActionCircle extends StatelessWidget {
  final CargoAction action;
  const _ActionCircle({required this.action});

  String get _asset => switch (action) {
        CargoAction.cancel => 'od_close',
        CargoAction.location => 'od_gps',
        CargoAction.telegram => 'telegram',
        CargoAction.call => 'od_call',
      };

  Color? get _tint => switch (action) {
        CargoAction.telegram => AppColors.blue,
        CargoAction.call => AppColors.creditGreen,
        _ => null,
      };

  String get _labelKey => switch (action) {
        CargoAction.cancel => 'cargo.cstatus_act_cancel',
        CargoAction.location => 'cargo.cstatus_act_location',
        CargoAction.telegram => 'cargo.cstatus_act_telegram',
        CargoAction.call => 'cargo.cstatus_act_call',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO(nav)
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

/// Bottom white card: order number + thumbnail, route rows, bottom buttons.
class _DetailsCard extends StatelessWidget {
  final CargoStatus status;
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
                    'cargo.cstatus_order_number'.tr(),
                    style: AppText.label.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              Container(
                width: 55.w,
                height: 44.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.accent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x14000000),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    'assets/images/order_thumb.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const _Line(),
          SizedBox(height: 12.h),
          _InfoRow(
            label: 'cargo.cstatus_send_time'.tr(),
            value: '16:00 - 20:00, 15 mart',
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            label: 'cargo.cstatus_from'.tr(),
            value: 'Toshkent shahri',
          ),
          SizedBox(height: 8.h),
          _InfoRow(
            label: 'cargo.cstatus_to'.tr(),
            value: 'Sirdaryo tumani, Guliston',
          ),
          SizedBox(height: 12.h),
          const _Line(),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _buttons.length; i++) ...[
                if (i > 0) SizedBox(width: 16.w),
                _buttons[i],
              ],
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> get _buttons => [
        if (status.showComplain)
          _BottomButton(
            label: 'cargo.cstatus_btn_complain'.tr(),
            textColor: AppColors.textDark,
            fillColor: AppColors.fieldFill,
          ),
        if (status.showRate)
          _BottomButton(
            label: 'cargo.cstatus_btn_rate'.tr(),
            textColor: AppColors.selectBlue,
            borderColor: AppColors.selectBlue,
            trailingLike: true,
          ),
      ];
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
  final bool trailingLike;

  const _BottomButton({
    required this.label,
    required this.textColor,
    this.fillColor,
    this.borderColor,
    this.trailingLike = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { if (trailingLike) context.router.push(const CargoRateDriverRoute()); },
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
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
            Text(
              label,
              style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
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
