import 'package:auto_route/auto_route.dart';

import '../../features/client/auth/register/presentation/pages/language_page.dart';
import '../../features/client/auth/register/presentation/pages/otp_page.dart';
import '../../features/client/auth/register/presentation/pages/phone_page.dart';
import '../../features/client/auth/register/presentation/pages/profile_page.dart';
import '../../features/client/auth/register/presentation/pages/user_type_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LanguageRoute.page, initial: true),
    AutoRoute(page: UserTypeRoute.page),
    AutoRoute(page: PhoneRoute.page),
    AutoRoute(page: OtpRoute.page),
    AutoRoute(page: ProfileRoute.page),
  ];
}
