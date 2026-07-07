import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';

const _icons = 'assets/icons';

/// Driver "Buyurtmalar" order-intake settings (Figma 2226:29983 "Siz
/// liniyadasiz"). White top bar with back / title / info and a full-width red
/// "Siz liniyadasiz" pill; below on a grey background the (disabled-looking)
/// Servis / Energy cards and a 50%-opacity settings card: route pickers with
/// a swap button, departure time row, dashed divider and four toggle rows.
@RoutePage()
class DriverOrdersSettingsPage extends StatefulWidget {
  const DriverOrdersSettingsPage({super.key});

  @override
  State<DriverOrdersSettingsPage> createState() =>
      _DriverOrdersSettingsPageState();
}

class _DriverOrdersSettingsPageState extends State<DriverOrdersSettingsPage> {
  String _from = 'Toshkent shahri';
  String _to = 'Andijon shahri, Andijon viloyati';

  bool _pickupClient = false;
  bool _pickupParcel = false;
  bool _clientPriceOffer = false;
  bool _autoAccept = false;

  void _swap() => setState(() {
        final t = _from;
        _from = _to;
        _to = t;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          const _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 36.h, 16.w, 24.h),
              child: Column(
                children: [
                  const _DisabledServicesRow(),
                  SizedBox(height: 12.h),
                  // Whole settings card is 50% transparent in the design —
                  // the "disabled while on line" look.
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          _RoutePickerBox(
                            from: _from,
                            to: _to,
                            onSwap: _swap,
                          ),
                          SizedBox(height: 16.h),
                          const _DepartureTimeRow(),
                          SizedBox(height: 16.h),
                          const _DashedLine(color: AppColors.lightGrey),
                          _ToggleRow(
                            label: 'line.pickup_client'.tr(),
                            value: _pickupClient,
                            onChanged: (v) =>
                                setState(() => _pickupClient = v),
                          ),
                          _ToggleRow(
                            label: 'line.pickup_parcel'.tr(),
                            value: _pickupParcel,
                            onChanged: (v) =>
                                setState(() => _pickupParcel = v),
                          ),
                          _ToggleRow(
                            label: 'line.client_price_offer'.tr(),
                            value: _clientPriceOffer,
                            onChanged: (v) =>
                                setState(() => _clientPriceOffer = v),
                          ),
                          _ToggleRow(
                            label: 'line.auto_accept'.tr(),
                            value: _autoAccept,
                            onChanged: (v) => setState(() => _autoAccept = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Top bar ───────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: Column(
            children: [
              SizedBox(
                height: 32.h,
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => context.router.maybePop(),
                      child: SvgPicture.asset(
                        '$_icons/mt_back.svg',
                        width: 32.r,
                        height: 32.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textDark,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'home.nav_orders'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 27 / 18,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Container(
                      width: 32.r,
                      height: 32.r,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.cardLight,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        '$_icons/info_circle.svg',
                        width: 24.r,
                        height: 24.r,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray30,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              const _OnlinePill(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-width "Siz liniyadasiz ⚡" pill (Figma 2226:30385): 2px #FB7185 ring
/// around a #E11D48 body, r24, Poppins 500/15 white text + white flash.
class _OnlinePill extends StatelessWidget {
  const _OnlinePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 32.h,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: AppColors.rose40,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.logoutRed,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'home.driver_you_online'.tr(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 15,
                color: AppColors.textOnDark,
              ),
            ),
            SizedBox(width: 6.w),
            SvgPicture.asset(
              '$_icons/c_flash.svg',
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                AppColors.textOnDark,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────── Disabled Servis / Energy cards ───────────────────

class _DisabledServicesRow extends StatelessWidget {
  const _DisabledServicesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DisabledServiceCard(
            icon: 'dr_cpu',
            label: 'home.driver_servis'.tr(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _DisabledServiceCard(
            icon: 'c_flash',
            label: 'home.energy'.tr(),
          ),
        ),
      ],
    );
  }
}

/// Greyed-out variant of the home "Hizmatlar" card (Figma 2226:30398):
/// icon #CBD5E1, label #E2E8F0 — visibly inactive while on line.
class _DisabledServiceCard extends StatelessWidget {
  final String icon;
  final String label;
  const _DisabledServiceCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.cardLight,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  '$_icons/$icon.svg',
                  width: 24.r,
                  height: 24.r,
                  colorFilter: const ColorFilter.mode(
                    AppColors.gray30,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20.sp,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 16 / 14,
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Route picker box ───────────────────────

class _RoutePickerBox extends StatelessWidget {
  final String from;
  final String to;
  final VoidCallback onSwap;
  const _RoutePickerBox(
      {required this.from, required this.to, required this.onSwap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28.r,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 28.r,
                        height: 28.r,
                        child: Center(
                          child: SvgPicture.asset(
                            '$_icons/mt_location.svg',
                            width: 20.r,
                            height: 20.r,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textMuted,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: _DashedVerticalLine(color: AppColors.textDark),
                      ),
                      SizedBox(
                        width: 28.r,
                        height: 28.r,
                        child: Center(
                          child: SvgPicture.asset(
                            '$_icons/mt_flag.svg',
                            width: 20.r,
                            height: 20.r,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textMuted,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AddressRow(text: from),
                      const Divider(height: 1, color: AppColors.border),
                      _AddressRow(text: to),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Swap direction button — centered over the separator.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSwap,
            child: Container(
              width: 36.r,
              height: 36.r,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.textDark,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                '$_icons/refresh.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: const ColorFilter.mode(
                  AppColors.textOnDark,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final String text;
  const _AddressRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37.h,
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 22 / 16,
                color: AppColors.textDark,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          const _SelectChip(),
        ],
      ),
    );
  }
}

/// "Tanlash >" chip (Figma 2226:30445): 84x32 white, r16.
class _SelectChip extends StatelessWidget {
  const _SelectChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.fromLTRB(12.w, 0, 8.w, 0),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'intercity.select'.tr(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1,
              color: AppColors.textDark,
            ),
          ),
          SvgPicture.asset(
            '$_icons/ia_chevron_right.svg',
            width: 16.r,
            height: 16.r,
            colorFilter: const ColorFilter.mode(
              AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────── Departure time row ───────────────────────

class _DepartureTimeRow extends StatelessWidget {
  const _DepartureTimeRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            '$_icons/ia_calendar_tick.svg',
            width: 24.r,
            height: 24.r,
            colorFilter: const ColorFilter.mode(
              AppColors.textDark,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'intercity.addr_departure'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: 22 / 16,
                color: AppColors.textDark,
              ),
            ),
          ),
          SvgPicture.asset(
            '$_icons/arrow_right.svg',
            width: 20.r,
            height: 20.r,
            colorFilter: const ColorFilter.mode(
              AppColors.textDark,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Toggle rows ───────────────────────────

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.fieldFill),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: 24 / 16,
                color: AppColors.textDark,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          _Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// 40x24 iOS-style switch (Figma "Setting On Off": track #DBDFE0 when off).
class _Switch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Switch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40.r,
        height: 24.r,
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          color: value ? AppColors.ctaBlue : AppColors.switchOff,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20.r,
            height: 20.r,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Shared bits ───────────────────────────

class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

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
            (_) => Container(width: dashW, height: 1, color: color),
          ),
        );
      },
    );
  }
}

/// Vertical dashed connector between route points (Figma: 4/4 dash, #0F172A).
/// CustomPaint (not LayoutBuilder) so it is safe inside IntrinsicHeight —
/// LayoutBuilder cannot report intrinsic dimensions and crashes layout there.
class _DashedVerticalLine extends StatelessWidget {
  final Color color;
  const _DashedVerticalLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(1, double.infinity),
      painter: _DashedVerticalLinePainter(color),
    );
  }
}

class _DashedVerticalLinePainter extends CustomPainter {
  final Color color;
  _DashedVerticalLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const dashH = 4.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    final x = size.width / 2;
    double y = 0;
    while (y < size.height) {
      final end = (y + dashH) > size.height ? size.height : y + dashH;
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedVerticalLinePainter old) =>
      old.color != color;
}
