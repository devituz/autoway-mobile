import 'package:auto_route/auto_route.dart';

import '../../features/client/auth/register/presentation/pages/language_page.dart';
import '../../features/client/auth/register/presentation/pages/otp_page.dart';
import '../../features/client/auth/register/presentation/pages/phone_page.dart';
import '../../features/client/auth/register/presentation/pages/profile_page.dart';
import '../../features/client/auth/register/presentation/pages/user_type_page.dart';
import '../../features/client/home/presentation/pages/main_shell_page.dart';
import '../../features/client/home/presentation/pages/notifications_page.dart';
import '../../features/client/orders/presentation/pages/go_online_page.dart';
import '../../features/client/profile/presentation/pages/edit_profile_page.dart';
import '../../features/client/profile/presentation/pages/payment_history_page.dart';
import '../../features/client/profile/presentation/pages/topup_page.dart';

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
    AutoRoute(page: MainShellRoute.page),
    AutoRoute(page: NotificationsRoute.page),
    AutoRoute(page: PaymentHistoryRoute.page),
    AutoRoute(page: TopUpRoute.page),
    AutoRoute(page: EditProfileRoute.page),
    AutoRoute(page: GoOnlineRoute.page),
  ];
}
