import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

/// Filled text field with an optional floating label (screens 3 & 5).
class LabeledField extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> formatters;
  final String? prefixText;
  final ValueChanged<String>? onChanged;

  const LabeledField({
    super.key,
    this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.formatters = const [],
    this.prefixText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Text(
              label!,
              style: AppText.label.copyWith(color: AppColors.textSecondary),
            ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: formatters,
            onChanged: onChanged,
            style: AppText.input.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: AppText.input.copyWith(color: AppColors.textSecondary),
              prefixText: prefixText,
              prefixStyle: AppText.input.copyWith(color: AppColors.textPrimary),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
