import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../widgets/extra_sheet.dart';

const _icons = 'assets/icons';

/// "Liniyaga chiqish" — go-online / line-up screen (Figma node 2232:32430).
///
/// Driver toggles which order types they accept, configures service prices,
/// and marks which seats are available before going online.
@RoutePage()
class GoOnlinePage extends StatefulWidget {
  const GoOnlinePage({super.key});

  @override
  State<GoOnlinePage> createState() => _GoOnlinePageState();
}

class _GoOnlinePageState extends State<GoOnlinePage> {
  // Top toggle rows.
  bool _pickupClient = true;
  bool _pickupParcel = false;
  bool _clientPriceOffer = true;
  bool _autoAccept = false;

  // Service toggles.
  bool _taxi = true;
  bool _parcels = false;

  // Alert cards (dismissible).
  bool _showNewClientAlert = true;
  bool _showBlockAlert = true;

  // Seat selection — indices of the selected (available) seats.
  // NOTE: the exact seat illustrations from Figma were approximated with
  // tappable seat tiles, since the original export was a flattened raster.
  final Set<int> _selectedSeats = {0, 2};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldFill,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showNewClientAlert) ...[
                    _NewClientAlert(
                      onClose: () =>
                          setState(() => _showNewClientAlert = false),
                    ),
                    SizedBox(height: 12.h),
                  ],
                  if (_showBlockAlert) ...[
                    _BlockAlert(
                      onClose: () => setState(() => _showBlockAlert = false),
                    ),
                    SizedBox(height: 12.h),
                  ],
                  _Card(
                    child: Column(
                      children: [
                        _ToggleRow(
                          label: 'line.pickup_client'.tr(),
                          value: _pickupClient,
                          onChanged: (v) => setState(() => _pickupClient = v),
                        ),
                        const _RowDivider(),
                        _ToggleRow(
                          label: 'line.pickup_parcel'.tr(),
                          value: _pickupParcel,
                          onChanged: (v) => setState(() => _pickupParcel = v),
                        ),
                        const _RowDivider(),
                        _ToggleRow(
                          label: 'line.client_price_offer'.tr(),
                          value: _clientPriceOffer,
                          onChanged: (v) =>
                              setState(() => _clientPriceOffer = v),
                        ),
                        const _RowDivider(),
                        _ToggleRow(
                          label: 'line.auto_accept'.tr(),
                          value: _autoAccept,
                          onChanged: (v) => setState(() => _autoAccept = v),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('line.services'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 16.h),
                        _ServiceRow(
                          label: 'line.taxi'.tr(),
                          value: _taxi,
                          onChanged: (v) => setState(() => _taxi = v),
                          priceLabel: 'line.seat_price'.tr(),
                          priceValue: '150 000 so‘m',
                          enabled: true,
                        ),
                        SizedBox(height: 8.h),
                        _ServiceRow(
                          label: 'line.parcels'.tr(),
                          value: _parcels,
                          onChanged: (v) => setState(() => _parcels = v),
                          priceLabel: 'line.parcel_price'.tr(),
                          priceValue: '0 so‘m',
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('line.seats_status'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 4.h),
                        Text('line.seats_hint'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 13.sp, color: AppColors.textMuted)),
                        SizedBox(height: 16.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            for (var i = 0; i < 4; i++)
                              _SeatTile(
                                index: i,
                                selected: _selectedSeats.contains(i),
                                onTap: () => setState(() {
                                  if (_selectedSeats.contains(i)) {
                                    _selectedSeats.remove(i);
                                  } else {
                                    _selectedSeats.add(i);
                                  }
                                }),
                              ),
                          ],
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
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 6,
              offset: const Offset(0, 4)),
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
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SvgPicture.asset('$_icons/arrow_left.svg',
                        width: 20.sp, height: 20.sp),
                  ),
                ),
                Expanded(
                  child: Text('line.title'.tr(),
                      textAlign: TextAlign.center,
                      style: AppText.subtitle.copyWith(
                          fontSize: 15.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => showExtraSheet(context),
                  child: SvgPicture.asset('$_icons/info_circle.svg',
                      width: 24.sp, height: 24.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class _NewClientAlert extends StatelessWidget {
  final VoidCallback onClose;
  const _NewClientAlert({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SvgPicture.asset('$_icons/personalcard.svg',
                width: 24.sp, height: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('line.new_client'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4.h),
                Text('line.new_client_msg'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 13.sp, color: AppColors.textMuted)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onClose,
            child: Icon(Icons.close, size: 18.sp, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _BlockAlert extends StatelessWidget {
  final VoidCallback onClose;
  const _BlockAlert({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.logoutRed,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SvgPicture.asset('$_icons/lock.svg',
                width: 24.sp, height: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('line.new_client'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4.h),
                Text('line.block_msg'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 13.sp, color: AppColors.danger)),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onClose,
            child: Icon(Icons.close, size: 18.sp, color: AppColors.danger),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: AppText.subtitle
                    .copyWith(fontSize: 14.sp, color: AppColors.textDark)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.blue,
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1.h, thickness: 1, color: AppColors.border);
  }
}

class _ServiceRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String priceLabel;
  final String priceValue;
  final bool enabled;

  const _ServiceRow({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.priceLabel,
    required this.priceValue,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Pill: service label + on/off toggle.
        Expanded(
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(label,
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp, color: AppColors.textDark)),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.blue,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        // Price box.
        Expanded(
          child: Opacity(
            opacity: enabled ? 1 : 0.5,
            child: Container(
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(priceLabel,
                      style: AppText.label.copyWith(
                          fontSize: 10.sp, color: AppColors.textMuted)),
                  SizedBox(height: 2.h),
                  Text(priceValue,
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SeatTile extends StatelessWidget {
  final int index;
  final bool selected;
  final VoidCallback onTap;
  const _SeatTile({
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64.r,
        height: 76.r,
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.blue : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_seat,
                size: 24.sp,
                color: selected ? AppColors.blue : AppColors.textSecondary),
            SizedBox(height: 4.h),
            Text('3 000',
                style: AppText.label.copyWith(
                    fontSize: 10.sp,
                    color: selected ? AppColors.textDark : AppColors.textMuted,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
