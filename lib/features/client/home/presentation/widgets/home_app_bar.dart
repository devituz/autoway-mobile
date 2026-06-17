import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';

/// Shared top bar: leading icon (menu or back) + notifications bell.
class HomeAppBar extends StatelessWidget {
  final VoidCallback? onLeadingTap;
  final VoidCallback? onBellTap;

  /// Leading icon — defaults to the hamburger menu; pass [Icons.arrow_back_ios_new]
  /// (e.g. on pushed screens) to show a back button instead.
  final IconData leadingIcon;

  const HomeAppBar({
    super.key,
    this.onLeadingTap,
    this.onBellTap,
    this.leadingIcon = Icons.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IconButton(icon: leadingIcon, onTap: onLeadingTap),
          _IconButton(icon: Icons.notifications_none, onTap: onBellTap),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.all(6.r),
        child: Icon(icon, size: 26.sp, color: AppColors.textPrimary),
      ),
    );
  }
}
