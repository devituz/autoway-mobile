import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text.dart';

const _icons = 'assets/icons';

/// Intercity-taxi flow — "Narx taklif qilish" price-offer sheet (Figma node
/// 2174:13602). The client proposes a fare for the selected number of seats;
/// a warning note explains the driver must confirm it.
@RoutePage()
class IntercityPricePage extends StatefulWidget {
  const IntercityPricePage({super.key});

  @override
  State<IntercityPricePage> createState() => _IntercityPricePageState();
}

class _IntercityPricePageState extends State<IntercityPricePage> {
  final _controller = TextEditingController(text: '750 000');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/map_bg.png', fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _Sheet(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('intercity.price_title'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 18.sp,
                          height: 20 / 18,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.h),
                  Text('intercity.price_subtitle'.tr(),
                      style: AppText.subtitle.copyWith(
                          fontSize: 14.sp,
                          height: 16 / 14,
                          color: AppColors.primary)),
                  SizedBox(height: 16.h),
                  Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.fieldFill,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Text('intercity.price_label'.tr(),
                            style: AppText.subtitle.copyWith(
                                fontSize: 14.sp,
                                height: 16 / 14,
                                color: AppColors.primary)),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9 ]')),
                            ],
                            style: AppText.subtitle.copyWith(
                                fontSize: 14.sp,
                                height: 20 / 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('$_icons/info_circle.svg',
                            width: 20.r, height: 20.r),
                        SizedBox(width: 10.w),
                        Flexible(
                          child: Text('intercity.price_note'.tr(),
                              textAlign: TextAlign.center,
                              style: AppText.label.copyWith(
                                  fontSize: 12.sp, color: AppColors.textDark)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SheetButton(
                          label: 'intercity.price_close'.tr(),
                          filled: false,
                          onTap: () => context.router.maybePop(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _SheetButton(
                          label: 'intercity.price_save'.tr(),
                          filled: true,
                          onTap: () {
                            // TODO(nav): -> intercity order confirm
                          },
                        ),
                      ),
                    ],
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

class _Sheet extends StatelessWidget {
  final Widget child;
  const _Sheet({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
              color: const Color(0x147D8184),
              blurRadius: 6,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -12.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 112.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _SheetButton(
      {required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.ctaBlue : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(label,
            style: AppText.subtitle.copyWith(
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: filled ? AppColors.textOnDark : AppColors.textDark)),
      ),
    );
  }
}
