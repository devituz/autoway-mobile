import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Cargo "Haydovchidan taklif" screen (Figma node 2189:24136) — the offer a
/// client receives FROM a driver, presented as a slide-up sheet over a dark
/// scrim. Mirrors the awaiting-status layout but with a strikethrough price box
/// and accept/cancel action circles (no bottom "Etiroz" button).
@RoutePage()
class CargoDriverOfferPage extends StatelessWidget {
  const CargoDriverOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 20.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // Figma Warning/50 #F59E0B.
                color: AppColors.orange,
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
                  // Coloured status header: label + clock + time.
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'cargo.cstatus_awaiting_label'.tr(),
                          style: AppText.subtitle.copyWith(
                            fontSize: 15.sp,
                            color: AppColors.textOnDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              '$_icons/id_ts_clock.svg',
                              width: 24.r,
                              height: 24.r,
                              colorFilter: const ColorFilter.mode(
                                  AppColors.textOnDark, BlendMode.srcIn),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '09:26',
                              style: AppText.subtitle.copyWith(
                                fontSize: 15.sp,
                                color: AppColors.textOnDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: _ContentBar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentBar extends StatelessWidget {
  const _ContentBar();

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
            const _OfferCard(),
            SizedBox(height: 8.h),
            const _DetailsCard(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard();

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
            'cargo.coffer_title'.tr(),
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
            'cargo.coffer_sub'.tr(),
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
          const _OfferPriceBox(),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _ActionCircle(
                  asset: 'od_close',
                  labelKey: 'cargo.coffer_act_cancel',
                  onTap: () => context.router.maybePop(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: _ActionCircle(
                  asset: 'ia_add',
                  labelKey: 'cargo.coffer_act_accept',
                  onTap: () {}, // TODO(nav)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Grey "Narxi:" box with strikethrough old price + current price.
class _OfferPriceBox extends StatelessWidget {
  const _OfferPriceBox();

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'cargo.cstatus_price'.tr(),
            style: AppText.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.textDark,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '100 000',
                style: AppText.subtitle.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.logoutRed,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '150 000 ',
                      style: AppText.subtitle.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'сум',
                      style: AppText.subtitle.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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

class _ActionCircle extends StatelessWidget {
  final String asset;
  final String labelKey;
  final VoidCallback onTap;
  const _ActionCircle({
    required this.asset,
    required this.labelKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              '$_icons/$asset.svg',
              width: 24.r,
              height: 24.r,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            labelKey.tr(),
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

class _DetailsCard extends StatelessWidget {
  const _DetailsCard();

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

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.border);
  }
}
