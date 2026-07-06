import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Vehicle add/edit form (Avto o'zgartirish) — Figma node 2232:11856.
/// Reached from the driver Transports screen. Static; no backend.
@RoutePage()
class EditVehiclePage extends StatefulWidget {
  const EditVehiclePage({super.key});

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  // Static selections to demonstrate the design states.
  int _seatCount = 4; // 4 / 5 / 6 / 7
  final Set<String> _options = {'ac', 'no_smoke'};

  void _save() {
    // TODO(nav): pop back to TransportsRoute
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                children: [
                  _buildInfoCard(),
                  SizedBox(height: 4.h),
                  _buildPhotosCard(),
                  SizedBox(height: 4.h),
                  _buildSeatsCard(),
                  SizedBox(height: 4.h),
                  _buildExtrasCard(),
                ],
              ),
            ),
          ),
          _BottomBar(
            onClose: () => context.router.maybePop(),
            onSave: _save,
          ),
        ],
      ),
    );
  }

  // ----- Profil malumotlari -----
  Widget _buildInfoCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('driver.edit_vehicle.info_section'.tr()),
          SizedBox(height: 16.h),
          _DropdownField(
            label: 'driver.edit_vehicle.type'.tr(),
            value: 'Sedan',
            onTap: () {},
          ),
          SizedBox(height: 8.h),
          _DropdownField(
            label: 'driver.edit_vehicle.brand'.tr(),
            value: 'Chevrolet',
            onTap: () {},
          ),
          SizedBox(height: 8.h),
          _DropdownField(
            label: 'driver.edit_vehicle.model'.tr(),
            value: 'Cobalt',
            onTap: () {},
          ),
          SizedBox(height: 8.h),
          _DropdownField(
            label: 'driver.edit_vehicle.color'.tr(),
            value: 'driver.edit_vehicle.color_white'.tr(),
            onTap: () {},
          ),
          SizedBox(height: 8.h),
          _DropdownField(
            label: 'driver.edit_vehicle.fuel'.tr(),
            value: 'driver.edit_vehicle.fuel_petrol'.tr(),
            onTap: () {},
          ),
          SizedBox(height: 8.h),
          _PlateField(value: '01 X 123 XX'),
        ],
      ),
    );
  }

  // ----- Rasmlarni yuklang -----
  Widget _buildPhotosCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('driver.edit_vehicle.photos_section'.tr()),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _PhotoSlot(
                  caption: 'driver.edit_vehicle.photo_left'.tr(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _PhotoSlot(
                  caption: 'driver.edit_vehicle.photo_right'.tr(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _PhotoSlot(
                  caption: 'driver.edit_vehicle.photo_front_seats'.tr(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _PhotoSlot(
                  caption: 'driver.edit_vehicle.photo_back_seats'.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----- Orindiqlar tuzilmasi -----
  Widget _buildSeatsCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('driver.edit_vehicle.seats_section'.tr()),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final count in const [4, 5, 6, 7]) ...[
                  _SeatCountTag(
                    label: 'driver.edit_vehicle.seat_count'
                        .tr(namedArgs: {'n': '$count'}),
                    selected: _seatCount == count,
                    onTap: () => setState(() => _seatCount = count),
                  ),
                  if (count != 7) SizedBox(width: 8.w),
                ],
              ],
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.router.push(const SeatLayoutRoute()),
            child: const _SeatLayoutPreview(),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              'driver.edit_vehicle.seats_hint'.tr(),
              style: AppText.subtitle
                  .copyWith(fontSize: 14.sp, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  // ----- Qo'shimcha -----
  Widget _buildExtrasCard() {
    final extras = <_ExtraData>[
      const _ExtraData('order_for_other', 'ib_personalcard', icon: false),
      const _ExtraData('ac', 'ia_snow'),
      const _ExtraData('no_smoke', 'ic_no_smoke'),
      const _ExtraData('pets', 'ib_pet'),
      const _ExtraData('music', 'ib_music'),
      const _ExtraData('silence', 'ib_pause_circle'),
    ];
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('driver.edit_vehicle.extras_section'.tr()),
          SizedBox(height: 8.h),
          for (var i = 0; i < extras.length; i++)
            _ExtraRow(
              data: extras[i],
              selected: _options.contains(extras[i].id),
              divider: i != extras.length - 1,
              onTap: () => setState(() {
                if (!_options.add(extras[i].id)) _options.remove(extras[i].id);
              }),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: AppText.subtitle.copyWith(
            fontSize: 18.sp,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600));
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
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
                onTap: () => context.router.maybePop(),
                child: SvgPicture.asset('$_icons/mt_back.svg',
                    width: 32.sp, height: 32.sp),
              ),
              Expanded(
                child: Text(
                  'driver.edit_vehicle.title'.tr(),
                  textAlign: TextAlign.center,
                  style: AppText.subtitle.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Icon(Icons.delete_outline,
                    size: 28.sp, color: AppColors.logoutRed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}

/// Label-inside field with a trailing chevron (acts as a selector dropdown).
class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _DropdownField(
      {required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppText.label.copyWith(
                          fontSize: 10.sp, color: AppColors.textMuted)),
                  SizedBox(height: 2.h),
                  Text(value,
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp, color: AppColors.textDark)),
                ],
              ),
            ),
            SvgPicture.asset('$_icons/chevron.svg',
                width: 20.sp, height: 20.sp),
          ],
        ),
      ),
    );
  }
}

/// Plate-number field: label inside, no trailing chevron.
class _PlateField extends StatelessWidget {
  final String value;
  const _PlateField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('driver.edit_vehicle.plate'.tr(),
              style: AppText.label
                  .copyWith(fontSize: 10.sp, color: AppColors.textMuted)),
          SizedBox(height: 2.h),
          Text(value,
              style: AppText.subtitle
                  .copyWith(fontSize: 14.sp, color: AppColors.textDark)),
        ],
      ),
    );
  }
}

/// Dashed upload box (175x128 in Figma) with a centered add icon and a caption.
class _PhotoSlot extends StatelessWidget {
  final String caption;
  const _PhotoSlot({required this.caption});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Column(
        children: [
          CustomPaint(
            painter: _DashedBoxPainter(
              color: AppColors.textSecondary,
              radius: 20.r,
            ),
            child: Container(
              height: 128.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.softGrey,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: SvgPicture.asset('$_icons/add_photo.svg',
                  width: 48.sp, height: 48.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(caption,
              textAlign: TextAlign.center,
              style: AppText.label
                  .copyWith(fontSize: 10.sp, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _SeatCountTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SeatCountTag(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.ctaBlue : AppColors.softGrey,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 13.sp,
                color: selected ? AppColors.textOnDark : AppColors.textDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

/// Static seat-layout preview: 1 driver seat on top + a 3-seat row below,
/// inside a rounded #F1F5F9-bordered container.
class _SeatLayoutPreview extends StatelessWidget {
  const _SeatLayoutPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppColors.fieldFill),
      ),
      child: Column(
        children: [
          // Driver seat aligned to the right.
          const Align(
            alignment: Alignment.centerRight,
            child: _Seat(),
          ),
          SizedBox(height: 8.h),
          // Passenger row.
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Seat(),
              SizedBox(width: 8),
              _Seat(),
              SizedBox(width: 8),
              _Seat(),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single seat tile (stacked rounded rectangles + a circular checkbox).
class _Seat extends StatelessWidget {
  const _Seat();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86.w,
      height: 100.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Back rest.
          Positioned(
            top: 0,
            child: Container(
              width: 86.w,
              height: 76.h,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(17.r),
                border: Border.all(color: AppColors.grey.withValues(alpha: .3)),
              ),
            ),
          ),
          // Seat base.
          Positioned(
            top: 65.h,
            child: Container(
              width: 52.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.grey.withValues(alpha: .3)),
              ),
            ),
          ),
          // Unchecked selector.
          Positioned(
            top: 24.h,
            child: Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textSecondary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtraData {
  final String id;
  final String asset;

  /// Whether [asset] is an icon (vs. a generic glyph). All current extras use
  /// SVG assets; kept for clarity / future-proofing.
  final bool icon;
  const _ExtraData(this.id, this.asset, {this.icon = true});
}

class _ExtraRow extends StatelessWidget {
  final _ExtraData data;
  final bool selected;
  final bool divider;
  final VoidCallback onTap;
  const _ExtraRow({
    required this.data,
    required this.selected,
    required this.divider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: divider
            ? const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.fieldFill)),
              )
            : null,
        child: Row(
          children: [
            SvgPicture.asset('$_icons/${data.asset}.svg',
                width: 24.sp, height: 24.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'driver.edit_vehicle.extra_${data.id}'.tr(),
                style: AppText.subtitle
                    .copyWith(fontSize: 14.sp, color: AppColors.textDark),
              ),
            ),
            _Checkbox(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  final bool selected;
  const _Checkbox({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.ctaBlue : AppColors.accent,
        shape: BoxShape.circle,
        border: selected
            ? null
            : Border.all(color: AppColors.lightGrey, width: 2),
      ),
      child: selected
          ? SvgPicture.asset('$_icons/check.svg',
              width: 14.sp,
              height: 14.sp,
              colorFilter: const ColorFilter.mode(
                  AppColors.textOnDark, BlendMode.srcIn))
          : null,
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;
  const _BottomBar({required this.onClose, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
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
          child: Row(
            children: [
              Expanded(
                child: _BarButton(
                  label: 'driver.edit_vehicle.close'.tr(),
                  background: AppColors.fieldFill,
                  textColor: AppColors.textDark,
                  onTap: onClose,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _BarButton(
                  label: 'driver.edit_vehicle.save'.tr(),
                  background: AppColors.ctaBlue,
                  textColor: AppColors.textOnDark,
                  onTap: onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;
  final VoidCallback onTap;
  const _BarButton({
    required this.label,
    required this.background,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: textColor,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle border (Flutter has no native dashed
/// border). Mirrors the Figma dashed upload boxes.
class _DashedBoxPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedBoxPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dashWidth = 6.0;
    const dashGap = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBoxPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
