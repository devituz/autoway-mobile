import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import 'intercity_extra_page.dart';
import 'intercity_time_page.dart';

const _icons = 'assets/icons';

/// Intercity-taxi flow — the order-details / configuration screen
/// ("Taksi buyurtma", Figma node 2135:10611). A tall scrollable form with three
/// white cards (route + meta, passengers, extras) over a light backdrop, plus a
/// pinned dark bottom bar showing the system commission and the
/// "Haydovchi qidirish" CTA. Reached after the pickup & drop-off addresses are
/// chosen in the place-picker screens.
@RoutePage()
class IntercityOrderDetailsPage extends StatefulWidget {
  const IntercityOrderDetailsPage({super.key});

  @override
  State<IntercityOrderDetailsPage> createState() =>
      _IntercityOrderDetailsPageState();
}

class _IntercityOrderDetailsPageState extends State<IntercityOrderDetailsPage> {
  bool _fullSalon = false;
  bool _hasLuggage = true;
  int _men = 3;
  int _women = 0;
  int _luggageIndex = 0; // selected luggage-size chip

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border,
      body: Column(
        children: [
          const _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 4.h, 0, 16.h),
              child: Column(
                children: [
                  _OrderInfoCard(),
                  SizedBox(height: 4.h),
                  _PassengersCard(
                    fullSalon: _fullSalon,
                    onFullSalon: (v) => setState(() => _fullSalon = v),
                    men: _men,
                    women: _women,
                    onMen: (d) =>
                        setState(() => _men = (_men + d).clamp(0, 4)),
                    onWomen: (d) =>
                        setState(() => _women = (_women + d).clamp(0, 4)),
                  ),
                  SizedBox(height: 4.h),
                  _ExtrasCard(
                    hasLuggage: _hasLuggage,
                    onLuggage: (v) => setState(() => _hasLuggage = v),
                    luggageIndex: _luggageIndex,
                    onLuggagePick: (i) => setState(() => _luggageIndex = i),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x147D8184),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.maybePop(),
                child: SvgPicture.asset('$_icons/ia_close_circle.svg',
                    width: 32.r, height: 32.r),
              ),
              Expanded(
                child: Text(
                  'intercity.addr_order_title'.tr(),
                  textAlign: TextAlign.center,
                  style: AppText.screenTitle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
                ),
              ),
              SizedBox(width: 32.r),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 1 — order info (route, avg price, stats, departure time)
// ---------------------------------------------------------------------------

class _OrderInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('intercity.addr_order_info'.tr(),
              style: AppText.screenTitle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          SizedBox(height: 16.h),
          // Route + avg price block.
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3F8),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _RouteConnector(),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          children: [
                            _RoutePoint(
                              value: 'Toshkent shahri',
                              onTap: () => context.router.push(
                                  IntercityRegionPickRoute(
                                      toDestination: false)),
                            ),
                            Divider(height: 16.h, color: AppColors.border),
                            _RoutePoint(
                              value: 'Andijon shahri, Andijon viloyati',
                              onTap: () => context.router.push(
                                  IntercityRegionPickRoute(
                                      toDestination: true)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('intercity.addr_avg_price'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp, color: AppColors.primary)),
                      Text('300.000-450.000 som',
                          style: GoogleFonts.unbounded(
                              fontSize: 12.sp, color: AppColors.textDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Stats row: distance | time | drivers.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatChip(text: '~350 km'),
              _vDivider(),
              _StatChip(text: '~4.5 soat'),
              _vDivider(),
              _StatChip(
                icon: 'ia_taxi',
                richText: TextSpan(
                  style: GoogleFonts.unbounded(
                      fontSize: 12.sp, color: AppColors.textMuted),
                  children: [
                    const TextSpan(text: '26 '),
                    TextSpan(
                        text: 'x',
                        style: TextStyle(
                            fontSize: 8.sp, color: AppColors.textDark)),
                    const TextSpan(text: ' haydochi'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(height: 1.h, color: AppColors.border),
          SizedBox(height: 16.h),
          // Departure time row.
          _FieldRow(
            icon: 'ia_calendar_tick',
            title: 'intercity.addr_departure'.tr(),
            bordered: true,
            onTap: () => showIntercityTimeSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(width: 1, height: 24.h, color: AppColors.border);
}

/// The vertical location-dot → dashed line → flag connector on the left of the
/// pickup/drop-off rows.
class _RouteConnector extends StatelessWidget {
  const _RouteConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.r),
            child: SvgPicture.asset('$_icons/ia_loc_dot.svg',
                width: 20.r, height: 20.r),
          ),
          Expanded(
            child: _DashedLine(),
          ),
          Padding(
            padding: EdgeInsets.all(4.r),
            child: SvgPicture.asset('$_icons/ia_flag.svg',
                width: 20.r, height: 20.r),
          ),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // CustomPaint (not LayoutBuilder) so this is safe inside IntrinsicHeight:
    // LayoutBuilder cannot report intrinsic dimensions, which IntrinsicHeight
    // needs when sizing the route connector to the route-points column.
    return CustomPaint(
      size: const Size(1.5, double.infinity),
      painter: _DashedLinePainter(),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashH = 3.0;
    const gap = 3.0;
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final x = size.width / 2;
    double y = 0;
    while (y < size.height) {
      final end = (y + dashH) > size.height ? size.height : y + dashH;
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePoint extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  const _RoutePoint({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.input.copyWith(
                fontSize: 16.sp, color: AppColors.textDark),
          ),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h, bottom: 8.h),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('intercity.select'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textDark)),
                SvgPicture.asset('$_icons/ia_chevron_right.svg',
                    width: 16.r, height: 16.r),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String? text;
  final String? icon;
  final InlineSpan? richText;
  const _StatChip({this.text, this.icon, this.richText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            SvgPicture.asset('$_icons/$icon.svg', width: 16.r, height: 16.r),
            SizedBox(width: 4.w),
          ],
          if (richText != null)
            Text.rich(richText!)
          else
            Text(text ?? '',
                style: GoogleFonts.unbounded(
                    fontSize: 12.sp, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 2 — passengers
// ---------------------------------------------------------------------------

class _PassengersCard extends StatelessWidget {
  final bool fullSalon;
  final ValueChanged<bool> onFullSalon;
  final int men;
  final int women;
  final ValueChanged<int> onMen;
  final ValueChanged<int> onWomen;

  const _PassengersCard({
    required this.fullSalon,
    required this.onFullSalon,
    required this.men,
    required this.women,
    required this.onMen,
    required this.onWomen,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('intercity.addr_passengers'.tr(),
                  style: AppText.screenTitle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark)),
              Row(
                children: [
                  Text('intercity.addr_full_salon'.tr(),
                      style: TextStyle(
                          fontSize: 15.sp, color: AppColors.textDark)),
                  SizedBox(width: 12.w),
                  _Toggle(value: fullSalon, onChanged: onFullSalon),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _GenderStepper(
                  icon: 'ia_man',
                  label: 'intercity.addr_male'.tr(),
                  count: men,
                  onChanged: onMen,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _GenderStepper(
                  icon: 'ia_woman',
                  label: 'intercity.addr_female'.tr(),
                  count: women,
                  onChanged: onWomen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderStepper extends StatelessWidget {
  final String icon;
  final String label;
  final int count;
  final ValueChanged<int> onChanged;

  const _GenderStepper({
    required this.icon,
    required this.label,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('$_icons/$icon.svg',
                    width: 24.r, height: 24.r),
                SizedBox(height: 4.h),
                Text(label,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepBtn(icon: 'ia_minus', onTap: () => onChanged(-1)),
                SizedBox(
                  width: 24.w,
                  child: Text('$count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                ),
                _StepBtn(icon: 'ia_add', onTap: () => onChanged(1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child:
            SvgPicture.asset('$_icons/$icon.svg', width: 20.r, height: 20.r),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 3 — extras
// ---------------------------------------------------------------------------

class _ExtrasCard extends StatelessWidget {
  final bool hasLuggage;
  final ValueChanged<bool> onLuggage;
  final int luggageIndex;
  final ValueChanged<int> onLuggagePick;

  const _ExtrasCard({
    required this.hasLuggage,
    required this.onLuggage,
    required this.luggageIndex,
    required this.onLuggagePick,
  });

  static const _luggage = [
    ('intercity.addr_lug_bag', 'intercity.addr_lug_bag_sub'),
    ('intercity.addr_lug_suitcase', 'intercity.addr_lug_suitcase_sub'),
    ('intercity.addr_lug_box', 'intercity.addr_lug_box_sub'),
    ('intercity.addr_lug_other', 'intercity.addr_lug_other_sub'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          // Qoshimchalar row.
          _FieldRow(
            icon: 'ia_snow',
            title: 'intercity.addr_extras'.tr(),
            subtitle: 'intercity.addr_extras_sub'.tr(),
            onTap: () => showIntercityExtraSheet(context),
          ),
          SizedBox(height: 16.h),
          // Bagaj toggle + luggage size chips.
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('$_icons/ia_briefcase.svg',
                        width: 24.r, height: 24.r),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('intercity.addr_luggage'.tr(),
                              style: AppText.input.copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.textDark)),
                          Text('intercity.addr_luggage_sub'.tr(),
                              style: AppText.label.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    _Toggle(value: hasLuggage, onChanged: onLuggage),
                  ],
                ),
                if (hasLuggage) ...[
                  SizedBox(height: 8.h),
                  Divider(height: 1.h, color: AppColors.border),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      for (var i = 0; i < _luggage.length; i++) ...[
                        Expanded(
                          child: _LuggageChip(
                            title: _luggage[i].$1.tr(),
                            subtitle: _luggage[i].$2.tr(),
                            selected: luggageIndex == i,
                            onTap: () => onLuggagePick(i),
                          ),
                        ),
                        if (i != _luggage.length - 1) SizedBox(width: 6.w),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LuggageChip extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LuggageChip({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16.r),
          border: selected
              ? Border.all(color: AppColors.selectBlue, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.unbounded(
                          fontSize: 9.sp,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected
                              ? AppColors.selectBlue
                              : AppColors.textDark)),
                ),
                SvgPicture.asset('$_icons/ia_info_circle.svg',
                    width: 16.r, height: 16.r),
              ],
            ),
            SizedBox(height: 4.h),
            Text(subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 10.sp, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar — commission + CTA
// ---------------------------------------------------------------------------

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textDark,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Commission row.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('$_icons/ia_discount.svg',
                        width: 20.r, height: 20.r),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('intercity.addr_commission'.tr(),
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textOnDark)),
                        Opacity(
                          opacity: 0.8,
                          child: Text('intercity.addr_commission_sub'.tr(),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textOnDark)),
                        ),
                      ],
                    ),
                  ],
                ),
                Text('3 000 so’m',
                    style: GoogleFonts.unbounded(
                        fontSize: 15.sp, color: AppColors.textOnDark)),
              ],
            ),
          ),
          // CTA in a white rounded container.
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: SafeArea(
              top: false,
              child: GestureDetector(
                onTap: () => context.router.push(const IntercityDriversRoute()),
                child: Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.selectBlue,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('intercity.addr_find_driver'.tr(),
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textOnDark)),
                            Opacity(
                              opacity: 0.8,
                              child: Text(
                                  'intercity.addr_find_driver_sub'.tr(),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textOnDark)),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset('$_icons/ia_arrow_right_w.svg',
                          width: 20.r, height: 20.r),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

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

/// A grey field row: leading icon, title (+ optional subtitle), trailing
/// chevron. Used for the departure-time and "Qoshimchalar" rows.
class _FieldRow extends StatelessWidget {
  final String icon;
  final String title;
  final String? subtitle;
  final bool bordered;
  final VoidCallback onTap;

  const _FieldRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.bordered = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
          border: bordered ? Border.all(color: AppColors.border) : null,
        ),
        child: Row(
          children: [
            SvgPicture.asset('$_icons/$icon.svg', width: 24.r, height: 24.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.input.copyWith(
                          fontSize: 16.sp, color: AppColors.textDark)),
                  if (subtitle != null)
                    Text(subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.label.copyWith(
                            fontSize: 12.sp, color: AppColors.textMuted)),
                ],
              ),
            ),
            SvgPicture.asset('$_icons/ia_chevron_right.svg',
                width: 20.r, height: 20.r),
          ],
        ),
      ),
    );
  }
}

/// A small pill on/off switch matching the Figma "Setting On Off" component.
class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40.w,
        height: 24.h,
        padding: EdgeInsets.all(3.r),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? AppColors.selectBlue : const Color(0xFFDADEE0),
          borderRadius: BorderRadius.circular(80.r),
        ),
        child: Container(
          width: 18.r,
          height: 18.r,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
