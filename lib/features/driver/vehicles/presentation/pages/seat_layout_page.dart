import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

/// Driver flow — "Orindiqlar tuzilmasi" seat-layout picker (Figma node
/// 2232:17016). A white bottom sheet over a translucent scrim: a capacity
/// selector (4/5/6/7 orindiqli) followed by the matching seat arrangement,
/// where each passenger seat is a tappable chair carrying a round checkbox so
/// the driver can mark which seats are active.
@RoutePage()
class SeatLayoutPage extends StatefulWidget {
  const SeatLayoutPage({super.key});

  @override
  State<SeatLayoutPage> createState() => _SeatLayoutPageState();
}

class _SeatLayoutPageState extends State<SeatLayoutPage> {
  /// Selectable seat capacities. Index 3 (7 orindiqli) is preselected to match
  /// the Figma reference frame.
  static const _capacities = <int>[4, 5, 6, 7];
  int _capacity = 7;

  /// Active (checked) passenger seats by their 0-based index in the current
  /// layout. Reset whenever the capacity changes.
  final Set<int> _active = <int>{};

  /// Passenger-seat count for a given total capacity (one slot is the driver).
  int get _seatCount => _capacity - 1;

  void _selectCapacity(int value) {
    if (value == _capacity) return;
    setState(() {
      _capacity = value;
      _active.clear();
    });
  }

  void _toggleSeat(int index) {
    setState(() {
      if (!_active.add(index)) _active.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.router.maybePop(),
              child: const ColoredBox(color: Color(0x99282828)),
            ),
          ),
          _Sheet(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('driver.seat_layout.title'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 18.sp,
                        height: 20 / 18,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 16.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final cap in _capacities) ...[
                        _CapacityTag(
                          label: 'driver.seat_layout.capacity'
                              .tr(namedArgs: {'count': '$cap'}),
                          selected: cap == _capacity,
                          onTap: () => _selectCapacity(cap),
                        ),
                        if (cap != _capacities.last) SizedBox(width: 8.w),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.fieldFill),
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: _SeatGrid(
                    seatCount: _seatCount,
                    active: _active,
                    onToggle: _toggleSeat,
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: Text('driver.seat_layout.hint'.tr(),
                      textAlign: TextAlign.center,
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          height: 20 / 14,
                          color: AppColors.primary)),
                ),
                SizedBox(height: 16.h),
                _SheetButton(
                  label: 'driver.seat_layout.confirm'.tr(),
                  onTap: () => context.router.maybePop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Capacity chip — "N orindiqli". Filled blue when selected.
class _CapacityTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CapacityTag(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.ctaBlue : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.subtitle.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.textOnDark : AppColors.textDark)),
      ),
    );
  }
}

/// Arranges the passenger seats into the cabin layout from Figma: the driver
/// area occupies the top-left, then a single seat top-right, a centre row, and
/// a trailing centred pair — wrapped so any 3–6 seat count stays balanced.
class _SeatGrid extends StatelessWidget {
  final int seatCount;
  final Set<int> active;
  final ValueChanged<int> onToggle;
  const _SeatGrid(
      {required this.seatCount, required this.active, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    Widget seat(int i) => _SeatTile(
          active: active.contains(i),
          onTap: () => onToggle(i),
        );

    // First row: empty driver area + a single seat pulled to the right.
    final firstRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: _DriverArea()),
        SizedBox(width: 8.w),
        if (seatCount >= 1) seat(0),
      ],
    );

    // Remaining seats wrap centred, three per row.
    final rest = <Widget>[];
    for (var i = 1; i < seatCount; i++) {
      rest.add(seat(i));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        firstRow,
        if (rest.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            runSpacing: 8.h,
            children: rest,
          ),
        ],
      ],
    );
  }
}

/// The blank panel where the driver sits (top-left of the cabin).
class _DriverArea extends StatelessWidget {
  const _DriverArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 123.h,
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}

/// A single passenger chair carrying a round checkbox. Filled blue + white
/// check when active.
class _SeatTile extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _SeatTile({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 86.w,
        height: 123.h,
        child: Stack(
          children: [
            // Seat back panel.
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 86.w,
                height: 76.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(17.r),
                ),
              ),
            ),
            // Inner cushion.
            Positioned(
              top: 0,
              left: 9.w,
              child: Container(
                width: 68.w,
                height: 76.h,
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            // Seat base / front edge.
            Positioned(
              bottom: 0,
              left: 17.w,
              child: Container(
                width: 52.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            // Round checkbox.
            Positioned(
              top: 24.h,
              left: 29.w,
              child: Container(
                width: 28.r,
                height: 28.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? AppColors.ctaBlue : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: active ? AppColors.ctaBlue : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: active
                    ? Icon(Icons.check, size: 16.sp, color: AppColors.textOnDark)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White rounded-top sheet container with a drag handle, matching the
/// intercity sheet scaffolding.
class _Sheet extends StatelessWidget {
  final Widget child;
  const _Sheet({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 6,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 112.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Filled CTA button, matching the intercity sheet's confirm button.
class _SheetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SheetButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.ctaBlue,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textOnDark)),
      ),
    );
  }
}
