import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Floating, rounded snackbars with a leading icon — used for auth/network
/// feedback so errors and successes read consistently across the app.
class AppSnackbar {
  AppSnackbar._();

  static void error(BuildContext context, String message) =>
      _show(context, message, AppColors.logoutRed, Icons.error_outline);

  static void success(BuildContext context, String message) =>
      _show(context, message, AppColors.creditGreen, Icons.check_circle_outline);

  static void _show(
      BuildContext context, String message, Color color, IconData icon) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          elevation: 0,
          margin: EdgeInsets.all(16.w),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          content: Row(
            children: [
              Icon(icon, color: AppColors.textOnDark, size: 22.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(message,
                    style: AppText.subtitle.copyWith(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      );
  }
}
