import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

/// Opens the change-phone bottom sheet (Figma node 2232:24112). Returns the
/// entered phone digits on "Davom etish", or null on "Yopish"/dismiss.
Future<String?> showChangePhoneSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChangePhoneSheet(),
  );
}

class _ChangePhoneSheet extends StatefulWidget {
  const _ChangePhoneSheet();

  @override
  State<_ChangePhoneSheet> createState() => _ChangePhoneSheetState();
}

class _ChangePhoneSheetState extends State<_ChangePhoneSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              Text('change_phone.title'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 6.h),
              Text('change_phone.subtitle'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 14.sp, color: AppColors.textMuted)),
              SizedBox(height: 16.h),
              Container(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Text('+998 ',
                        style: AppText.subtitle.copyWith(
                            fontSize: 14.sp, color: AppColors.textDark)),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ],
                        style: AppText.subtitle.copyWith(
                            fontSize: 14.sp, color: AppColors.textDark),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          hintText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 190.w,
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.fieldFill,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text('change_phone.send_code'.tr(),
                        style: AppText.subtitle.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _SheetButton(
                      label: 'change_phone.close'.tr(),
                      filled: false,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SheetButton(
                      label: 'change_phone.continue'.tr(),
                      filled: true,
                      onTap: () => Navigator.pop(context, _controller.text),
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
          color: filled ? AppColors.mutedButton : AppColors.fieldFill,
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
