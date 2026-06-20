import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Cargo ("Pochta") flow — the parcel order form ("Posilka jo‘natish", Figma
/// node 2187:18210). A tall scrollable form with three white cards (route +
/// pickup/fixed-price toggles + send time, receiver contact, parcel details
/// with a photo-upload box and category chips) over a light backdrop, plus a
/// pinned dark bottom bar showing the system commission, the price field and
/// the "Yaratish" CTA. Mirrors [IntercityOrderDetailsPage].
@RoutePage()
class CargoOrderFormPage extends StatefulWidget {
  const CargoOrderFormPage({super.key});

  @override
  State<CargoOrderFormPage> createState() => _CargoOrderFormPageState();
}

class _CargoOrderFormPageState extends State<CargoOrderFormPage> {
  bool _pickup = false;
  bool _fixedPrice = false;
  int _categoryIndex = 0;

  static const _categories = [
    'cargo.cform_cat_other',
    'cargo.cform_cat_documents',
    'cargo.cform_cat_tech',
    'cargo.cform_cat_money',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.border,
      body: Column(
        children: [
          const _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(0, 4.h, 0, 16.h),
              child: Column(
                children: [
                  _RouteCard(
                    pickup: _pickup,
                    onPickup: (v) => setState(() => _pickup = v),
                    fixedPrice: _fixedPrice,
                    onFixedPrice: (v) => setState(() => _fixedPrice = v),
                  ),
                  SizedBox(height: 4.h),
                  const _ReceiverCard(),
                  SizedBox(height: 4.h),
                  _ParcelCard(
                    categories: _categories,
                    categoryIndex: _categoryIndex,
                    onCategory: (i) => setState(() => _categoryIndex = i),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

// ---------------------------------------------------------------------------
// Top bar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.router.maybePop(),
                child: SvgPicture.asset('$_icons/ia_close_circle.svg',
                    width: 32.r, height: 32.r),
              ),
              Expanded(
                child: Text(
                  'cargo.cform_title'.tr(),
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
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 1 — route + toggles + send time
// ---------------------------------------------------------------------------

class _RouteCard extends StatelessWidget {
  final bool pickup;
  final ValueChanged<bool> onPickup;
  final bool fixedPrice;
  final ValueChanged<bool> onFixedPrice;

  const _RouteCard({
    required this.pickup,
    required this.onPickup,
    required this.fixedPrice,
    required this.onFixedPrice,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route + avg price block.
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3F8),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _RouteConnector(),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            children: [
                              _RoutePoint(
                                value: 'Toshkent shahri',
                                onTap: () => context.router.push(CargoRegionPickRoute(toDestination: false)),
                              ),
                              Divider(height: 16.h, color: AppColors.border),
                              _RoutePoint(
                                value: 'Andijon shahri, Andijon viloyati',
                                onTap: () => context.router.push(CargoRegionPickRoute(toDestination: true)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('cargo.cform_avg_price'.tr(),
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp, color: AppColors.primary)),
                      Text('300.000-450.000 som',
                          style: TextStyle(
                              fontSize: 12.sp, color: AppColors.textDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Pickup | Fixed-price toggles.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('cargo.cform_pickup'.tr(),
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColors.primary)),
                  SizedBox(width: 12.w),
                  _Toggle(value: pickup, onChanged: onPickup),
                ],
              ),
              Container(width: 1, height: 24.h, color: AppColors.border),
              Row(
                children: [
                  Text('cargo.cform_fixed_price'.tr(),
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColors.primary)),
                  SizedBox(width: 12.w),
                  _Toggle(value: fixedPrice, onChanged: onFixedPrice),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(height: 1.h, color: AppColors.border),
          SizedBox(height: 16.h),
          // Send time row.
          _FieldRow(
            icon: 'ia_calendar_tick',
            title: 'cargo.cform_send_time'.tr(),
            onTap: () {}, // TODO(nav): -> CargoTimeRoute
          ),
        ],
      ),
    );
  }
}

/// The vertical location-dot → dashed line → flag connector on the left of the
/// pickup/drop-off rows.
class _RouteConnector extends StatelessWidget {
  const _RouteConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.r),
            child: SvgPicture.asset('$_icons/ia_loc_dot.svg',
                width: 20.r, height: 20.r),
          ),
          Expanded(child: _DashedLine()),
          Padding(
            padding: EdgeInsets.all(4.r),
            child: SvgPicture.asset('$_icons/ia_flag.svg',
                width: 20.r, height: 20.r),
          ),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // CustomPaint (not LayoutBuilder) so this is safe inside IntrinsicHeight.
    return CustomPaint(
      size: const Size(1.5, double.infinity),
      painter: _DashedLinePainter(),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashH = 3.0;
    const gap = 3.0;
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final x = size.width / 2;
    double y = 0;
    while (y < size.height) {
      final end = (y + dashH) > size.height ? size.height : y + dashH;
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dashH + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePoint extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  const _RoutePoint({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.input.copyWith(
                fontSize: 16.sp, color: AppColors.textDark),
          ),
        ),
        SizedBox(width: 4.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            padding:
                EdgeInsets.only(left: 12.w, right: 8.w, top: 8.h, bottom: 8.h),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('cargo.cform_select'.tr(),
                    style: TextStyle(
                        fontSize: 12.sp, color: AppColors.textDark)),
                SvgPicture.asset('$_icons/ia_chevron_right.svg',
                    width: 16.r, height: 16.r),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card 2 — receiver contact
// ---------------------------------------------------------------------------

class _ReceiverCard extends StatelessWidget {
  const _ReceiverCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: [
          _PlainInput(hint: 'cargo.cform_receiver'.tr(), filled: false),
          SizedBox(height: 16.h),
          _PlainInput(hint: '+998', filled: true),
        ],
      ),
    );
  }
}

/// A 52h grey input field placeholder. [filled] renders the value in the dark
/// text colour (e.g. the prefilled "+998"); otherwise it is a muted hint.
class _PlainInput extends StatelessWidget {
  final String hint;
  final bool filled;
  const _PlainInput({required this.hint, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        hint,
        style: TextStyle(
            fontSize: 14.sp,
            color: filled ? AppColors.textDark : AppColors.textMuted),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card 3 — parcel details
// ---------------------------------------------------------------------------

class _ParcelCard extends StatelessWidget {
  final List<String> categories;
  final int categoryIndex;
  final ValueChanged<int> onCategory;

  const _ParcelCard({
    required this.categories,
    required this.categoryIndex,
    required this.onCategory,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('cargo.cform_parcel_info'.tr(),
              style: AppText.screenTitle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark)),
          SizedBox(height: 16.h),
          // Photo upload box (dashed).
          GestureDetector(
            onTap: () {}, // TODO(nav): -> image picker
            child: Container(
              width: double.infinity,
              height: 150.h,
              padding: EdgeInsets.fromLTRB(11.w, 28.h, 11.w, 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                    color: AppColors.textSecondary,
                    style: BorderStyle.solid,
                    width: 1),
              ),
              child: Column(
                children: [
                  SvgPicture.asset('$_icons/ca_gallery_add.svg',
                      width: 48.r, height: 48.r),
                  SizedBox(height: 8.h),
                  Text('cargo.cform_upload_photo'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Labeled "what are you sending?" input.
          Container(
            height: 72.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('cargo.cform_what_sending'.tr(),
                    style: TextStyle(
                        fontSize: 10.sp, color: AppColors.textMuted)),
                SizedBox(height: 4.h),
                Text('Pasport',
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColors.textDark)),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Category chips.
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (var i = 0; i < categories.length; i++)
                _CategoryChip(
                  label: categories[i].tr(),
                  selected: categoryIndex == i,
                  onTap: () => onCategory(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(50.r),
          border:
              selected ? Border.all(color: AppColors.selectBlue, width: 1) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: selected ? AppColors.selectBlue : AppColors.textDark),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom bar — commission + price + CTA
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
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Commission row.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('$_icons/ia_discount.svg',
                        width: 20.r, height: 20.r),
                    SizedBox(width: 8.w),
                    Text('cargo.cform_commission'.tr(),
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textOnDark)),
                  ],
                ),
                Text('3 000 so’m',
                    style: TextStyle(
                        fontSize: 15.sp, color: AppColors.textOnDark)),
              ],
            ),
          ),
          // White section: price field + CTA.
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  // Price field.
                  Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.fieldFill,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Text('cargo.cform_price'.tr(),
                            style: TextStyle(
                                fontSize: 14.sp, color: AppColors.primary)),
                        const Spacer(),
                        Text('0 so‘m',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // CTA.
                  GestureDetector(
                    onTap: () => context.router.push(const CargoDriversRoute()),
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
                          Text('cargo.cform_create'.tr(),
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textOnDark)),
                          SizedBox(width: 4.w),
                          Icon(Icons.arrow_forward,
                              size: 18.sp, color: AppColors.textOnDark),
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
// Shared small widgets
// ---------------------------------------------------------------------------

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}

/// A grey field row: leading icon, title, trailing chevron. Used for the
/// send-time row.
class _FieldRow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const _FieldRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset('$_icons/$icon.svg', width: 24.r, height: 24.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(title,
                  style: AppText.input.copyWith(
                      fontSize: 16.sp, color: AppColors.textDark)),
            ),
            SvgPicture.asset('$_icons/ia_chevron_right.svg',
                width: 20.r, height: 20.r),
          ],
        ),
      ),
    );
  }
}

/// A small pill on/off switch matching the Figma "Setting On Off" component.
class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40.w,
        height: 24.h,
        padding: EdgeInsets.all(2.r),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? AppColors.selectBlue : AppColors.border,
          borderRadius: BorderRadius.circular(80.r),
        ),
        child: Container(
          width: 20.r,
          height: 20.r,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
