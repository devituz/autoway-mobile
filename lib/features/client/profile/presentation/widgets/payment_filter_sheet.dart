import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Result returned by the payment-history filter sheet.
class PaymentFilter {
  final DateTime? start;
  final DateTime? end;
  final String orderType; // localization key suffix: all | taxi | parcel
  const PaymentFilter({this.start, this.end, this.orderType = 'all'});
}

/// Opens the filter bottom sheet (Figma node 2066:14864). Returns the chosen
/// [PaymentFilter] on "Saqlash", or null on "Yopish"/dismiss.
Future<PaymentFilter?> showPaymentFilter(
  BuildContext context, {
  PaymentFilter? initial,
}) {
  return showModalBottomSheet<PaymentFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PaymentFilterSheet(initial: initial ?? const PaymentFilter()),
  );
}

class _PaymentFilterSheet extends StatefulWidget {
  final PaymentFilter initial;
  const _PaymentFilterSheet({required this.initial});

  @override
  State<_PaymentFilterSheet> createState() => _PaymentFilterSheetState();
}

class _PaymentFilterSheetState extends State<_PaymentFilterSheet> {
  late DateTime? _start = widget.initial.start ?? DateTime(2001, 1, 10);
  late DateTime? _end = widget.initial.end ?? DateTime(2001, 1, 10);
  late String _type = widget.initial.orderType;

  String _fmt(DateTime? d) {
    if (d == null) return 'kk.oo.yyyy';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}';
  }

  Future<void> _pickDate(bool start) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (start ? _start : _end) ?? DateTime(2001, 1, 10),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => start ? _start = picked : _end = picked);
    }
  }

  Future<void> _pickType() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in ['all', 'taxi', 'parcel'])
              ListTile(
                title: Text('filter.$t'.tr(),
                    style: AppText.bodyMedium
                        .copyWith(color: AppColors.textDark)),
                trailing: _type == t
                    ? Icon(Icons.check, size: 20.sp, color: AppColors.blue)
                    : null,
                onTap: () => Navigator.pop(context, t),
              ),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _type = selected);
  }

  void _reset() {
    setState(() {
      _start = DateTime(2001, 1, 10);
      _end = DateTime(2001, 1, 10);
      _type = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 112.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text('filter.title'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: 'filter.start_date'.tr(),
                      value: _fmt(_start),
                      onTap: () => _pickDate(true),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _DateField(
                      label: 'filter.end_date'.tr(),
                      value: _fmt(_end),
                      onTap: () => _pickDate(false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: _pickType,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'filter.order_type'
                              .tr(namedArgs: {'value': 'filter.$_type'.tr()}),
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp, color: AppColors.textDark),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: SvgPicture.asset('$_icons/chevron.svg',
                            width: 20.sp, height: 20.sp),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: _reset,
                    child: Container(
                      width: 48.r,
                      height: 48.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: SvgPicture.asset('$_icons/refresh.svg',
                          width: 24.sp, height: 24.sp),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SheetButton(
                      label: 'filter.close'.tr(),
                      filled: false,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SheetButton(
                      label: 'filter.save'.tr(),
                      filled: true,
                      onTap: () => Navigator.pop(
                        context,
                        PaymentFilter(start: _start, end: _end, orderType: _type),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateField(
      {required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppText.label.copyWith(
                          fontSize: 10.sp, color: AppColors.textMuted)),
                  SizedBox(height: 2.h),
                  Text(value,
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp, color: AppColors.textDark)),
                ],
              ),
            ),
            SvgPicture.asset('$_icons/calendar.svg',
                width: 20.sp, height: 20.sp),
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
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.textMuted : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: filled ? AppColors.textOnDark : AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
