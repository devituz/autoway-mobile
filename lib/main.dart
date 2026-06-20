import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/client/auth/data/repositories/auth_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_initializer.dart';
import 'features/client/auth/register/presentation/cubit/register_cubit.dart';
import 'features/client/profile/presentation/cubit/profile_cubit.dart';

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

/// Lets us tell auto_route to re-evaluate (rebuild) the live route stack on
/// demand — used to refresh every page's translations after a locale change.
class _LocaleReevaluate extends ReevaluateListenable {
  void bump() => notifyListeners();
}

class _AutoWayAppState extends State<AutoWayApp> {
  // A SINGLE router for the app's lifetime — never recreated. Recreating it (or
  // key-swapping MaterialApp) would reset the navigation stack to the initial
  // route, throwing the user back to the start when they switch language.
  final AppRouter _appRouter = AppRouter();

  // Fired on every locale change. Wired into auto_route via [reevaluateListenable]
  // so the WHOLE current page stack rebuilds in place (re-evaluating every
  // `.tr()`, including persistent chrome like the bottom nav) WITHOUT changing
  // the routes — language switches instantly, right where the user is.
  final _LocaleReevaluate _reeval = _LocaleReevaluate();
  Locale? _lastLocale;

  late final RouterConfig<UrlState> _routerConfig = _appRouter.config(
    reevaluateListenable: _reeval,
    // Startup auth gate: a returning user with a saved token skips the
    // language/register flow and lands straight on the main shell.
    deepLinkBuilder: (deepLink) => sl<AuthRepository>().isLoggedIn
        ? DeepLink.single(const MainShellRoute())
        : deepLink,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    if (_lastLocale != null && _lastLocale != locale) {
      // Rebuild the live route stack after this frame (notifying mid-build
      // would be illegal).
      WidgetsBinding.instance.addPostFrameCallback((_) => _reeval.bump());
    }
    _lastLocale = locale;
  }

  @override
  void dispose() {
    _reeval.dispose();
    super.dispose();
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
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RegisterCubit(sl())),
          BlocProvider(create: (_) => ProfileCubit(sl())),
        ],
        child: MaterialApp.router(
          title: 'AutoWay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: _routerConfig,
        ),
      ),
    );
  }
}
