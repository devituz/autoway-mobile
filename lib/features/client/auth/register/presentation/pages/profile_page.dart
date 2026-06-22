import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../../../../../../core/widgets/app_snackbar.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

/// Register step 5 — profile details (name, birth date, gender).
@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _birthController;

  @override
  void initState() {
    super.initState();
    final state = context.read<RegisterCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _birthController = TextEditingController(text: state.birthDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  void _finish() {
    FocusScope.of(context).unfocus();
    // REGISTER 1/2 — creates the account and sends the OTP; we then go to the
    // OTP screen to verify (registration completes there).
    context.read<RegisterCubit>().submitProfile();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('register.profile_title'.tr(),
                            style: AppText.screenTitle.copyWith(
                              fontSize: 20.sp,
                              color: AppColors.textDark,
                            )),
                        SizedBox(height: 12.h),
                        Text('register.profile_subtitle'.tr(),
                            style: AppText.subtitle.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
              SizedBox(height: 24.h),
              _CompactField(
                label: 'register.name_label'.tr(),
                hint: 'register.name_hint'.tr(),
                controller: _nameController,
                onChanged: cubit.setName,
              ),
              SizedBox(height: 12.h),
              _CompactField(
                label: 'register.birth_label'.tr(),
                hint: 'dd.mm.yyyy',
                controller: _birthController,
                keyboardType: TextInputType.number,
                inputFormatters: [_DateInputFormatter()],
                onChanged: cubit.setBirthDate,
              ),
              SizedBox(height: 12.h),
              BlocBuilder<RegisterCubit, RegisterState>(
                buildWhen: (p, c) => p.gender != c.gender,
                builder: (context, state) => _GenderToggle(
                  value: state.gender,
                  onChanged: cubit.setGender,
                ),
              ),
              const Spacer(),
              SecondaryButton(
                label: 'register.back'.tr(),
                onPressed: () => context.router.maybePop(),
              ),
              SizedBox(height: 12.h),
              BlocConsumer<RegisterCubit, RegisterState>(
                listenWhen: (p, c) => p.status != c.status,
                listener: (context, state) {
                  // Only the visible page navigates — the OTP screen pushed on
                  // top must not re-trigger this listener.
                  if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
                  final cubit = context.read<RegisterCubit>();
                  if (state.status == AuthStatus.codeSent) {
                    // Account created + OTP sent → verify on the next screen.
                    cubit.resetStatus();
                    context.router.push(const OtpRoute());
                  } else if (state.status == AuthStatus.failure) {
                    AppSnackbar.error(context,
                        state.errorMessage ?? 'Ro‘yxatdan o‘tishda xatolik');
                    cubit.resetStatus();
                  }
                },
                builder: (context, state) {
                  final valid = state.name.trim().isNotEmpty &&
                      state.birthDate.trim().isNotEmpty &&
                      state.gender != null;
                  final loading = state.status == AuthStatus.loading;
                  return PrimaryButton(
                    label: 'register.continue'.tr(),
                    loading: loading,
                    onPressed: valid ? _finish : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// Compact 48px input with an always-visible 10px label inside the field
/// (Figma: bg #F1F5F9, radius 16, label 10sp #64748B, value 14sp #0F172A).
class _CompactField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const _CompactField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              height: 1.0,
              color: AppColors.textMuted,
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              color: AppColors.textDark,
            ),
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                color: AppColors.textMuted,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

/// Masks a date as the user types: digits only, auto-inserting dots →
/// `dd.mm.yyyy` (e.g. 24022006 → 24.02.2006). Max 8 digits.
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) buf.write('.');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _GenderToggle extends StatelessWidget {
  final Gender? value;
  final ValueChanged<Gender> onChanged;

  const _GenderToggle({required this.value, required this.onChanged});

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _segment('register.male'.tr(), Gender.male),
          _segment('register.female'.tr(), Gender.female),
        ],
      ),
    );
  }

  Widget _segment(String label, Gender gender) {
    final selected = value == gender;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(gender),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 20 / 16,
              color: selected ? AppColors.textDark : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
