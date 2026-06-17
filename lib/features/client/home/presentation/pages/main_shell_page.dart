import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import 'account_page.dart';
import 'home_page.dart';
import 'orders_page.dart';

/// App shell hosting the bottom navigation (Bosh sahifa / Buyurtmalar / Profil).
/// Tabs are kept alive via [IndexedStack] so their scroll/state persists.
@RoutePage()
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  static const _tabs = [HomePage(), OrdersPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: _BottomNav(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _BottomNav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = [
      (icon: Icons.apps, label: 'home.nav_home'.tr()),
      (icon: Icons.directions_car_outlined, label: 'home.nav_orders'.tr()),
      (icon: Icons.person_outline, label: 'home.nav_profile'.tr()),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < items.length; i++)
                _NavItem(
                  icon: items[i].icon,
                  label: items[i].label,
                  active: index == i,
                  onTap: () => onChanged(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24.sp, color: color),
            SizedBox(height: 4.h),
            Text(label,
                style: AppText.label.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
