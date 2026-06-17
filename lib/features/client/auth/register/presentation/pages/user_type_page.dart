import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/selectable_card.dart';

/// Register step 2 — pick the account type.
@RoutePage()
class UserTypePage extends StatelessWidget {
  const UserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: BlocBuilder<RegisterCubit, RegisterState>(
            buildWhen: (p, c) => p.userType != c.userType,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('register.choose_user_type'.tr(),
                      style: AppText.screenTitle
                          .copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.25,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SelectableCard(
                          icon: Icons.person_outline,
                          label: 'register.passenger'.tr(),
                          selected: state.userType == UserType.passenger,
                          onTap: () => cubit.setUserType(UserType.passenger),
                        ),
                        SelectableCard(
                          icon: Icons.local_taxi_outlined,
                          label: 'register.driver'.tr(),
                          selected: state.userType == UserType.driver,
                          onTap: () => cubit.setUserType(UserType.driver),
                        ),
                        SelectableCard(
                          icon: Icons.directions_car_outlined,
                          label: 'register.new_service'.tr(),
                          selected: false,
                          enabled: false,
                          onTap: () {},
                        ),
                        SelectableCard(
                          icon: Icons.directions_car_outlined,
                          label: 'register.new_service'.tr(),
                          selected: false,
                          enabled: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'register.offer_agreement'.tr(),
                        style: AppText.subtitle.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SecondaryButton(
                    label: 'register.back'.tr(),
                    onPressed: () => context.router.maybePop(),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'register.continue'.tr(),
                    onPressed: state.userType == null
                        ? null
                        : () => context.router.push(const PhoneRoute()),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
