import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';

/// Full-width dark CTA button ("Davom etish" / "Jonatish").
///
/// Pass [onPressed] = null to render the disabled state. While [loading] is
/// true the button is disabled and shows a spinner instead of the label, so a
/// network action can't be triggered twice.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.textOnDark,
          disabledBackgroundColor: AppColors.mutedButton,
          disabledForegroundColor: AppColors.textOnDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: loading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.textOnDark),
                ),
              )
            : Text(label, style: AppText.button),
      ),
    );
  }
}
