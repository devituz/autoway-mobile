import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/intercity_trip_status.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import 'intercity_price_page.dart';

const _icons = 'assets/icons';
const _images = 'assets/images';

const int _seatPrice = 400000;
const int _commissionPerSeat = 3000;

/// Intercity-taxi flow — driver detail / booking sheet
/// (Figma node 2173:11965 "Haydovchi_View"). The selected-seats state shown in
/// Figma node 2177:14897 is the same page with two seats picked, which this
/// page reproduces via local seat-selection state (header tag, total price and
/// the booking CTA all update accordingly).
/// Shown as a real modal bottom sheet. Resolves to the initial trip status
/// when the user books ("Bron qilish"), null when dismissed.
Future<IntercityTripStatus?> showIntercityDriverDetailSheet(
    BuildContext context) {
  return showModalBottomSheet<IntercityTripStatus>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99282828),
    builder: (_) => const _DriverDetailSheetBody(),
  );
}

class _DriverDetailSheetBody extends StatefulWidget {
  const _DriverDetailSheetBody();

  @override
  State<_DriverDetailSheetBody> createState() => _DriverDetailSheetBodyState();
}

class _DriverDetailSheetBodyState extends State<_DriverDetailSheetBody> {
  // Seat slots: 4 freely-selectable, the two "band" tiles are occupied.
  static const int _requiredSeats = 2; // "Bosh o'rindiqlar: 2"
  final Set<int> _selected = {0}; // 0 = first selectable (pre-selected)

  int get _count => _selected.length;
  int get _total => _count * _seatPrice;
  int get _commission => _count * _commissionPerSeat;

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _requiredSeats - _count;
    return FractionallySizedBox(
      heightFactor: 0.93,
      child: Column(
        children: [
          // Drag handle.
          Container(
            width: 112.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.softGrey,
              borderRadius: BorderRadius.circular(60.r),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                children: [
                  const _DriverInfoCard(),
                  SizedBox(height: 8.h),
                  _SeatSelectionCard(
                    selected: _selected,
                    onToggle: _toggle,
                    remaining: remaining < 0 ? 0 : remaining,
                    total: _fmt(_total),
                  ),
                  SizedBox(height: 8.h),
                  const _ExtrasCard(),
                ],
              ),
            ),
          ),
          _BottomBar(
            commission: _fmt(_commission),
            count: _count,
            total: _fmt(_total),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 1 — driver info
// ---------------------------------------------------------------------------
class _DriverInfoCard extends StatelessWidget {
  const _DriverInfoCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      gap: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset('$_images/ic_driver1.png',
                      width: 48.r, height: 48.r, fit: BoxFit.cover),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Akbar Yoldoshev',
                        style: AppText.bodyMedium.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark)),
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: 16.r, color: AppColors.accentYellow),
                        SizedBox(width: 2.w),
                        Text('8.6',
                            style: AppText.subtitle.copyWith(
                                fontSize: 14.sp, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.router.maybePop(),
              child: Container(
                width: 52.r,
                height: 52.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: SvgPicture.asset('$_icons/od_close.svg',
                    width: 20.r, height: 20.r),
              ),
            ),
          ],
        ),
        const _ThinDivider(),
        _PriceRow(
            label: 'intercity.driverview_seat_price'.tr(), value: '400 000 som'),
        SizedBox(height: 8.h),
        _PriceRow(
          label: 'intercity.driverview_leaving_at'.tr(),
          valueSpans: [
            const TextSpan(
                text: '15 aprel, ',
                style: TextStyle(color: AppColors.ctaBlue)),
            const TextSpan(
                text: '16:00', style: TextStyle(color: AppColors.ctaBlue)),
          ],
        ),
        const _ThinDivider(),
        // Plate + car + photos.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('01 B 125 YC',
                      style: GoogleFonts.unbounded(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                  Text('Cobalt LTZ | Oq',
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp, color: AppColors.textMuted)),
                ],
              ),
            ),
            const _CarPhotos(),
          ],
        ),
        // Pickup / dropoff.
        const _RouteCard(),
        // Fuel + reviews inputs.
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.fieldFill)),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  SvgPicture.asset('$_icons/c_flash.svg',
                      width: 24.r,
                      height: 24.r,
                      colorFilter: ColorFilter.mode(
                          AppColors.textMuted, BlendMode.srcIn)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text('intercity.driverview_fuel'.tr(),
                        style: AppText.subtitle.copyWith(
                            fontSize: 14.sp, color: AppColors.textMuted)),
                  ),
                  Text('intercity.driverview_fuel_methane'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // TODO(nav): -> reviews
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    SvgPicture.asset('$_icons/messages.svg',
                        width: 24.r,
                        height: 24.r,
                        colorFilter: ColorFilter.mode(
                            AppColors.textMuted, BlendMode.srcIn)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text('intercity.driverview_reviews'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp, color: AppColors.textMuted)),
                    ),
                    SvgPicture.asset('$_icons/ia_arrow_right.svg',
                        width: 20.r, height: 20.r),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CarPhotos extends StatelessWidget {
  const _CarPhotos();

  Widget _photo(String name) => Container(
        width: 100.w,
        height: 80.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accent, width: 3),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
                color: const Color(0x14000000),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Image.asset('$_images/$name.png', fit: BoxFit.cover),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138.w,
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 0, child: _photo('ic_car1')),
          Positioned(left: 19.w, child: _photo('ic_car2')),
          Positioned(left: 38.w, child: _photo('ic_car3')),
          Positioned(
            right: 0,
            top: 30.h,
            child: SvgPicture.asset('$_icons/ia_search.svg',
                width: 20.r, height: 20.r),
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(8.r),
        child: IntrinsicHeight(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connector.
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: SvgPicture.asset('$_icons/mt_location.svg',
                      width: 20.r, height: 20.r),
                ),
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: AppColors.lightGrey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4.r),
                  child: SvgPicture.asset('$_icons/mt_flag.svg',
                      width: 20.r, height: 20.r),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                children: [
                  _routeRow(
                      'Toshkent shahri', 'intercity.driverview_full_address'.tr()),
                  Divider(height: 16.h, color: AppColors.fieldFill),
                  _routeRow('Andijon shahri, Andijon viloyati',
                      'intercity.driverview_full_address'.tr()),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _routeRow(String title, String sub) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyMedium.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark)),
              Text(sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(
                      fontSize: 12.sp, color: AppColors.textMuted)),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        SvgPicture.asset('$_icons/ia_arrow_right.svg',
            width: 20.r, height: 20.r),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card 2 — seat selection
// ---------------------------------------------------------------------------
class _SeatSelectionCard extends StatelessWidget {
  final Set<int> selected;
  final ValueChanged<int> onToggle;
  final int remaining;
  final String total;

  const _SeatSelectionCard({
    required this.selected,
    required this.onToggle,
    required this.remaining,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      gap: 16.h,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('intercity.driverview_pick_seat'.tr(),
                      style: AppText.screenTitle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  Text('intercity.driverview_main_seats'
                      .tr(namedArgs: {'count': '2'}),
                      style: AppText.label.copyWith(
                          fontSize: 12.sp, color: AppColors.textMuted)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.lightGrey,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: RichText(
                text: TextSpan(
                  style: AppText.bodyMedium.copyWith(
                      fontSize: 16.sp, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                        text: '${'intercity.driverview_more'.tr()} ',
                        style: TextStyle(color: AppColors.textDark)),
                    TextSpan(
                        text: 'intercity.driverview_n_seats'
                            .tr(namedArgs: {'count': '$remaining'}),
                        style: TextStyle(color: AppColors.logoutRed)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const _ThinDivider(),
        // Seat tiles row: 0 selectable, 1 band, 2 band, 3 selectable.
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.w,
          runSpacing: 12.h,
          children: [
            _SeatTile(
              state: selected.contains(0)
                  ? _TileState.selected
                  : _TileState.free,
              price: '400 000',
              onTap: () => onToggle(0),
            ),
            const _SeatTile(state: _TileState.busy),
            const _SeatTile(state: _TileState.busy),
            _SeatTile(
              state: selected.contains(3)
                  ? _TileState.selected
                  : _TileState.free,
              price: '400 000',
              onTap: () => onToggle(3),
            ),
          ],
        ),
        // Info banner.
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset('$_icons/info_circle.svg',
                  width: 20.r, height: 20.r),
              SizedBox(width: 10.w),
              Expanded(
                child: Text('intercity.driverview_seat_note'.tr(),
                    textAlign: TextAlign.center,
                    style: AppText.label.copyWith(
                        fontSize: 12.sp, color: AppColors.textDark)),
              ),
            ],
          ),
        ),
        const _ThinDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('intercity.driverview_total'.tr(),
                style: AppText.subtitle.copyWith(
                    fontSize: 14.sp, color: AppColors.textDark)),
            Text('$total so‘m',
                style: GoogleFonts.unbounded(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark)),
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => showIntercityPriceSheet(context),
          child: Container(
            height: 48.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('intercity.driverview_propose_price'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark)),
                SizedBox(width: 4.w),
                SvgPicture.asset('$_icons/ia_arrow_right.svg',
                    width: 20.r, height: 20.r),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _TileState { free, selected, busy }

class _SeatTile extends StatelessWidget {
  final _TileState state;
  final String? price;
  final VoidCallback? onTap;
  const _SeatTile({required this.state, this.price, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool selected = state == _TileState.selected;
    final bool busy = state == _TileState.busy;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 86.w,
        height: 124.h,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Seat back.
            Container(
              width: 86.w,
              height: 76.h,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEAF0FE)
                    : AppColors.border,
                border: Border.all(
                    color: selected
                        ? AppColors.selectBlue
                        : AppColors.lightGrey,
                    width: selected ? 2 : 1),
                borderRadius: BorderRadius.circular(17.r),
              ),
            ),
            // Seat cushion.
            Positioned(
              bottom: 0,
              child: Container(
                width: 52.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            // Label.
            Positioned(
              top: 6.h,
              child: Text(
                busy ? 'intercity.driverview_busy'.tr() : (price ?? ''),
                style: AppText.label.copyWith(
                    fontSize: 12.sp,
                    color: busy ? AppColors.logoutRed : const Color(0xFF475569)),
              ),
            ),
            // Center indicator.
            Positioned(
              top: 30.h,
              child: busy
                  ? Row(
                      children: [
                        SvgPicture.asset('$_icons/ia_man.svg',
                            width: 22.r,
                            height: 22.r,
                            colorFilter: ColorFilter.mode(
                                AppColors.textMuted, BlendMode.srcIn)),
                        SvgPicture.asset('$_icons/ia_woman.svg',
                            width: 22.r,
                            height: 22.r,
                            colorFilter: ColorFilter.mode(
                                AppColors.textMuted, BlendMode.srcIn)),
                      ],
                    )
                  : Container(
                      width: 28.r,
                      height: 28.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.statusGreen : AppColors.accent,
                        shape: BoxShape.circle,
                        border: selected
                            ? null
                            : Border.all(
                                color: AppColors.lightGrey, width: 2),
                      ),
                      child: selected
                          ? SvgPicture.asset('$_icons/check.svg',
                              width: 12.r,
                              height: 12.r,
                              colorFilter: ColorFilter.mode(
                                  AppColors.accent, BlendMode.srcIn))
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 3 — extras
// ---------------------------------------------------------------------------
class _ExtrasCard extends StatelessWidget {
  const _ExtrasCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      gap: 12.h,
      children: [
        Text('intercity.driverview_extras'.tr(),
            style: AppText.screenTitle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark)),
        Column(
          children: [
            _ExtraRow(
                icon: 'ib_personalcard',
                label: 'intercity.driverview_extra_order_for_other'.tr(),
                checked: true),
            _ExtraRow(
                icon: 'ib_snow',
                label: 'intercity.driverview_extra_ac'.tr(),
                checked: false),
            _ExtraRow(
                icon: null,
                label: 'intercity.driverview_extra_no_smoking'.tr(),
                checked: false),
            _ExtraRow(
                icon: 'ib_pet',
                label: 'intercity.driverview_extra_pets'.tr(),
                checked: true),
            _ExtraRow(
                icon: 'ib_music',
                label: 'intercity.driverview_extra_music'.tr(),
                checked: true),
            _ExtraRow(
                icon: 'ib_pause_circle',
                label: 'intercity.driverview_extra_quiet'.tr(),
                checked: true,
                last: true),
          ],
        ),
      ],
    );
  }
}

class _ExtraRow extends StatelessWidget {
  final String? icon;
  final String label;
  final bool checked;
  final bool last;
  const _ExtraRow(
      {required this.icon,
      required this.label,
      required this.checked,
      this.last = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: AppColors.fieldFill)),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          if (icon != null) ...[
            SvgPicture.asset('$_icons/$icon.svg', width: 24.r, height: 24.r),
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: Text(label,
                style: AppText.subtitle.copyWith(
                    fontSize: 14.sp, color: AppColors.textDark)),
          ),
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
                checked ? '$_icons/check.svg' : '$_icons/ia_minus.svg',
                width: checked ? 12.r : 14.r,
                height: checked ? 12.r : 14.r,
                colorFilter: checked
                    ? ColorFilter.mode(AppColors.selectBlue, BlendMode.srcIn)
                    : ColorFilter.mode(AppColors.logoutRed, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar
// ---------------------------------------------------------------------------
class _BottomBar extends StatelessWidget {
  final String commission;
  final int count;
  final String total;
  const _BottomBar(
      {required this.commission, required this.count, required this.total});

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
              offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Commission.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                SvgPicture.asset('$_icons/ia_discount.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: ColorFilter.mode(
                        AppColors.textOnDark, BlendMode.srcIn)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('intercity.driverview_commission'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textOnDark)),
                      Opacity(
                        opacity: 0.8,
                        child: Text('intercity.driverview_commission_note'.tr(),
                            style: AppText.label.copyWith(
                                fontSize: 12.sp, color: AppColors.textOnDark)),
                      ),
                    ],
                  ),
                ),
                Text('$commission so‘m',
                    style: GoogleFonts.unbounded(
                        fontSize: 15.sp, color: AppColors.textOnDark)),
              ],
            ),
          ),
          // CTA.
          Container(
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            padding: EdgeInsets.all(16.r),
            child: SafeArea(
              top: false,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () =>
                    Navigator.of(context).pop(IntercityTripStatus.awaiting),
                child: Container(
                  height: 56.h,
                  padding: EdgeInsets.only(right: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.selectBlue,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('intercity.driverview_book'.tr(),
                                style: AppText.subtitle.copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textOnDark)),
                            Opacity(
                              opacity: 0.8,
                              child: Text(
                                  'intercity.driverview_book_note'.tr(
                                      namedArgs: {
                                        'count': '$count',
                                        'total': total
                                      }),
                                  style: AppText.label.copyWith(
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
// Shared bits
// ---------------------------------------------------------------------------
class _WhiteCard extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  const _WhiteCard({required this.children, required this.gap});

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) spaced.add(SizedBox(height: gap));
    }
    return Container(
      color: AppColors.accent,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: spaced,
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.fieldFill);
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<InlineSpan>? valueSpans;
  const _PriceRow({required this.label, this.value, this.valueSpans});

  @override
  Widget build(BuildContext context) {
    final valueStyle = GoogleFonts.unbounded(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp, color: AppColors.textDark)),
        if (valueSpans != null)
          RichText(text: TextSpan(style: valueStyle, children: valueSpans))
        else
          Text(value!, style: valueStyle),
      ],
    );
  }
}
