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

/// Register step 3 — phone number entry.
@RoutePage()
class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  late final TextEditingController _controller;

  // 9 national digits after the fixed +998 prefix.
  static const _requiredDigits = 9;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<RegisterCubit>().state.phone,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 31.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('register.phone_title'.tr(),
                  style: AppText.screenTitle.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.textDark,
                  )),
              SizedBox(height: 12.h),
              Text('register.phone_subtitle'.tr(),
                  style: AppText.subtitle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 20 / 16,
                    color: AppColors.textMuted,
                  )),
              SizedBox(height: 18.h),
              _PhoneField(
                controller: _controller,
                onChanged: context.read<RegisterCubit>().setPhone,
                maxDigits: _requiredDigits,
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
                  // Only the visible page navigates — stops the OTP screen
                  // pushed on top from re-triggering this listener.
                  if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
                  final cubit = context.read<RegisterCubit>();
                  if (state.status == AuthStatus.codeSent) {
                    // Existing user → OTP was sent, go enter it.
                    cubit.resetStatus();
                    context.router.push(const OtpRoute());
                  } else if (state.status == AuthStatus.needProfile) {
                    // New user → collect the profile before requesting the OTP.
                    cubit.resetStatus();
                    context.router.push(const ProfileRoute());
                  } else if (state.status == AuthStatus.failure) {
                    AppSnackbar.error(context,
                        state.errorMessage ?? 'Serverda xatolik yuz berdi');
                    cubit.resetStatus();
                  }
                },
                buildWhen: (p, c) =>
                    p.phone != c.phone || p.status != c.status,
                builder: (context, state) {
                  final valid = state.phone.length == _requiredDigits;
                  final loading = state.status == AuthStatus.loading;
                  return PrimaryButton(
                    label: 'register.send'.tr(),
                    loading: loading,
                    onPressed: valid
                        ? () => context.read<RegisterCubit>().submitPhone()
                        : null,
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

/// Phone field with a permanent, non-editable `+998` prefix. Only the 9
/// national digits are editable; the prefix can never be deleted because it
/// lives outside the [TextField].
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int maxDigits;

  const _PhoneField({
    required this.controller,
    required this.onChanged,
    required this.maxDigits,
  });

  @override
  Widget build(BuildContext context) {
    final fieldStyle = AppText.input.copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
    );
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Text('+998', style: fieldStyle.copyWith(color: AppColors.textDark)),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              style: fieldStyle.copyWith(color: AppColors.textDark),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maxDigits),
              ],
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'XX XXX XX XX',
                hintStyle: fieldStyle.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
