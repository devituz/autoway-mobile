import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/labeled_field.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('register.done'.tr())),
    );
    // Registration complete → go to the main shell, clearing the flow.
    context.router.replaceAll([const MainShellRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Scaffold(
      backgroundColor: AppColors.accent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
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
                            style: AppText.screenTitle
                                .copyWith(color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Text('register.profile_subtitle'.tr(),
                            style: AppText.subtitle
                                .copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const _Avatar(),
                ],
              ),
              const SizedBox(height: 28),
              LabeledField(
                label: 'register.name_label'.tr(),
                hint: 'register.name_hint'.tr(),
                controller: _nameController,
                onChanged: cubit.setName,
              ),
              const SizedBox(height: 14),
              LabeledField(
                label: 'register.birth_label'.tr(),
                hint: 'dd.mm.yyyy',
                controller: _birthController,
                keyboardType: TextInputType.datetime,
                onChanged: cubit.setBirthDate,
              ),
              const SizedBox(height: 14),
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
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'register.continue'.tr(),
                onPressed: _finish,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.accentYellow,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: AppColors.textPrimary),
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
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
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
        onTap: () => onChanged(gender),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: AppText.button.copyWith(
              color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
