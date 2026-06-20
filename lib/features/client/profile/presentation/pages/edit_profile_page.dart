import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/change_phone_sheet.dart';

const _icons = 'assets/icons';

/// Edit profile (Profil o'zgartirish) — Figma node 2232:23771.
@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _name = TextEditingController();

  bool _isMale = true;
  DateTime _birth = DateTime(2001, 1, 10);

  @override
  void initState() {
    super.initState();
    // Prefill from the already-loaded /me profile.
    final user = context.read<ProfileCubit>().state.user;
    if (user != null) {
      _name.text = user.fullName;
      _isMale = user.gender != 'female';
      final parsed = DateTime.tryParse(user.birthDate);
      if (parsed != null) _birth = parsed;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  /// Backend wants ISO yyyy-MM-dd.
  String get _isoBirth =>
      '${_birth.year.toString().padLeft(4, '0')}-${_birth.month.toString().padLeft(2, '0')}-${_birth.day.toString().padLeft(2, '0')}';

  void _save() {
    FocusScope.of(context).unfocus();
    context.read<ProfileCubit>().updateProfile(
          fullName: _name.text.trim(),
          birthDate: _isoBirth,
          gender: _isMale ? 'male' : 'female',
        );
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

  Future<void> _changePhone() async {
    await showChangePhoneSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == ProfileStatus.saved) {
          context.read<ProfileCubit>().clearStatus();
          AppSnackbar.success(context, 'edit.saved'.tr());
          context.router.maybePop();
        } else if (state.status == ProfileStatus.failure) {
          AppSnackbar.error(
              context, state.errorMessage ?? 'Saqlashda xatolik');
          context.read<ProfileCubit>().clearStatus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.fieldFill,
        body: Column(
          children: [
            _Header(title: 'edit.title'.tr()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
                child: Column(
                  children: [
                    _buildInfoCard(),
                    SizedBox(height: 16.h),
                    _buildPhoneCard(),
                  ],
                ),
              ),
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) => _BottomBar(
                saving: state.status == ProfileStatus.saving,
                onClose: () => context.router.maybePop(),
                onSave: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('edit.info'.tr()),
          SizedBox(height: 12.h),
          Center(
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: SizedBox(
                    width: 130.r,
                    height: 130.r,
                    child: CustomPaint(
                      painter: _DashedCirclePainter(
                        color: const Color(0xFF94A3B8),
                        strokeWidth: 1,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 28.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'edit.upload_photo'.tr(),
                  textAlign: TextAlign.center,
                  style: AppText.label
                      .copyWith(fontSize: 12.sp, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _LabeledField(
            label: 'edit.name'.tr(),
            child: TextField(
              controller: _name,
              style: AppText.subtitle
                  .copyWith(fontSize: 14.sp, color: AppColors.textDark),
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 12.h),
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
          SizedBox(height: 12.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('edit.phone_section'.tr()),
          SizedBox(height: 12.h),
          Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '+998 95 098 5665',
                    style: AppText.subtitle
                        .copyWith(fontSize: 14.sp, color: AppColors.textDark),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _changePhone,
                  child: SvgPicture.asset('$_icons/edit.svg',
                      width: 20.sp, height: 20.sp),
                ),
              ],
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
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SvgPicture.asset('$_icons/arrow_left.svg',
                        width: 20.sp, height: 20.sp),
                  ),
                ),
                Expanded(
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: AppText.subtitle.copyWith(
                          fontSize: 15.sp,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                ),
                SizedBox(width: 36.r),
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

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DashedCirclePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addOval(Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.shortestSide / 2,
      ));

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
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
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

class _BottomBar extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;
  final bool saving;

  const _BottomBar(
      {required this.onClose, required this.onSave, this.saving = false});

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
                  label: 'edit.close'.tr(),
                  background: AppColors.fieldFill,
                  textColor: AppColors.textDark,
                  onTap: onClose,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _BarButton(
                  label: saving ? '...' : 'edit.save'.tr(),
                  background: AppColors.blue,
                  textColor: AppColors.textOnDark,
                  onTap: saving ? () {} : onSave,
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
