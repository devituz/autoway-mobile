import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_initializer.dart';
import 'features/client/auth/register/presentation/cubit/register_cubit.dart';

void main() async {
  await AppInitializer.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('uz'),
        Locale('ru'),
        Locale('en'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('uz'),
      startLocale: const Locale('uz'),
      child: const AutoWayApp(),
    ),
  );
}

class AutoWayApp extends StatefulWidget {
  const AutoWayApp({super.key});

  @override
  State<AutoWayApp> createState() => _AutoWayAppState();
}

class _AutoWayAppState extends State<AutoWayApp> {
  AppRouter _appRouter = AppRouter();
  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    // When the locale changes, build a FRESH router delegate. Reusing the same
    // delegate across the key-swapped MaterialApp causes a "delegate already in
    // use" conflict (black screen / rebuild loop). A fresh delegate also makes
    // every cached auto_route page rebuild with the new translations.
    if (_lastLocale != null && _lastLocale != locale) {
      _appRouter = AppRouter();
    }
    _lastLocale = locale;
  }

  @override
  Widget build(BuildContext context) {
    // Design baseline = iPhone 13/14 frame from Figma (390 x 844).
    // ScreenUtil scales every .w/.h/.r/.sp unit to the real device size so the
    // UI matches the design 1:1 on any screen (SE → Pro Max → tablets).
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider(
        create: (_) => RegisterCubit(),
        child: MaterialApp.router(
          key: ValueKey(context.locale.languageCode),
          title: 'AutoWay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }
}
