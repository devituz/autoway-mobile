import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../../../client/intercity/presentation/pages/intercity_time_page.dart';

const _icons = 'assets/icons';

/// Driver flow — "Liniyaga chiqish" (go online) form, 1:1 with Figma node
/// 2193:21631. A scrollable form: route + swap, departure time, four intake
/// toggles, services (Taxi / Posilkalar with price inputs), interactive seat
/// map, commission note, extras checklist; pinned dark commission bar and the
/// blue "Liniyaga chiqish" CTA. Pops with `true` when the driver goes online.
@RoutePage()
class DriverGoOnlinePage extends StatefulWidget {
  const DriverGoOnlinePage({super.key});

  @override
  State<DriverGoOnlinePage> createState() => _DriverGoOnlinePageState();
}

class _DriverGoOnlinePageState extends State<DriverGoOnlinePage> {
  String _from = 'Toshkent shahri';
  String _to = 'Andijon shahri, Andijon viloyati';

  bool _pickupClient = false;
  bool _pickupParcel = false;
  bool _clientPriceOffer = false;
  bool _autoAccept = false;

  bool _taxi = true;
  bool _parcels = false;
  final _seatPriceController = TextEditingController(text: '150 000');
  final _parcelPriceController = TextEditingController(text: '0');

  /// Seat slots: index 0 = front seat, 1-3 = back row.
  final Set<int> _seats = {0};

  final Set<int> _extras = {1, 2};
  static const _extraOptions = [
    ('personalcard', 'intercity.extra_for_other'),
    ('ib_snow', 'intercity.extra_ac'),
    ('ic_no_smoke', 'intercity.extra_no_smoking'),
    ('ib_pet', 'intercity.extra_pets'),
    ('ib_music', 'intercity.extra_music'),
    ('ib_pause_circle', 'intercity.extra_silence'),
  ];

  @override
  void dispose() {
    _seatPriceController.dispose();
    _parcelPriceController.dispose();
    super.dispose();
  }

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
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Column(
                children: [
                  _Card(
                    child: Column(
                      children: [
                        _RoutePickerBox(from: _from, to: _to, onSwap: _swap),
                        SizedBox(height: 16.h),
                        _DepartureTimeRow(
                          onTap: () => showIntercityTimeSheet(context),
                        ),
                        SizedBox(height: 16.h),
                        const _DashedLine(color: AppColors.border),
                        _ToggleRow(
                          label: 'line.pickup_client'.tr(),
                          value: _pickupClient,
                          onChanged: (v) => setState(() => _pickupClient = v),
                        ),
                        _ToggleRow(
                          label: 'line.pickup_parcel'.tr(),
                          value: _pickupParcel,
                          onChanged: (v) => setState(() => _pickupParcel = v),
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
                          last: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Hizmatlar — Taxi / Posilkalar + price inputs.
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('line.services'.tr(),
                            style: AppText.screenTitle.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        SizedBox(height: 12.h),
                        _ServiceRow(
                          label: 'line.taxi'.tr(),
                          enabled: _taxi,
                          onChanged: (v) => setState(() => _taxi = v),
                          priceLabel: 'line.seat_price'.tr(),
                          controller: _seatPriceController,
                        ),
                        SizedBox(height: 8.h),
                        _ServiceRow(
                          label: 'line.parcels'.tr(),
                          enabled: _parcels,
                          onChanged: (v) => setState(() => _parcels = v),
                          priceLabel: 'line.parcel_price'.tr(),
                          controller: _parcelPriceController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Orindiqlar holati — interactive seat map.
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('line.seats_status'.tr(),
                            style: AppText.screenTitle.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        SizedBox(height: 2.h),
                        Text('line.seats_hint'.tr(),
                            style: AppText.label.copyWith(
                                fontSize: 12.sp, color: AppColors.textMuted)),
                        SizedBox(height: 12.h),
                        const _DashedLine(color: AppColors.border),
                        SizedBox(height: 12.h),
                        // Front seat (right-aligned like the car layout).
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 24.w),
                            child: _SeatTile(
                              selected: _seats.contains(0),
                              onTap: () => _toggleSeat(0),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 1; i <= 3; i++) ...[
                              _SeatTile(
                                selected: _seats.contains(i),
                                onTap: () => _toggleSeat(i),
                              ),
                              if (i != 3) SizedBox(width: 8.w),
                            ],
                          ],
                        ),
                        SizedBox(height: 12.h),
                        const _DashedLine(color: AppColors.border),
                        SizedBox(height: 12.h),
                        // Commission note.
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset('$_icons/ia_discount.svg',
                                  width: 24.r,
                                  height: 24.r,
                                  colorFilter: const ColorFilter.mode(
                                      AppColors.textDark, BlendMode.srcIn)),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('intercity.addr_commission'.tr(),
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textDark)),
                                    Text('intercity.addr_commission_sub'.tr(),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.textDark)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Qo'shimcha checklist.
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('intercity.extra_title'.tr(),
                            style: AppText.screenTitle.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark)),
                        SizedBox(height: 4.h),
                        for (var i = 0; i < _extraOptions.length; i++)
                          _ExtraRow(
                            icon: _extraOptions[i].$1,
                            label: _extraOptions[i].$2.tr(),
                            checked: _extras.contains(i),
                            onTap: () => setState(() {
                              if (!_extras.add(i)) _extras.remove(i);
                            }),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        onGoOnline: () => context.router.maybePop(true),
      ),
    );
  }

  void _toggleSeat(int i) => setState(() {
        if (!_seats.add(i)) _seats.remove(i);
      });
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.maybePop(false),
                child: SvgPicture.asset('$_icons/mt_back.svg',
                    width: 32.r, height: 32.r),
              ),
              Expanded(
                child: Text(
                  'line.title'.tr(),
                  textAlign: TextAlign.center,
                  style: AppText.screenTitle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark),
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
                child: SvgPicture.asset('$_icons/info_circle.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary, BlendMode.srcIn)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────── Cards / rows ───────────────────────────

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
        color: const Color(0xFFF8FAFC),
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
                          child: SvgPicture.asset('$_icons/mt_location.svg',
                              width: 20.r, height: 20.r),
                        ),
                      ),
                      const Expanded(
                        child:
                            _DashedVerticalLine(color: AppColors.textDark),
                      ),
                      SizedBox(
                        width: 28.r,
                        height: 28.r,
                        child: Center(
                          child: SvgPicture.asset('$_icons/mt_flag.svg',
                              width: 20.r, height: 20.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    children: [
                      _RoutePointRow(
                        value: from,
                        onSelect: () => context.router
                            .push(IntercityRegionPickRoute(toDestination: false)),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      _RoutePointRow(
                        value: to,
                        onSelect: () => context.router
                            .push(IntercityRegionPickRoute(toDestination: true)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Swap button over the divider.
          Positioned(
            left: 120.w,
            child: GestureDetector(
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
                child: Icon(Icons.swap_vert,
                    size: 20.sp, color: AppColors.textOnDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePointRow extends StatelessWidget {
  final String value;
  final VoidCallback onSelect;
  const _RoutePointRow({required this.value, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark),
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSelect,
            child: Container(
              padding:
                  EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h, bottom: 8.h),
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
                  Icon(Icons.chevron_right,
                      size: 16.sp, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DepartureTimeRow extends StatelessWidget {
  final VoidCallback onTap;
  const _DepartureTimeRow({required this.onTap});

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
        ),
        child: Row(
          children: [
            SvgPicture.asset('$_icons/ia_calendar_tick.svg',
                width: 24.r, height: 24.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text('intercity.addr_departure'.tr(),
                  style: AppText.input.copyWith(
                      fontSize: 16.sp, color: AppColors.textDark)),
            ),
            SvgPicture.asset('$_icons/ia_chevron_right.svg',
                width: 20.r, height: 20.r),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool last;
  const _ToggleRow(
      {required this.label,
      required this.value,
      required this.onChanged,
      this.last = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: last
          ? null
          : const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.fieldFill)),
            ),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark)),
          ),
          _Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// 40x24 pill switch (Figma component).
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
        width: 40.w,
        height: 24.h,
        padding: EdgeInsets.all(3.r),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? AppColors.ctaBlue : AppColors.switchOff,
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

class _ServiceRow extends StatelessWidget {
  final String label;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final String priceLabel;
  final TextEditingController controller;

  const _ServiceRow({
    required this.label,
    required this.enabled,
    required this.onChanged,
    required this.priceLabel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label + switch pill.
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                ),
                _Switch(value: enabled, onChanged: onChanged),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        // Price input.
        Expanded(
          child: Opacity(
            opacity: enabled ? 1 : 0.5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(priceLabel,
                      style: TextStyle(
                          fontSize: 10.sp, color: AppColors.textMuted)),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          enabled: enabled,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                          ],
                          style: GoogleFonts.unbounded(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark),
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(' so‘m',
                          style: GoogleFonts.unbounded(
                              fontSize: 12.sp, color: AppColors.textMuted)),
                    ],
                  ),
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

/// Selectable seat tile: rounded seat silhouette, blue border + check when on.
class _SeatTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  const _SeatTile({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 86.r,
        height: 96.r,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 12.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF0FE) : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.selectBlue : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Container(
          width: 28.r,
          height: 28.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.ctaBlue : AppColors.accent,
            shape: BoxShape.circle,
            border: selected
                ? null
                : Border.all(color: AppColors.gray30, width: 1.5),
          ),
          child: selected
              ? Icon(Icons.check, size: 16.r, color: AppColors.textOnDark)
              : null,
        ),
      ),
    );
  }
}

class _ExtraRow extends StatelessWidget {
  final String icon;
  final String label;
  final bool checked;
  final VoidCallback onTap;

  const _ExtraRow(
      {required this.icon,
      required this.label,
      required this.checked,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.fieldFill)),
        ),
        child: Row(
          children: [
            SvgPicture.asset('$_icons/$icon.svg', width: 24.r, height: 24.r),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14.sp, color: AppColors.textDark)),
            ),
            Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: checked ? AppColors.ctaBlue : AppColors.accent,
                shape: BoxShape.circle,
                border: checked
                    ? null
                    : Border.all(color: AppColors.gray30, width: 2),
              ),
              child: checked
                  ? Icon(Icons.check, size: 16.r, color: AppColors.textOnDark)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Bottom bar ───────────────────────────

class _BottomBar extends StatelessWidget {
  final VoidCallback onGoOnline;
  const _BottomBar({required this.onGoOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                SvgPicture.asset('$_icons/ia_discount.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                        AppColors.textOnDark, BlendMode.srcIn)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text('intercity.addr_commission'.tr(),
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textOnDark)),
                ),
                Text('3 000 so’m',
                    style: GoogleFonts.unbounded(
                        fontSize: 15.sp, color: AppColors.textOnDark)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Swipe hint pill.
                  Container(
                    width: 56.w,
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.creditGreen),
                    ),
                    child: Icon(Icons.keyboard_double_arrow_right,
                        size: 22.sp, color: AppColors.creditGreen),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onGoOnline,
                      child: Container(
                        height: 48.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: AppColors.ctaBlue,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('line.title'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textOnDark)),
                            ),
                            SvgPicture.asset('$_icons/c_flash.svg',
                                width: 24.r,
                                height: 24.r,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.textOnDark, BlendMode.srcIn)),
                          ],
                        ),
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

// ─────────────────────────── Dashed lines ───────────────────────────

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

/// CustomPaint (not LayoutBuilder) so it is safe inside IntrinsicHeight.
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
