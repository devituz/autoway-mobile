import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../widgets/intercity_place_search_scaffold.dart';

/// Intercity-taxi flow — pick a district within the previously chosen region
/// (Figma node 2124:9824). Same search-list layout as
/// [IntercityRegionPickPage] but the title is the selected region name and the
/// rows are its districts (tuman). Selecting a district returns to the order
/// form ([IntercityOrderDetailsPage]).
@RoutePage()
class IntercityDistrictPickPage extends StatelessWidget {
  /// Region name shown as the title; defaults to the Figma sample.
  final String regionName;

  const IntercityDistrictPickPage({
    super.key,
    this.regionName = 'Andijon viloyati',
  });

  static const List<String> _districts = [
    'Andijon shahri',
    'Asaka tumani',
    'Buloq boshi tumani',
    'Izban tumani',
    'Korg’ontepa tumani',
    'Marhamat tumani',
    'Pahtaobod tumani',
  ];

  @override
  Widget build(BuildContext context) {
    return IntercityPlaceSearchScaffold(
      title: regionName,
      items: [
        for (final district in _districts)
          _DistrictRow(
            label: district,
            onTap: () => context.router.push(const IntercityOrderDetailsRoute()),
          ),
      ],
    );
  }
}

class _DistrictRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DistrictRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.fieldFill)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppText.input.copyWith(
                    fontSize: 16.sp, color: AppColors.textDark),
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset('assets/icons/ia_arrow_right.svg',
                width: 24.r, height: 24.r),
          ],
        ),
      ),
    );
  }
}
