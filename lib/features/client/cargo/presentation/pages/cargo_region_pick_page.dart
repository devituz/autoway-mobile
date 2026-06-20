import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../widgets/cargo_place_search_scaffold.dart';

/// Cargo ("Pochta") flow — pick the departure region ("Qayerdan", Figma node
/// 2187:17903). A white sheet with a search field + "Karta" (map) toggle and a
/// scrollable list of regions (viloyat). Selecting a region opens the district
/// list ([CargoDistrictPickPage]). Mirrors [IntercityRegionPickPage].
@RoutePage()
class CargoRegionPickPage extends StatelessWidget {
  /// Whether this picker selects the destination ("Qayerga") instead of the
  /// departure ("Qayerdan"). Drives the title and is forwarded to the district
  /// picker so the whole branch stays consistent.
  final bool toDestination;

  const CargoRegionPickPage({super.key, this.toDestination = false});

  static const List<String> _regions = [
    'Toshkent shahri',
    'Andijon viloyati',
    'Buxoro viloyati',
    'Samarqand viloyati',
    'Sirdaryo viloyati',
    'Navoiy viloyati',
    'Namangan viloyati',
    'Jizzax viloyati',
    'Qoraqalpog‘iston Respublikasi',
  ];

  @override
  Widget build(BuildContext context) {
    return CargoPlaceSearchScaffold(
      title:
          (toDestination ? 'cargo.caddr_to_title' : 'cargo.caddr_from_title')
              .tr(),
      items: [
        for (final region in _regions)
          _RegionRow(
            label: region,
            onTap: () => context.router.push(CargoDistrictPickRoute(regionName: region)),
          ),
      ],
    );
  }
}

class _RegionRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _RegionRow({required this.label, required this.onTap});

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
