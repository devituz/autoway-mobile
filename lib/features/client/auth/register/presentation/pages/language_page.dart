import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/primary_button.dart';

/// Register step 1 — welcome + language selection (dark screen).
@RoutePage()
class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const _languages = [
    (code: 'uz', label: 'O‘zbek'),
    (code: 'ru', label: 'Русский'),
    (code: 'en', label: 'English'),
  ];

  @override
  Widget build(BuildContext context) {
    // Reading the active locale registers a dependency on easy_localization's
    // provider, so this (auto_route-cached) page rebuilds the instant a chip
    // calls context.setLocale(...) — every .tr() text switches immediately.
    final locale = context.locale;
    return Scaffold(
      key: ValueKey('lang_${locale.languageCode}'),
      backgroundColor: AppColors.onboardingDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title near the very top.
              SizedBox(height: 24.h),
              Text(
                'register.app_welcome'.tr(),
                textAlign: TextAlign.center,
                style: AppText.subtitle.copyWith(color: AppColors.textOnDark),
              ),
              SizedBox(height: 8.h),
              Text(
                'register.welcome_title'.tr(),
                textAlign: TextAlign.center,
                style:
                    AppText.welcomeTitle.copyWith(color: AppColors.textOnDark),
              ),
              const Spacer(),
              Text(
                'register.choose_language'.tr(),
                style: AppText.subtitle.copyWith(color: AppColors.textOnDark),
              ),
              SizedBox(height: 14.h),
              BlocBuilder<RegisterCubit, RegisterState>(
                buildWhen: (p, c) => p.language != c.language,
                builder: (context, state) {
                  return Row(
                    children: [
                      for (final lang in _languages) ...[
                        Expanded(
                          child: _LanguageChip(
                            label: lang.label,
                            selected: state.language == lang.code,
                            onTap: () {
                              context
                                  .read<RegisterCubit>()
                                  .setLanguage(lang.code);
                              // Switch the whole app locale immediately.
                              context.setLocale(Locale(lang.code));
                            },
                          ),
                        ),
                        if (lang != _languages.last) SizedBox(width: 12.w),
                      ],
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
              PrimaryButton(
                label: 'register.continue'.tr(),
                color: AppColors.mutedButton,
                onPressed: () => context.router.push(const UserTypeRoute()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 88.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppText.subtitle.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
