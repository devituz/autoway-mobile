import 'dart:async';

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

/// Register step 4 — 6-digit SMS code entry with a resend countdown.
@RoutePage()
class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  static const _length = 6;
  static const _resendSeconds = 59;

  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = _resendSeconds;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

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
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool _submitted = false;

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      // Backspace on an empty box → step back.
      _controllers[index].text = '';
      if (index > 0) _focusNodes[index - 1].requestFocus();
    } else {
      // Spread the entered digits across this box and the ones after it. This
      // keeps fast typing and paste from being dropped (no per-box maxLength).
      for (var i = 0; i < digits.length && index + i < _length; i++) {
        _controllers[index + i].text = digits[i];
      }
      final next = index + digits.length;
      if (next >= _length) {
        FocusScope.of(context).unfocus();
      } else {
        _focusNodes[next].requestFocus();
      }
    }

    context.read<RegisterCubit>().setOtp(_code);
    setState(() {});

    // Auto-verify the moment all six digits are in (beats the 60s code TTL).
    if (_code.length == _length && !_submitted) {
      _submitted = true;
      context.read<RegisterCubit>().verify();
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = context.read<RegisterCubit>().state.phone;
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('register.otp_title'.tr(),
                  style: AppText.screenTitle
                      .copyWith(color: AppColors.textPrimary)),
              SizedBox(height: 8.h),
              Text(
                'register.otp_subtitle'.tr(namedArgs: {'phone': '+998 $phone'}),
                style: AppText.subtitle.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < _length; i++)
                    _OtpBox(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      onChanged: (v) => _onChanged(i, v),
                    ),
                ],
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  'register.seconds'.tr(namedArgs: {'n': '$_secondsLeft'}),
                  style:
                      AppText.subtitle.copyWith(color: AppColors.textSecondary),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: TextButton(
                  onPressed: _secondsLeft == 0
                      ? () {
                          context.read<RegisterCubit>().resendOtp();
                          _startCountdown();
                        }
                      : null,
                  child: Text(
                    'register.resend'.tr(),
                    style: AppText.button.copyWith(
                      color: _secondsLeft == 0
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
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
                  final cubit = context.read<RegisterCubit>();
                  if (state.status == AuthStatus.success) {
                    // Verified (login or register) → into the app.
                    cubit.resetStatus();
                    context.router.replaceAll([const MainShellRoute()]);
                  } else if (state.status == AuthStatus.failure) {
                    AppSnackbar.error(context,
                        state.errorMessage ??
                            'Kod noto‘g‘ri yoki muddati tugagan');
                    cubit.resetStatus();
                  }
                },
                builder: (context, state) {
                  final ready = _code.length == _length;
                  final loading = state.status == AuthStatus.loading;
                  return PrimaryButton(
                    label: 'register.continue'.tr(),
                    loading: loading,
                    onPressed: ready
                        ? () {
                            final cubit = context.read<RegisterCubit>();
                            cubit.setOtp(_code);
                            cubit.verify();
                          }
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
      width: 48.w,
      height: 56.w,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppText.screenTitle.copyWith(color: AppColors.textPrimary),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.fieldFill,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: const BorderSide(color: AppColors.borderSelected),
          ),
        ),
      ),
    );
  }
}
