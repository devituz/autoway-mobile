import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';
const _images = 'assets/images';

/// Intercity-taxi flow — drivers list along the chosen route
/// (Figma node 2167:10538 "Haydovchilar"). Reached after picking the
/// departure/destination on [IntercityAddressPage]; tapping a card opens the
/// driver detail page.
@RoutePage()
class IntercityDriversPage extends StatelessWidget {
  const IntercityDriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border, // Gray/20 #E2E8F0
      body: Column(
        children: [
          const _DriversHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 24.h),
              children: [
                _OfferCard(
                  featured: true,
                  avatar: 'ic_driver1',
                  name: 'Akbar Yoldoshev',
                  rating: '8.6',
                  price: '400 000 som',
                  car: 'Cobalt LTZ | Oq',
                  seats: const [
                    _SeatState.free,
                    _SeatState.man,
                    _SeatState.busy,
                    _SeatState.free,
                  ],
                ),
                SizedBox(height: 16.h),
                _OfferCard(
                  featured: true,
                  avatar: 'ic_driver2',
                  name: 'Yoldor Bahromov',
                  rating: '9.2',
                  price: '450 000 som',
                  car: 'Malibu 2 LTZ | Qora',
                  seats: const [
                    _SeatState.free,
                    _SeatState.man,
                    _SeatState.free,
                    _SeatState.free,
                  ],
                ),
                SizedBox(height: 16.h),
                _OfferCard(
                  featured: false,
                  avatar: 'ic_driver3',
                  name: 'Sardor Ismoilov',
                  rating: '7.9',
                  price: '450 000 som',
                  car: 'Tayota Camry | Oq',
                  seats: const [
                    _SeatState.woman,
                    _SeatState.man,
                    _SeatState.man,
                    _SeatState.free,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DriversHeader extends StatelessWidget {
  const _DriversHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textDark, // Gray/90 #0F172A
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x147D8184),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Title bar (white pill area).
            Container(
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(16.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.router.maybePop(),
                    child: SvgPicture.asset('$_icons/mt_back.svg',
                        width: 32.r, height: 32.r),
                  ),
                  Expanded(
                    child: Text(
                      'intercity.drivers_title'
                          .tr(namedArgs: {'count': '12'}),
                      textAlign: TextAlign.center,
                      style: AppText.screenTitle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark),
                    ),
                  ),
                  SizedBox(width: 32.r),
                ],
              ),
            ),
            // Route summary strip (dark).
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: AppText.subtitle.copyWith(
                                  fontSize: 15.sp,
                                  color: AppColors.lightGrey),
                              children: [
                                TextSpan(
                                    text: 'intercity.drivers_departure_at'.tr()),
                                TextSpan(
                                    text: '15 mart, 16:00',
                                    style: TextStyle(
                                        color: AppColors.textOnDark,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 16.h,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          color: const Color(0x33FFFFFF),
                        ),
                        Text('2x',
                            style: AppText.subtitle.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lightGrey)),
                        SizedBox(width: 2.w),
                        SvgPicture.asset('$_icons/ia_man.svg',
                            width: 24.r,
                            height: 24.r,
                            colorFilter: ColorFilter.mode(
                                AppColors.lightGrey, BlendMode.srcIn)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {}, // TODO(nav): -> edit route
                    child: SvgPicture.asset('$_icons/edit.svg',
                        width: 24.r,
                        height: 24.r,
                        colorFilter: ColorFilter.mode(
                            AppColors.textOnDark, BlendMode.srcIn)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SeatState { free, busy, man, woman }

class _OfferCard extends StatelessWidget {
  final bool featured;
  final String avatar;
  final String name;
  final String rating;
  final String price;
  final String car;
  final List<_SeatState> seats;

  const _OfferCard({
    required this.featured,
    required this.avatar,
    required this.name,
    required this.rating,
    required this.price,
    required this.car,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.router.push(const IntercityDriverDetailRoute()),
      child: Container(
        decoration: BoxDecoration(
          color: featured ? AppColors.blue : AppColors.ctaBlue,
          border: Border.all(
              color: featured ? AppColors.selectBlue : AppColors.textSecondary),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            if (featured)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('intercity.drivers_offer'.tr(),
                        style: AppText.subtitle.copyWith(
                            fontSize: 15.sp,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textOnDark)),
                    Icon(Icons.verified,
                        size: 24.r, color: AppColors.textOnDark),
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  // Time row.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('intercity.drivers_leaving_at'.tr(),
                          style: AppText.bodyMedium.copyWith(
                              fontSize: 16.sp, color: AppColors.textMuted)),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.fieldFill,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: '15 aprel, ',
                                  style: AppText.bodyMedium.copyWith(
                                      fontSize: 16.sp,
                                      color: AppColors.textMuted)),
                              TextSpan(
                                  text: '16:00',
                                  style: AppText.bodyMedium.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ctaBlue)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24.h, color: AppColors.fieldFill),
                  // Price + seats.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(price,
                                style: AppText.screenTitle.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark)),
                            SizedBox(height: 2.h),
                            Text(car,
                                style: AppText.label.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      _SeatGrid(seats: seats),
                    ],
                  ),
                  Divider(height: 24.h, color: AppColors.fieldFill),
                  // Amenities.
                  Row(
                    children: [
                      SvgPicture.asset('$_icons/ia_snow.svg',
                          width: 24.r, height: 24.r),
                      SizedBox(width: 9.w),
                      SvgPicture.asset('$_icons/ic_no_smoke.svg',
                          width: 24.r, height: 24.r),
                      SizedBox(width: 9.w),
                      SvgPicture.asset('$_icons/ib_pet.svg',
                          width: 24.r, height: 24.r),
                    ],
                  ),
                  Divider(height: 24.h, color: AppColors.fieldFill),
                  // Driver + arrow.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset('$_images/$avatar.png',
                                width: 48.r, height: 48.r, fit: BoxFit.cover),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: AppText.bodyMedium.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textDark)),
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 16.r,
                                      color: AppColors.accentYellow),
                                  SizedBox(width: 2.w),
                                  Text(rating,
                                      style: AppText.subtitle.copyWith(
                                          fontSize: 14.sp,
                                          color: AppColors.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 52.r,
                        width: 52.r,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          border: Border.all(color: AppColors.fieldFill),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: SvgPicture.asset('$_icons/ia_arrow_right.svg',
                            width: 20.r, height: 20.r),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatGrid extends StatelessWidget {
  final List<_SeatState> seats; // [driver(top-right), backLeft, backMid, backRight]
  const _SeatGrid({required this.seats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _Seat(state: seats[0]),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Seat(state: seats[1]),
              SizedBox(width: 2.w),
              _Seat(state: seats[2]),
              SizedBox(width: 2.w),
              _Seat(state: seats[3]),
            ],
          ),
        ],
      ),
    );
  }
}

class _Seat extends StatelessWidget {
  final _SeatState state;
  const _Seat({required this.state});

  @override
  Widget build(BuildContext context) {
    final bool free = state == _SeatState.free;
    return Container(
      width: 24.r,
      height: 24.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Success/50 #22C55E (closest existing token).
        color: free ? AppColors.statusGreen : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: switch (state) {
        _SeatState.man => SvgPicture.asset('$_icons/ia_man.svg',
            width: 14.r,
            height: 14.r,
            colorFilter:
                ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn)),
        _SeatState.woman => SvgPicture.asset('$_icons/ia_woman.svg',
            width: 14.r,
            height: 14.r,
            colorFilter:
                ColorFilter.mode(AppColors.textMuted, BlendMode.srcIn)),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
