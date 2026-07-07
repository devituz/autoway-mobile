import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/client/auth/presentation/pages/language_page.dart';
import '../../features/client/auth/presentation/pages/otp_page.dart';
import '../../features/client/auth/presentation/pages/phone_page.dart';
import '../../features/client/auth/presentation/pages/profile_page.dart';
import '../../features/client/auth/presentation/pages/user_type_page.dart';
import '../../features/client/cargo/domain/entities/cargo_status.dart';
import '../../features/client/cargo/presentation/pages/cargo_address_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_district_pick_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_driver_detail_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_driver_offer_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_drivers_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_order_form_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_rate_driver_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_region_pick_page.dart';
import '../../features/client/cargo/presentation/pages/cargo_status_page.dart';
import '../../features/client/home/presentation/pages/main_shell_page.dart';
import '../../features/client/home/presentation/pages/notifications_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_address_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_district_pick_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_driver_location_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_drivers_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_order_details_page.dart';
import '../../features/client/intercity/presentation/pages/intercity_region_pick_page.dart';
import '../../features/client/orders/domain/entities/order_status.dart';
import '../../features/client/orders/presentation/pages/go_online_page.dart';
import '../../features/client/orders/presentation/pages/order_detail_page.dart';
import '../../features/client/profile/presentation/pages/edit_profile_page.dart';
import '../../features/client/profile/presentation/pages/payment_history_page.dart';
import '../../features/client/profile/presentation/pages/topup_page.dart';
import '../../features/driver/orders/presentation/pages/driver_go_online_page.dart';
import '../../features/driver/orders/presentation/pages/driver_orders_settings_page.dart';
import '../../features/driver/profile/presentation/pages/choose_navigator_page.dart';
import '../../features/driver/routes/presentation/pages/create_route_page.dart';
import '../../features/driver/routes/presentation/pages/driver_routes_page.dart';
import '../../features/driver/profile/presentation/pages/driver_settings_page.dart';
import '../../features/driver/profile/presentation/pages/driver_stats_page.dart';
import '../../features/driver/vehicles/presentation/pages/edit_vehicle_page.dart';
import '../../features/driver/vehicles/presentation/pages/seat_layout_page.dart';
import '../../features/driver/vehicles/presentation/pages/transports_page.dart';

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
    // Modal sheets — slide up from the bottom over the previous screen.
    AutoRoute(page: IntercityDriversRoute.page),
    AutoRoute(page: IntercityDriverLocationRoute.page),
    // Cargo (Pochta / Yuk yetkazma) flow.
    AutoRoute(page: CargoAddressRoute.page),
    AutoRoute(page: CargoRegionPickRoute.page),
    AutoRoute(page: CargoDistrictPickRoute.page),
    AutoRoute(page: CargoOrderFormRoute.page),
    AutoRoute(page: CargoDriversRoute.page),
    AutoRoute(page: CargoDriverDetailRoute.page),
    AutoRoute(page: CargoStatusRoute.page),
    _sheet(CargoDriverOfferRoute.page),
    _sheet(CargoRateDriverRoute.page),
    // Driver profile section (Haydovchi profil bo'limi).
    AutoRoute(page: DriverRoutesRoute.page),
    AutoRoute(page: CreateRouteRoute.page),
    AutoRoute(page: TransportsRoute.page),
    AutoRoute(page: EditVehicleRoute.page),
    AutoRoute(page: DriverSettingsRoute.page),
    AutoRoute(page: ChooseNavigatorRoute.page),
    AutoRoute(page: DriverStatsRoute.page),
    // Driver home — Buyurtmalar order-intake settings (Figma 2226:29983).
    AutoRoute(page: DriverGoOnlineRoute.page),
    AutoRoute(page: DriverOrdersSettingsRoute.page),
    _sheet(SeatLayoutRoute.page),
  ];

  /// A bottom-sheet style route: rises from the bottom, keeps the previous
  /// screen painted behind (the page paints its own translucent scrim).
  static CustomRoute _sheet(PageInfo page, {bool initial = false}) => CustomRoute(
        page: page,
        initial: initial,
        transitionsBuilder: TransitionsBuilders.slideBottom,
        opaque: false,
        barrierDismissible: true,
      );
}
