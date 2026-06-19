import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../domain/order_status.dart';

const _icons = 'assets/icons';

/// Presents the order detail as a bottom sheet that slides up from the bottom
/// (matches the Figma modal presentation — scrim on top, rounded sheet below).
Future<void> showOrderDetailSheet(BuildContext context, OrderStatus status) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => _OrderDetailSheet(status: status),
  );
}

/// Configurable order-detail screen (Figma board 2210:27324, node 2193:6194).
/// The [status] drives the header color/label/icon, the title/subtitle, the
/// action circles and the bottom buttons via [OrderStatusX].
@RoutePage()
class OrderDetailPage extends StatelessWidget {
  final OrderStatus status;

  const OrderDetailPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: status.color,
      body: SafeArea(
        child: Column(
          children: [
            _OrderHeaderBar(status: status),
            Expanded(child: _OrderContent(status: status)),
          ],
        ),
      ),
    );
  }
}

class _OrderDetailSheet extends StatelessWidget {
  final OrderStatus status;
  const _OrderDetailSheet({required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.94,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        child: Container(
          color: status.color,
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 112.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(60.r),
                ),
              ),
              _OrderHeaderBar(status: status),
              Expanded(child: _OrderContent(status: status)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderHeaderBar extends StatelessWidget {
  final OrderStatus status;
  const _OrderHeaderBar({required this.status});

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
          Icon(status.headerIcon, size: 24.sp, color: AppColors.textOnDark),
        ],
      ),
    );
  }
}

class _OrderContent extends StatelessWidget {
  final OrderStatus status;
  const _OrderContent({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            _StatusBlock(status: status),
            SizedBox(height: 8.h),
            _DetailsBlock(status: status),
          ],
        ),
      ),
    );
  }
}

class _StatusBlock extends StatelessWidget {
  final OrderStatus status;
  const _StatusBlock({required this.status});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          Column(
            children: [
              Text(
                status.titleKey.tr(),
                textAlign: TextAlign.center,
                style: AppText.subtitle.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                status.subKey.tr(),
                textAlign: TextAlign.center,
                style: AppText.subtitle.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const _Line(),
          SizedBox(height: 16.h),
          // Driver row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 24.sp,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const _Line(),
          SizedBox(height: 16.h),
          // Price bar
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order.price'.tr(),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Action circles
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

class _ActionCircle extends StatelessWidget {
  final OrderAction action;
  const _ActionCircle({required this.action});

  String get _asset => switch (action) {
    OrderAction.cancel => 'od_close',
    OrderAction.location => 'od_gps',
    OrderAction.call => 'od_call',
    OrderAction.telegram => 'telegram',
  };

  Color? get _tint => switch (action) {
    OrderAction.call => AppColors.creditGreen,
    OrderAction.telegram => AppColors.blue,
    _ => null,
  };

  String get _labelKey => switch (action) {
    OrderAction.cancel => 'order.act_cancel',
    OrderAction.location => 'order.act_location',
    OrderAction.call => 'order.act_call',
    OrderAction.telegram => 'order.act_telegram',
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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

class _DetailsBlock extends StatelessWidget {
  final OrderStatus status;
  const _DetailsBlock({required this.status});

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
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
                      Icon(
                        Icons.chevron_right,
                        size: 20.sp,
                        color: AppColors.textDark,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'order.order_number'.tr(),
                    style: AppText.label.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  'assets/images/order_thumb.png',
                  width: 44.w,
                  height: 55.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const _Line(),
          SizedBox(height: 12.h),
          _InfoRow(
            label: 'order.send_time'.tr(),
            value: '16:00 - 20:00, 15 mart',
          ),
          SizedBox(height: 12.h),
          _InfoRow(label: 'order.from'.tr(), value: 'Toshkent shahri'),
          SizedBox(height: 12.h),
          _InfoRow(label: 'order.to'.tr(), value: 'Sirdaryo tumani, Guliston'),
          if (_buttons.isNotEmpty) ...[
            SizedBox(height: 12.h),
            const _Line(),
            SizedBox(height: 12.h),
            Row(
              children: [
                for (var i = 0; i < _buttons.length; i++) ...[
                  if (i > 0) SizedBox(width: 12.w),
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
        label: 'order.act_cancel'.tr(),
        textColor: AppColors.logoutRed,
        borderColor: AppColors.logoutRed,
      ),
    if (status.showComplain)
      _BottomButton(
        label: 'order.complain'.tr(),
        textColor: AppColors.textDark,
        fillColor: AppColors.fieldFill,
      ),
    if (status.showRate)
      _BottomButton(
        label: 'order.rate'.tr(),
        textColor: AppColors.blue,
        borderColor: AppColors.blue,
        icon: Icons.thumb_up_alt_outlined,
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
  final IconData? icon;

  const _BottomButton({
    required this.label,
    required this.textColor,
    this.fillColor,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
            if (icon != null) ...[
              Icon(icon, size: 18.sp, color: textColor),
              SizedBox(width: 6.w),
            ],
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
          ],
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
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
