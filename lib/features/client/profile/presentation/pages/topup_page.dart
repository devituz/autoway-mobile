import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

const _icons = 'assets/icons';

/// Groups thousands with a space (e.g. 50000 → "50 000").
String _money(num value) {
  final s = value.toInt().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// Balance top-up (Balans to'ldirish) — Figma node 2066:14825.
/// Reached from the Profile "Toldirish" button.
@RoutePage()
class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _amount = TextEditingController();
  String _method = 'payme';

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final amount =
        num.tryParse(_amount.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (amount <= 0) {
      AppSnackbar.error(context, 'topup.amount'.tr());
      return;
    }
    context.read<ProfileCubit>().topUp(amount);
    AppSnackbar.success(
        context, '${_money(amount)} ${'home.currency'.tr()}');
    context.router.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldFill,
      body: Column(
        children: [
          _Header(title: 'topup.title'.tr()),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
              child: Column(
                children: [
                  // Balance + amount card
                  _Card(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              final u = state.user;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('topup.balance'.tr(),
                                          style: AppText.subtitle.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.textMuted)),
                                      SizedBox(height: 2.h),
                                      Text('ID: ${u?.idBalance ?? '-'}',
                                          style: AppText.subtitle.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.textDark)),
                                    ],
                                  ),
                                  Text(
                                      '${_money(u?.balance ?? 0)} ${'home.currency'.tr()}',
                                      style: AppText.subtitle.copyWith(
                                          fontSize: 18.sp,
                                          color: AppColors.textDark,
                                          fontWeight: FontWeight.w600)),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _AmountField(controller: _amount),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Payment method card
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('topup.payment_method'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 10.h),
                        _MethodTile(
                          id: 'payme',
                          logo: 'payme',
                          isPng: false,
                          logoW: 69,
                          logoH: 22,
                          selected: _method == 'payme',
                          onTap: () => setState(() => _method = 'payme'),
                        ),
                        SizedBox(height: 8.h),
                        _MethodTile(
                          id: 'click',
                          logo: 'click',
                          isPng: false,
                          logoW: 64,
                          logoH: 18,
                          selected: _method == 'click',
                          onTap: () => setState(() => _method = 'click'),
                        ),
                        SizedBox(height: 8.h),
                        _MethodTile(
                          id: 'uzum',
                          logo: 'uzum_logo',
                          isPng: true,
                          logoW: 66,
                          logoH: 24,
                          selected: _method == 'uzum',
                          onTap: () => setState(() => _method = 'uzum'),
                        ),
                        SizedBox(height: 10.h),
                        _SubmitButton(onTap: _onSubmit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                SizedBox(width: 24.sp),
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

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  const _AmountField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('topup.amount'.tr(),
              style: AppText.label
                  .copyWith(fontSize: 10.sp, color: AppColors.textMuted)),
          SizedBox(
            height: 22.h,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppText.subtitle
                  .copyWith(fontSize: 14.sp, color: AppColors.textDark),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: '0 so‘m',
                hintStyle: AppText.subtitle
                    .copyWith(fontSize: 14.sp, color: AppColors.textDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final String id;
  final String logo;
  final bool isPng;
  final double logoW;
  final double logoH;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTile({
    required this.id,
    required this.logo,
    required this.isPng,
    required this.logoW,
    required this.logoH,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 24.r,
                  height: 24.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.textDark : AppColors.accent,
                    shape: BoxShape.circle,
                    border: selected
                        ? null
                        : Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 14.sp, color: AppColors.textOnDark)
                      : null,
                ),
                SizedBox(width: 12.w),
                Text(id[0].toUpperCase() + id.substring(1),
                    style: AppText.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            isPng
                ? Image.asset('$_icons/$logo.png',
                    width: logoW.w, height: logoH.h, fit: BoxFit.contain)
                : SvgPicture.asset('$_icons/$logo.svg',
                    width: logoW.w, height: logoH.h),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SubmitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.textDark,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text('topup.submit'.tr(),
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
