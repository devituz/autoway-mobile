import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

/// Intercity-taxi flow — "Ketish vaqti" departure-time picker (Figma node
/// 2113:7824). Shown as a real modal bottom sheet.
Future<void> showIntercityTimeSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99282828),
    builder: (_) => const _TimeSheetBody(),
  );
}

class _TimeSheetBody extends StatefulWidget {
  const _TimeSheetBody();

  @override
  State<_TimeSheetBody> createState() => _TimeSheetBodyState();
}

class _TimeSheetBodyState extends State<_TimeSheetBody> {
  int _dayTab = 0;
  int _slot = 2;

  static const _slots = <_TimeSlot>[
    _TimeSlot('14:00'),
    _TimeSlot('14:30'),
    _TimeSlot('15:00', count: 2),
    _TimeSlot('15:30', count: 1),
    _TimeSlot('16:00'),
    _TimeSlot('16:30'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Sheet(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('intercity.time_title'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 18.sp,
                          height: 20 / 18,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 16.h),
                  _DayTabs(
                    index: _dayTab,
                    onChanged: (i) => setState(() => _dayTab = i),
                  ),
                  SizedBox(height: 16.h),
                  Text('intercity.time_leaving_cars'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          height: 16 / 14,
                          color: AppColors.primary)),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 214.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _slots.length,
                      separatorBuilder: (_, _) => SizedBox(width: 8.w),
                      itemBuilder: (_, i) => _SlotColumn(
                        slot: _slots[i],
                        selected: i == _slot,
                        onTap: () => setState(() => _slot = i),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text('intercity.time_departure_window'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          height: 20 / 14,
                          color: AppColors.textMuted)),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetButton(
                          label: 'intercity.time_close'.tr(),
                          filled: false,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _SheetButton(
                          label: 'intercity.time_continue'.tr(),
                          filled: true,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ],
      ),
    );
  }
}

class _TimeSlot {
  final String label;
  final int count;
  const _TimeSlot(this.label, {this.count = 0});
}

class _DayTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _DayTabs({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final labels = [
      'intercity.time_today'.tr(),
      'intercity.time_tomorrow'.tr(),
      'intercity.time_pick_date'.tr(),
    ];
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == index ? AppColors.ctaBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    labels[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.subtitle.copyWith(
                        fontSize: 16.sp,
                        height: 24 / 16,
                        fontWeight: FontWeight.w500,
                        color:
                            i == index ? AppColors.textOnDark : AppColors.textMuted),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SlotColumn extends StatelessWidget {
  final _TimeSlot slot;
  final bool selected;
  final VoidCallback onTap;
  const _SlotColumn(
      {required this.slot, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color barColor = selected ? AppColors.ctaBlue : AppColors.fieldFill;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 72.w,
        child: Column(
          children: [
            SizedBox(
              height: 170.h,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const SizedBox.expand(),
                  ),
                  if (slot.count > 0)
                    Container(
                      width: 32.r,
                      height: 32.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.brand30 : AppColors.textMuted,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Text('${slot.count}',
                          style: AppText.subtitle.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textOnDark)),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(slot.label,
                style: AppText.subtitle.copyWith(
                    fontSize: 14.sp,
                    height: 20 / 14,
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

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

class _SheetButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _SheetButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.ctaBlue : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: filled ? AppColors.textOnDark : AppColors.textDark)),
      ),
    );
  }
}
