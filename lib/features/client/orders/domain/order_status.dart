import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Action circles shown on the order-detail screen.
enum OrderAction { cancel, location, call, telegram }

/// All order lifecycle states (Figma board 2210:27324). Each state drives the
/// order-detail screen's header color/label/icon, title/subtitle, action
/// circles and bottom buttons.
enum OrderStatus { pending, accepted, found, coming, delivering, delivered, onway, done }

extension OrderStatusX on OrderStatus {
  /// Colored header background (encodes progress).
  Color get color => switch (this) {
        OrderStatus.pending => AppColors.statusOrange,
        OrderStatus.accepted || OrderStatus.found => AppColors.statusGreen,
        OrderStatus.coming ||
        OrderStatus.delivering ||
        OrderStatus.onway =>
          AppColors.blue,
        OrderStatus.delivered || OrderStatus.done => AppColors.primary,
      };

  IconData get headerIcon => switch (this) {
        OrderStatus.pending => Icons.access_time,
        OrderStatus.accepted ||
        OrderStatus.found ||
        OrderStatus.coming =>
          Icons.directions_car_filled,
        OrderStatus.delivering || OrderStatus.onway => Icons.alt_route,
        OrderStatus.delivered || OrderStatus.done => Icons.flag,
      };

  String get labelKey => 'order.s_${name}_label';
  String get titleKey => 'order.s_${name}_title';
  String get subKey => 'order.s_${name}_sub';

  List<OrderAction> get actions => switch (this) {
        OrderStatus.pending => [OrderAction.cancel, OrderAction.call],
        OrderStatus.accepted => [
            OrderAction.cancel,
            OrderAction.telegram,
            OrderAction.call
          ],
        OrderStatus.found => [OrderAction.cancel, OrderAction.call],
        OrderStatus.coming => [
            OrderAction.cancel,
            OrderAction.location,
            OrderAction.call
          ],
        OrderStatus.delivering => [OrderAction.location, OrderAction.call],
        OrderStatus.onway => [OrderAction.location, OrderAction.call],
        OrderStatus.delivered => [OrderAction.call],
        OrderStatus.done => [OrderAction.call],
      };

  /// "Bekor qilish" red outline bottom button (only mid-acceptance).
  bool get showCancelButton => this == OrderStatus.accepted;

  /// "Etiroz bildirish" bottom button (every state except pending).
  bool get showComplain => this != OrderStatus.pending;

  /// "Baholash" bottom button (terminal / rating states).
  bool get showRate =>
      this == OrderStatus.delivered ||
      this == OrderStatus.onway ||
      this == OrderStatus.done;
}
