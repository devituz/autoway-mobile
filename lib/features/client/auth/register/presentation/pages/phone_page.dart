import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/router/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/labeled_field.dart';
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

  // 9 national digits after the +998 prefix.
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
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('register.phone_title'.tr(),
                  style: AppText.screenTitle
                      .copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text('register.phone_subtitle'.tr(),
                  style: AppText.subtitle
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              LabeledField(
                controller: _controller,
                hint: 'XX XXX XX XX',
                prefixText: '+998 ',
                keyboardType: TextInputType.phone,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_requiredDigits),
                ],
                onChanged: context.read<RegisterCubit>().setPhone,
              ),
              const Spacer(),
              SecondaryButton(
                label: 'register.back'.tr(),
                onPressed: () => context.router.maybePop(),
              ),
              const SizedBox(height: 12),
              BlocBuilder<RegisterCubit, RegisterState>(
                buildWhen: (p, c) => p.phone != c.phone,
                builder: (context, state) {
                  final valid = state.phone.length == _requiredDigits;
                  return PrimaryButton(
                    label: 'register.send'.tr(),
                    onPressed: valid
                        ? () => context.router.push(const OtpRoute())
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
