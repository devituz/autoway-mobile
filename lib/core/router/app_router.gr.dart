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
