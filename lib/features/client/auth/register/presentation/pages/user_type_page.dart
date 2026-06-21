import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
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
          padding: EdgeInsets.fromLTRB(14.w, 31.h, 14.w, 16.h),
          child: BlocBuilder<RegisterCubit, RegisterState>(
            buildWhen: (p, c) => p.userType != c.userType,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'register.choose_user_type'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 33.h),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 4.w,
                    childAspectRatio: 175 / 130,
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
                  const Spacer(),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'register.offer_agreement'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: AppColors.textDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SecondaryButton(
                    label: 'register.back'.tr(),
                    onPressed: () => context.router.maybePop(),
                  ),
                  SizedBox(height: 12.h),
                  PrimaryButton(
                    label: 'register.continue'.tr(),
                    onPressed: () => context.router.push(const PhoneRoute()),
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
