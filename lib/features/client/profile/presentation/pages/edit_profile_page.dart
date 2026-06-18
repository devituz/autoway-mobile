import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Edit profile (Profil o'zgartirish) — Figma node 2066:14771.
@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const _otpLength = 4;
  static const _resendSeconds = 59;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _otpControllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(_otpLength, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 0;

  bool _isMale = true;
  DateTime _birth = DateTime(2001, 1, 10);

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _name.dispose();
    _phone.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day.$month.${d.year}';
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _birth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldFill,
      body: Column(
        children: [
          _Header(title: 'edit.title'.tr()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
              child: Column(
                children: [
                  _buildPhotoInfoCard(),
                  SizedBox(height: 16.h),
                  _buildPhoneCard(),
                ],
              ),
            ),
          ),
          _BottomBar(
            onBack: () => context.router.maybePop(),
            onSave: () => context.router.maybePop(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoInfoCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('edit.photo'.tr()),
          SizedBox(height: 8.h),
          _PhotoPicker(),
          SizedBox(height: 8.h),
          _sectionTitle('edit.info'.tr()),
          SizedBox(height: 8.h),
          _LabeledField(
            label: 'edit.name'.tr(),
            child: TextField(
              controller: _name,
              style: AppText.subtitle
                  .copyWith(fontSize: 14.sp, color: AppColors.textDark),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Value',
                hintStyle: AppText.subtitle
                    .copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _pickBirthDate,
            child: _LabeledField(
              label: 'edit.birth'.tr(),
              child: Text(
                _formatDate(_birth),
                style: AppText.subtitle
                    .copyWith(fontSize: 14.sp, color: AppColors.textDark),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _GenderToggle(
            isMale: _isMale,
            onChanged: (male) => setState(() => _isMale = male),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: _sectionTitle('edit.phone_section'.tr()),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'edit.new_phone'.tr(),
                  child: Row(
                    children: [
                      Text('+998 ',
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp, color: AppColors.textDark)),
                      Expanded(
                        child: TextField(
                          controller: _phone,
                          keyboardType: TextInputType.number,
                          maxLength: 9,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: AppText.subtitle.copyWith(
                              fontSize: 14.sp, color: AppColors.textDark),
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            counterText: '',
                            hintText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: _startCountdown,
                child: Container(
                  width: 106.w,
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.textDark,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text('edit.send_code'.tr(),
                      textAlign: TextAlign.center,
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              for (var i = 0; i < _otpLength; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                Expanded(
                  child: _OtpBox(
                    controller: _otpControllers[i],
                    focusNode: _otpFocusNodes[i],
                    onChanged: (v) => _onOtpChanged(i, v),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'edit.seconds'.tr(namedArgs: {'n': '$_secondsLeft'}),
            textAlign: TextAlign.center,
            style: AppText.subtitle
                .copyWith(fontSize: 16.sp, color: AppColors.textDark),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: _secondsLeft == 0 ? _startCountdown : null,
            child: Container(
              width: 173.w,
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text('edit.resend'.tr(),
                  style: AppText.subtitle.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500)),
            ),
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
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 6,
              offset: const Offset(0, 4)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 48.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.router.maybePop(),
                  child: SvgPicture.asset('$_icons/arrow_left.svg',
                      width: 24.sp, height: 24.sp),
                ),
                Expanded(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: AppText.subtitle.copyWith(
                          fontSize: 15.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                ),
                SvgPicture.asset('$_icons/bell.svg',
                    width: 24.sp, height: 24.sp),
              ],
            ),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

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
          Text(label,
              style: AppText.label
                  .copyWith(fontSize: 10.sp, color: AppColors.textMuted)),
          SizedBox(
            height: 22.h,
            child: Align(alignment: Alignment.centerLeft, child: child),
          ),
        ],
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 128.h,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.textSecondary,
          radius: 20.r,
          strokeWidth: 1,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset('$_icons/add_photo.svg',
              width: 48.sp, height: 48.sp),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
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
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _GenderToggle extends StatelessWidget {
  final bool isMale;
  final ValueChanged<bool> onChanged;

  const _GenderToggle({required this.isMale, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _GenderTab(
              label: 'edit.male'.tr(),
              selected: isMale,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _GenderTab(
              label: 'edit.female'.tr(),
              selected: !isMale,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 16.sp,
                color: selected ? AppColors.textDark : AppColors.textMuted,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppText.subtitle.copyWith(
            fontSize: 22.sp,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.fieldFill,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSave;

  const _BottomBar({required this.onBack, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.accent,
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 12,
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
                  label: 'edit.back'.tr(),
                  background: AppColors.fieldFill,
                  textColor: AppColors.textDark,
                  onTap: onBack,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _BarButton(
                  label: 'edit.save'.tr(),
                  background: AppColors.textDark,
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
          borderRadius: BorderRadius.circular(16.r),
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
