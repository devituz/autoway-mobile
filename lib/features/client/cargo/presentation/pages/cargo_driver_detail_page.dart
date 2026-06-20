import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../domain/cargo_status.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';
const _images = 'assets/images';

/// Cargo (Pochta) flow — courier detail / booking sheet
/// (Figma node 2187:21632 "Haydovchi_View_Recomendation"). A slide-up sheet
/// over a dark backdrop: a blue "Manzildan olib ketiladi" banner, the courier
/// card (parcel price, route, fuel/reviews), a "Qo'shimchalar" extras card,
/// and a dark bottom bar (system commission + price + "Bron qilish").
@RoutePage()
class CargoDriverDetailPage extends StatelessWidget {
  const CargoDriverDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 25.h),
          // Drag handle.
          Container(
            width: 112.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(60.r),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Column(
                children: [
                  // Blue banner.
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF3B82F6), // Blue/50
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('cargo.cdriverview_pickup_from'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 15.sp,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textOnDark)),
                        SvgPicture.asset('$_icons/cb_truck.svg',
                            width: 24.r, height: 24.r),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: AppColors.border,
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
                        children: const [
                          _CourierCard(),
                          SizedBox(height: 8),
                          _ExtrasCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _BottomBar(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 1 — courier info
// ---------------------------------------------------------------------------
class _CourierCard extends StatelessWidget {
  const _CourierCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      gap: 12.h,
      children: [
        // Driver header.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset('$_images/ic_driver1.png',
                      width: 48.r, height: 48.r, fit: BoxFit.cover),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Akbar Yoldoshev',
                        style: AppText.bodyMedium.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark)),
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: 16.r, color: AppColors.accentYellow),
                        SizedBox(width: 2.w),
                        Text('8.6',
                            style: AppText.subtitle.copyWith(
                                fontSize: 14.sp, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.router.maybePop(),
              child: Container(
                width: 52.r,
                height: 52.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: SvgPicture.asset('$_icons/od_close.svg',
                    width: 20.r, height: 20.r),
              ),
            ),
          ],
        ),
        const _ThinDivider(),
        _InfoRow(
            label: 'cargo.cdriverview_parcel_price'.tr(), value: '60 000 som'),
        _InfoRow(
          label: 'cargo.cdriverview_leaving_at'.tr(),
          valueSpans: [
            TextSpan(
                text: '15 aprel, ',
                style: TextStyle(color: AppColors.textMuted)),
            const TextSpan(text: '16:00'),
          ],
        ),
        const _ThinDivider(),
        // Plate + car + photos.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('01 B 125 YC',
                      style: AppText.screenTitle.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                  Text('Cobalt LTZ | Oq',
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp, color: AppColors.textMuted)),
                ],
              ),
            ),
            const _CarPhotos(),
          ],
        ),
        // Route.
        const _RouteCard(),
        // Driver location button.
        Container(
          width: double.infinity,
          height: 48.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: AppColors.fieldFill),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('$_icons/od_gps.svg',
                  width: 20.r, height: 20.r),
              SizedBox(width: 12.w),
              Text('cargo.cdriverview_driver_location'.tr(),
                  style: AppText.bodyMedium.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark)),
            ],
          ),
        ),
        // Fuel + reviews.
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.fieldFill)),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  SvgPicture.asset('$_icons/c_flash.svg',
                      width: 24.r,
                      height: 24.r,
                      colorFilter: ColorFilter.mode(
                          AppColors.textMuted, BlendMode.srcIn)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text('cargo.cdriverview_fuel'.tr(),
                        style: AppText.subtitle.copyWith(
                            fontSize: 14.sp, color: AppColors.textMuted)),
                  ),
                  Text('cargo.cdriverview_fuel_methane'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark)),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {}, // TODO(nav): -> reviews
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    SvgPicture.asset('$_icons/messages.svg',
                        width: 24.r,
                        height: 24.r,
                        colorFilter: ColorFilter.mode(
                            AppColors.textMuted, BlendMode.srcIn)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text('cargo.cdriverview_reviews'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp, color: AppColors.textMuted)),
                    ),
                    SvgPicture.asset('$_icons/ia_arrow_right.svg',
                        width: 20.r, height: 20.r),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CarPhotos extends StatelessWidget {
  const _CarPhotos();

  Widget _photo(String name) => Container(
        width: 100.w,
        height: 80.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accent, width: 3),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
                color: const Color(0x14000000),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Image.asset('$_images/$name.png', fit: BoxFit.cover),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138.w,
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 0, child: _photo('ic_car1')),
          Positioned(left: 19.w, child: _photo('ic_car2')),
          Positioned(left: 38.w, child: _photo('ic_car3')),
          Positioned(
            right: 0,
            top: 30.h,
            child: SvgPicture.asset('$_icons/ia_search.svg',
                width: 20.r, height: 20.r),
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(8.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Connector.
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.r),
                    child: SvgPicture.asset('$_icons/mt_location.svg',
                        width: 20.r, height: 20.r),
                  ),
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: AppColors.lightGrey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.r),
                    child: SvgPicture.asset('$_icons/mt_flag.svg',
                        width: 20.r, height: 20.r),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  children: [
                    _routeRow('Toshkent shahri'),
                    Divider(height: 16.h, color: AppColors.fieldFill),
                    _routeRow('Andijon shahri, Andijon viloyati'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routeRow(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyMedium.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.36,
                  color: AppColors.textDark)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card 2 — extras
// ---------------------------------------------------------------------------
class _ExtrasCard extends StatelessWidget {
  const _ExtrasCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      gap: 12.h,
      children: [
        Text('cargo.cdriverview_extras'.tr(),
            style: AppText.screenTitle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 20 / 18,
                color: AppColors.textDark)),
        _ExtraRow(
          icon: 'c_box',
          label: 'cargo.cdriverview_extra_roof_box'.tr(),
          checked: true,
        ),
      ],
    );
  }
}

class _ExtraRow extends StatelessWidget {
  final String icon;
  final String label;
  final bool checked;
  const _ExtraRow(
      {required this.icon, required this.label, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.fieldFill)),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          SvgPicture.asset('$_icons/$icon.svg',
              width: 24.r,
              height: 24.r,
              colorFilter:
                  ColorFilter.mode(AppColors.textDark, BlendMode.srcIn)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(label,
                style: AppText.subtitle.copyWith(
                    fontSize: 14.sp, color: AppColors.textDark)),
          ),
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
                checked ? '$_icons/check.svg' : '$_icons/ia_minus.svg',
                width: checked ? 12.r : 14.r,
                height: checked ? 12.r : 14.r,
                colorFilter: checked
                    ? ColorFilter.mode(AppColors.selectBlue, BlendMode.srcIn)
                    : ColorFilter.mode(AppColors.logoutRed, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar
// ---------------------------------------------------------------------------
class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 12,
              offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Commission.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                SvgPicture.asset('$_icons/ia_discount.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: ColorFilter.mode(
                        AppColors.textOnDark, BlendMode.srcIn)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text('cargo.cdriverview_commission'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textOnDark)),
                ),
                Text('3 000 ${'cargo.cdriverview_currency'.tr()}',
                    style: AppText.subtitle.copyWith(
                        fontSize: 15.sp, color: AppColors.textOnDark)),
              ],
            ),
          ),
          // White footer (price + CTA).
          Container(
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            padding: EdgeInsets.all(16.r),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Price.
                  Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.fieldFill,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('cargo.cdriverview_price'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 14.sp,
                                height: 16 / 14,
                                color: AppColors.textPrimary)),
                        Text('60 000 ${'cargo.cdriverview_currency'.tr()}',
                            style: AppText.screenTitle.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // CTA.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.router.push(CargoStatusRoute(status: CargoStatus.awaiting)),
                    child: Container(
                      height: 48.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.mutedButton, // Gray/50 #64748B
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('cargo.cdriverview_book'.tr(),
                              style: AppText.subtitle.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnDark)),
                          SizedBox(width: 4.w),
                          SvgPicture.asset('$_icons/ia_arrow_right_w.svg',
                              width: 20.r, height: 20.r),
                        ],
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

// ---------------------------------------------------------------------------
// Shared bits
// ---------------------------------------------------------------------------
class _WhiteCard extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  const _WhiteCard({required this.children, required this.gap});

  @override
  Widget build(BuildContext context) {
    final spaced = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) spaced.add(SizedBox(height: gap));
    }
    return Container(
      color: AppColors.accent,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: spaced,
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.fieldFill);
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<InlineSpan>? valueSpans;
  const _InfoRow({required this.label, this.value, this.valueSpans});

  @override
  Widget build(BuildContext context) {
    final valueStyle = AppText.screenTitle.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp, color: AppColors.textDark)),
        if (valueSpans != null)
          RichText(text: TextSpan(style: valueStyle, children: valueSpans))
        else
          Text(value!, style: valueStyle),
      ],
    );
  }
}
