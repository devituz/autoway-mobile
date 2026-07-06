import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Which end of the route is currently being picked on the list states.
enum _Picking { from, to }

/// The step of the create-route flow.
enum _Step {
  /// Map view + bottom pickup/drop-off card (Figma node 2232:11349).
  map,

  /// Region (viloyat) list — "Qayerdan" / "Qayerga" (node 2232:11400).
  region,

  /// District (tuman/shahar) list inside the chosen region (node 2232:11419).
  district,
}

/// Driver — "Marshrut yaratish" (Create route). A self-contained 3-state flow:
///
///  1. [_Step.map]      map preview with a from/to card and "Davom etish".
///  2. [_Step.region]   region picker (search + "Karta" toggle + viloyat list).
///  3. [_Step.district] district picker for the chosen region.
///
/// All data is static placeholder; no backend. State is local so the user can
/// walk the states and step back. The map is a styled placeholder (no map SDK
/// here) faithful to the framed layout.
@RoutePage()
class CreateRoutePage extends StatefulWidget {
  const CreateRoutePage({super.key});

  @override
  State<CreateRoutePage> createState() => _CreateRoutePageState();
}

class _CreateRoutePageState extends State<CreateRoutePage> {
  _Step _step = _Step.map;
  _Picking _picking = _Picking.from;

  // Selected labels for the from/to card. Null => not chosen yet.
  String? _fromRegion;
  String? _fromDistrict;
  String? _toRegion;
  String? _toDistrict;

  // Region currently expanded into its district list.
  String _activeRegion = '';

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

  // Static placeholder districts per region (only a couple are populated;
  // others fall back to a generic set so the list state always renders).
  static const Map<String, List<String>> _districts = {
    'Andijon viloyati': [
      'Andijon shahri',
      'Asaka tumani',
      'Buloq boshi tumani',
      'Izboskan tumani',
      'Qo‘rg‘ontepa tumani',
      'Marhamat tumani',
      'Paxtaobod tumani',
    ],
  };

  static const List<String> _fallbackDistricts = [
    'Markaz shahri',
    'Shimoliy tumani',
    'Janubiy tumani',
    'Sharqiy tumani',
    'G‘arbiy tumani',
  ];

  String _label(String? region, String? district) {
    if (region == null) return '';
    if (district == null) return region;
    return '$region, $district';
  }

  void _openRegionPicker(_Picking which) {
    setState(() {
      _picking = which;
      _step = _Step.region;
    });
  }

  void _onRegionTap(String region) {
    setState(() {
      _activeRegion = region;
      _step = _Step.district;
    });
  }

  void _onDistrictTap(String district) {
    setState(() {
      if (_picking == _Picking.from) {
        _fromRegion = _activeRegion;
        _fromDistrict = district;
      } else {
        _toRegion = _activeRegion;
        _toDistrict = district;
      }
      _step = _Step.map;
    });
  }

  /// Single back affordance — steps back within the flow, else pops the route.
  void _onBack() {
    switch (_step) {
      case _Step.district:
        setState(() => _step = _Step.region);
      case _Step.region:
        setState(() => _step = _Step.map);
      case _Step.map:
        context.router.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case _Step.map:
        return _MapState(
          fromLabel: _label(_fromRegion, _fromDistrict),
          toLabel: _label(_toRegion, _toDistrict),
          onBack: _onBack,
          onPickFrom: () => _openRegionPicker(_Picking.from),
          onPickTo: () => _openRegionPicker(_Picking.to),
          onSave: () {
            // TODO(nav): pop back to DriverRoutesRoute
            context.router.maybePop();
          },
        );
      case _Step.region:
        return _ListState(
          title: _picking == _Picking.from
              ? 'driver.create_route.from_title'.tr()
              : 'driver.create_route.to_title'.tr(),
          items: _regions,
          onBack: _onBack,
          onItemTap: _onRegionTap,
        );
      case _Step.district:
        return _ListState(
          title: _activeRegion,
          items: _districts[_activeRegion] ?? _fallbackDistricts,
          onBack: _onBack,
          onItemTap: _onDistrictTap,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// State 1 — map + bottom from/to card (node 2232:11349)
// ---------------------------------------------------------------------------

class _MapState extends StatelessWidget {
  final String fromLabel;
  final String toLabel;
  final VoidCallback onBack;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSave;

  const _MapState({
    required this.fromLabel,
    required this.toLabel,
    required this.onBack,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Stack(
        children: [
          // Map placeholder.
          const Positioned.fill(child: ColoredBox(color: Color(0xFFE7ECF1))),
          // Top white-to-transparent gradient under the header.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 173.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
          // "Manzilingiz:" current address label.
          Positioned(
            top: 116.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'driver.create_route.your_location'.tr(),
                  textAlign: TextAlign.center,
                  style: AppText.label
                      .copyWith(fontSize: 12.sp, color: AppColors.textDark),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Toshkent shahri, Abdulla Qodiriy 33',
                  textAlign: TextAlign.center,
                  style: AppText.input.copyWith(
                      fontSize: 15.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Center pin marker.
          Align(
            alignment: const Alignment(0, -0.18),
            child: SvgPicture.asset('$_icons/mt_pin.svg',
                width: 40.r, height: 40.r),
          ),
          // "Locate me" FAB above the sheet.
          Positioned(
            right: 16.w,
            bottom: 246.h,
            child: _MapFab(icon: 'mt_locate', onTap: () {}),
          ),
          // Header (back + title + save).
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MapFab(icon: 'mt_back', onTap: onBack),
                  Text(
                    'driver.create_route.title'.tr(),
                    style: AppText.subtitle.copyWith(
                        fontSize: 15.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600),
                  ),
                  _MapFab(icon: 'check', onTap: onSave),
                ],
              ),
            ),
          ),
          // Bottom from/to card + continue button.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x147D8184),
                      blurRadius: 6,
                      offset: const Offset(0, -4)),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.fieldFill,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          children: [
                            _EndpointRow(
                              icon: 'mt_location',
                              hint: 'driver.create_route.from'.tr(),
                              value: fromLabel.isEmpty
                                  ? 'driver.create_route.from_empty'.tr()
                                  : fromLabel,
                              onTap: onPickFrom,
                            ),
                            Container(
                              height: 1,
                              color: AppColors.border,
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                            ),
                            _EndpointRow(
                              icon: 'mt_flag',
                              hint: 'driver.create_route.to'.tr(),
                              value: toLabel.isEmpty
                                  ? 'driver.create_route.to_empty'.tr()
                                  : toLabel,
                              onTap: onPickTo,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _ContinueButton(onTap: onSave),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapFab extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _MapFab({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 48.r,
        height: 48.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: const Color(0x14000000),
                blurRadius: 6,
                offset: const Offset(0, 4)),
          ],
        ),
        child: SvgPicture.asset('$_icons/$icon.svg',
            width: 24.r, height: 24.r),
      ),
    );
  }
}

class _EndpointRow extends StatelessWidget {
  final String icon;
  final String hint;
  final String value;
  final VoidCallback onTap;

  const _EndpointRow({
    required this.icon,
    required this.hint,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(4.r),
            child: SvgPicture.asset('$_icons/$icon.svg',
                width: 20.r, height: 20.r),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hint,
                  style: AppText.label
                      .copyWith(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.input.copyWith(
                      fontSize: 15.sp, color: AppColors.textDark),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Text(
                  'driver.create_route.select'.tr(),
                  style: AppText.label
                      .copyWith(fontSize: 12.sp, color: AppColors.selectBlue),
                ),
                SvgPicture.asset('$_icons/ia_chevron_right.svg',
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                        AppColors.selectBlue, BlendMode.srcIn)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ContinueButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.ctaBlue,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'driver.create_route.continue'.tr(),
              style: AppText.button.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset('$_icons/ia_chevron_right.svg',
                width: 20.r,
                height: 20.r,
                colorFilter: const ColorFilter.mode(
                    AppColors.textOnDark, BlendMode.srcIn)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// States 2 & 3 — region / district list (nodes 2232:11400 & 2232:11419)
// ---------------------------------------------------------------------------

class _ListState extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback onBack;
  final ValueChanged<String> onItemTap;

  const _ListState({
    required this.title,
    required this.items,
    required this.onBack,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          // Header.
          Container(
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(16.r)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x147D8184),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onBack,
                      child: SvgPicture.asset('$_icons/mt_back.svg',
                          width: 32.r, height: 32.r),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppText.subtitle.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 32.r),
                  ],
                ),
              ),
            ),
          ),
          // White list sheet with search bar pinned on top.
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 16.h, 0, 0),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SearchBar(),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      itemBuilder: (context, i) => _PlaceRow(
                        label: items[i],
                        onTap: () => onItemTap(items[i]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset('$_icons/ia_search.svg',
              width: 24.r, height: 24.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'driver.create_route.search'.tr(),
              style: AppText.input.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.textDark,
              borderRadius: BorderRadius.circular(80.r),
            ),
            child: Row(
              children: [
                Text(
                  'driver.create_route.map'.tr(),
                  style: AppText.label.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textOnDark,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 4.w),
                SvgPicture.asset('$_icons/mt_location.svg',
                    width: 16.r,
                    height: 16.r,
                    colorFilter: const ColorFilter.mode(
                        AppColors.textOnDark, BlendMode.srcIn)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PlaceRow({required this.label, required this.onTap});

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
                    fontSize: 16.sp,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset('$_icons/ia_chevron_right.svg',
                width: 24.r, height: 24.r),
          ],
        ),
      ),
    );
  }
}
