// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [EditProfilePage]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfilePage();
    },
  );
}

/// generated route for
/// [GoOnlinePage]
class GoOnlineRoute extends PageRouteInfo<void> {
  const GoOnlineRoute({List<PageRouteInfo>? children})
    : super(GoOnlineRoute.name, initialChildren: children);

  static const String name = 'GoOnlineRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GoOnlinePage();
    },
  );
}

/// generated route for
/// [IntercityAddressPage]
class IntercityAddressRoute extends PageRouteInfo<void> {
  const IntercityAddressRoute({List<PageRouteInfo>? children})
    : super(IntercityAddressRoute.name, initialChildren: children);

  static const String name = 'IntercityAddressRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityAddressPage();
    },
  );
}

/// generated route for
/// [IntercityCancelOrderPage]
class IntercityCancelOrderRoute extends PageRouteInfo<void> {
  const IntercityCancelOrderRoute({List<PageRouteInfo>? children})
    : super(IntercityCancelOrderRoute.name, initialChildren: children);

  static const String name = 'IntercityCancelOrderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityCancelOrderPage();
    },
  );
}

/// generated route for
/// [IntercityCancelledPage]
class IntercityCancelledRoute extends PageRouteInfo<void> {
  const IntercityCancelledRoute({List<PageRouteInfo>? children})
    : super(IntercityCancelledRoute.name, initialChildren: children);

  static const String name = 'IntercityCancelledRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityCancelledPage();
    },
  );
}

/// generated route for
/// [IntercityDistrictPickPage]
class IntercityDistrictPickRoute
    extends PageRouteInfo<IntercityDistrictPickRouteArgs> {
  IntercityDistrictPickRoute({
    Key? key,
    String regionName = 'Andijon viloyati',
    List<PageRouteInfo>? children,
  }) : super(
         IntercityDistrictPickRoute.name,
         args: IntercityDistrictPickRouteArgs(key: key, regionName: regionName),
         initialChildren: children,
       );

  static const String name = 'IntercityDistrictPickRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IntercityDistrictPickRouteArgs>(
        orElse: () => const IntercityDistrictPickRouteArgs(),
      );
      return IntercityDistrictPickPage(
        key: args.key,
        regionName: args.regionName,
      );
    },
  );
}

class IntercityDistrictPickRouteArgs {
  const IntercityDistrictPickRouteArgs({
    this.key,
    this.regionName = 'Andijon viloyati',
  });

  final Key? key;

  final String regionName;

  @override
  String toString() {
    return 'IntercityDistrictPickRouteArgs{key: $key, regionName: $regionName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IntercityDistrictPickRouteArgs) return false;
    return key == other.key && regionName == other.regionName;
  }

  @override
  int get hashCode => key.hashCode ^ regionName.hashCode;
}

/// generated route for
/// [IntercityDriverDetailPage]
class IntercityDriverDetailRoute extends PageRouteInfo<void> {
  const IntercityDriverDetailRoute({List<PageRouteInfo>? children})
    : super(IntercityDriverDetailRoute.name, initialChildren: children);

  static const String name = 'IntercityDriverDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityDriverDetailPage();
    },
  );
}

/// generated route for
/// [IntercityDriverLocationPage]
class IntercityDriverLocationRoute extends PageRouteInfo<void> {
  const IntercityDriverLocationRoute({List<PageRouteInfo>? children})
    : super(IntercityDriverLocationRoute.name, initialChildren: children);

  static const String name = 'IntercityDriverLocationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityDriverLocationPage();
    },
  );
}

/// generated route for
/// [IntercityDriversPage]
class IntercityDriversRoute extends PageRouteInfo<void> {
  const IntercityDriversRoute({List<PageRouteInfo>? children})
    : super(IntercityDriversRoute.name, initialChildren: children);

  static const String name = 'IntercityDriversRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityDriversPage();
    },
  );
}

/// generated route for
/// [IntercityExtraPage]
class IntercityExtraRoute extends PageRouteInfo<void> {
  const IntercityExtraRoute({List<PageRouteInfo>? children})
    : super(IntercityExtraRoute.name, initialChildren: children);

  static const String name = 'IntercityExtraRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityExtraPage();
    },
  );
}

/// generated route for
/// [IntercityOrderDetailsPage]
class IntercityOrderDetailsRoute extends PageRouteInfo<void> {
  const IntercityOrderDetailsRoute({List<PageRouteInfo>? children})
    : super(IntercityOrderDetailsRoute.name, initialChildren: children);

  static const String name = 'IntercityOrderDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityOrderDetailsPage();
    },
  );
}

/// generated route for
/// [IntercityPricePage]
class IntercityPriceRoute extends PageRouteInfo<void> {
  const IntercityPriceRoute({List<PageRouteInfo>? children})
    : super(IntercityPriceRoute.name, initialChildren: children);

  static const String name = 'IntercityPriceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityPricePage();
    },
  );
}

/// generated route for
/// [IntercityRateDriverPage]
class IntercityRateDriverRoute extends PageRouteInfo<void> {
  const IntercityRateDriverRoute({List<PageRouteInfo>? children})
    : super(IntercityRateDriverRoute.name, initialChildren: children);

  static const String name = 'IntercityRateDriverRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityRateDriverPage();
    },
  );
}

/// generated route for
/// [IntercityRegionPickPage]
class IntercityRegionPickRoute extends PageRouteInfo<void> {
  const IntercityRegionPickRoute({List<PageRouteInfo>? children})
    : super(IntercityRegionPickRoute.name, initialChildren: children);

  static const String name = 'IntercityRegionPickRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityRegionPickPage();
    },
  );
}

/// generated route for
/// [IntercityTimePage]
class IntercityTimeRoute extends PageRouteInfo<void> {
  const IntercityTimeRoute({List<PageRouteInfo>? children})
    : super(IntercityTimeRoute.name, initialChildren: children);

  static const String name = 'IntercityTimeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IntercityTimePage();
    },
  );
}

/// generated route for
/// [IntercityTripStatusPage]
class IntercityTripStatusRoute
    extends PageRouteInfo<IntercityTripStatusRouteArgs> {
  IntercityTripStatusRoute({
    Key? key,
    required IntercityTripStatus status,
    List<PageRouteInfo>? children,
  }) : super(
         IntercityTripStatusRoute.name,
         args: IntercityTripStatusRouteArgs(key: key, status: status),
         initialChildren: children,
       );

  static const String name = 'IntercityTripStatusRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<IntercityTripStatusRouteArgs>();
      return IntercityTripStatusPage(key: args.key, status: args.status);
    },
  );
}

class IntercityTripStatusRouteArgs {
  const IntercityTripStatusRouteArgs({this.key, required this.status});

  final Key? key;

  final IntercityTripStatus status;

  @override
  String toString() {
    return 'IntercityTripStatusRouteArgs{key: $key, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! IntercityTripStatusRouteArgs) return false;
    return key == other.key && status == other.status;
  }

  @override
  int get hashCode => key.hashCode ^ status.hashCode;
}

/// generated route for
/// [LanguagePage]
class LanguageRoute extends PageRouteInfo<void> {
  const LanguageRoute({List<PageRouteInfo>? children})
    : super(LanguageRoute.name, initialChildren: children);

  static const String name = 'LanguageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LanguagePage();
    },
  );
}

/// generated route for
/// [MainShellPage]
class MainShellRoute extends PageRouteInfo<void> {
  const MainShellRoute({List<PageRouteInfo>? children})
    : super(MainShellRoute.name, initialChildren: children);

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainShellPage();
    },
  );
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationsPage();
    },
  );
}

/// generated route for
/// [OrderDetailPage]
class OrderDetailRoute extends PageRouteInfo<OrderDetailRouteArgs> {
  OrderDetailRoute({
    Key? key,
    required OrderStatus status,
    List<PageRouteInfo>? children,
  }) : super(
         OrderDetailRoute.name,
         args: OrderDetailRouteArgs(key: key, status: status),
         initialChildren: children,
       );

  static const String name = 'OrderDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderDetailRouteArgs>();
      return OrderDetailPage(key: args.key, status: args.status);
    },
  );
}

class OrderDetailRouteArgs {
  const OrderDetailRouteArgs({this.key, required this.status});

  final Key? key;

  final OrderStatus status;

  @override
  String toString() {
    return 'OrderDetailRouteArgs{key: $key, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderDetailRouteArgs) return false;
    return key == other.key && status == other.status;
  }

  @override
  int get hashCode => key.hashCode ^ status.hashCode;
}

/// generated route for
/// [OtpPage]
class OtpRoute extends PageRouteInfo<void> {
  const OtpRoute({List<PageRouteInfo>? children})
    : super(OtpRoute.name, initialChildren: children);

  static const String name = 'OtpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OtpPage();
    },
  );
}

/// generated route for
/// [PaymentHistoryPage]
class PaymentHistoryRoute extends PageRouteInfo<void> {
  const PaymentHistoryRoute({List<PageRouteInfo>? children})
    : super(PaymentHistoryRoute.name, initialChildren: children);

  static const String name = 'PaymentHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaymentHistoryPage();
    },
  );
}

/// generated route for
/// [PhonePage]
class PhoneRoute extends PageRouteInfo<void> {
  const PhoneRoute({List<PageRouteInfo>? children})
    : super(PhoneRoute.name, initialChildren: children);

  static const String name = 'PhoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PhonePage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [TopUpPage]
class TopUpRoute extends PageRouteInfo<void> {
  const TopUpRoute({List<PageRouteInfo>? children})
    : super(TopUpRoute.name, initialChildren: children);

  static const String name = 'TopUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TopUpPage();
    },
  );
}

/// generated route for
/// [UserTypePage]
class UserTypeRoute extends PageRouteInfo<void> {
  const UserTypeRoute({List<PageRouteInfo>? children})
    : super(UserTypeRoute.name, initialChildren: children);

  static const String name = 'UserTypeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const UserTypePage();
    },
  );
}
