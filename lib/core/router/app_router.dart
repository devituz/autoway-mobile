import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/client/auth/register/presentation/pages/language_page.dart';
import '../../features/client/auth/register/presentation/pages/otp_page.dart';
import '../../features/client/auth/register/presentation/pages/phone_page.dart';
import '../../features/client/auth/register/presentation/pages/profile_page.dart';
import '../../features/client/auth/register/presentation/pages/user_type_page.dart';
import '../../features/client/home/presentation/pages/main_shell_page.dart';
import '../../features/client/home/presentation/pages/notifications_page.dart';
import '../../features/client/intercity/domain/intercity_trip_status.dart';
import '../../features/client/intercity/presentation/pages/intercity_address_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_cancel_order_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_cancelled_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_district_pick_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_driver_detail_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_driver_location_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_drivers_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_extra_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_order_details_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_price_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_rate_driver_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_region_pick_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_time_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_trip_status_page.dart';
import '../../features/client/orders/domain/order_status.dart';
import '../../features/client/orders/presentation/pages/go_online_page.dart';
import '../../features/client/orders/presentation/pages/order_detail_page.dart';
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
    AutoRoute(page: OrderDetailRoute.page),
    AutoRoute(page: IntercityAddressRoute.page),
    AutoRoute(page: IntercityRegionPickRoute.page),
    AutoRoute(page: IntercityDistrictPickRoute.page),
    AutoRoute(page: IntercityOrderDetailsRoute.page),
    AutoRoute(page: IntercityTimeRoute.page),
    AutoRoute(page: IntercityExtraRoute.page),
    AutoRoute(page: IntercityPriceRoute.page),
    AutoRoute(page: IntercityDriversRoute.page),
    AutoRoute(page: IntercityDriverDetailRoute.page),
    AutoRoute(page: IntercityDriverLocationRoute.page),
    AutoRoute(page: IntercityTripStatusRoute.page),
    AutoRoute(page: IntercityCancelOrderRoute.page),
    AutoRoute(page: IntercityCancelledRoute.page),
    AutoRoute(page: IntercityRateDriverRoute.page),
  ];
}
