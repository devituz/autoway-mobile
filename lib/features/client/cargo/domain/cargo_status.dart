import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Action circles shown inside the cargo status card.
enum CargoAction { cancel, location, telegram, call }

/// Optional header trailing element kind.
enum CargoHeaderTrailing { none, icon, time }

/// All lifecycle states of the cargo (Pochta / Yuk yetkazma) status screen
/// (Figma board, nodes 2187:22022 / 2187:20751 / 2189:23087 / 2189:23381 /
/// 2189:23708 / 2189:23844). Each state drives the colored status header, the
/// title/subtitle, the driver block, the action circles, the price box and the
/// bottom buttons via [CargoStatusX].
enum CargoStatus { awaiting, found, foundTaxi, coming, delivering, delivered }

extension CargoStatusX on CargoStatus {
  /// Colored status-header background (encodes progress).
  Color get color => switch (this) {
        // Figma Warning/50 #F59E0B.
        CargoStatus.awaiting => AppColors.orange,
        // Figma Success/50 #22C55E — closest token is statusGreen (#2FBF71).
        CargoStatus.found || CargoStatus.foundTaxi => AppColors.statusGreen,
        // Figma Blue/50 #3B82F6 — closest token is blue (#2F6BFF).
        CargoStatus.coming || CargoStatus.delivering => AppColors.blue,
        // Figma Gray/80 #1E293B.
        CargoStatus.delivered => AppColors.primary,
      };

  /// Header trailing element: awaiting shows an icon + clock time; most states
  /// show a status icon; [found] shows nothing.
  CargoHeaderTrailing get headerTrailing => switch (this) {
        CargoStatus.awaiting => CargoHeaderTrailing.time,
        CargoStatus.found => CargoHeaderTrailing.none,
        _ => CargoHeaderTrailing.icon,
      };

  /// SVG asset name (in assets/icons) for the header trailing icon.
  String get headerIcon => switch (this) {
        CargoStatus.awaiting => 'id_ts_clock',
        CargoStatus.found => '',
        CargoStatus.foundTaxi => 'ia_taxi',
        CargoStatus.coming => 'od_driving',
        CargoStatus.delivering => 'id_ts_routing',
        CargoStatus.delivered => 'ia_flag',
      };

  /// Header timestamp (only used when [headerTrailing] is time).
  String get headerTime => this == CargoStatus.awaiting ? '09:26' : '';

  String get labelKey => 'cargo.cstatus_${name}_label';
  String get titleKey => 'cargo.cstatus_${name}_title';
  String get subKey => 'cargo.cstatus_${name}_sub';

  /// Action circles, left-to-right (Figma per state).
  List<CargoAction> get actions => switch (this) {
        CargoStatus.awaiting => [CargoAction.cancel, CargoAction.call],
        CargoStatus.found => [
            CargoAction.cancel,
            CargoAction.location,
            CargoAction.telegram,
            CargoAction.call,
          ],
        CargoStatus.foundTaxi => [CargoAction.cancel, CargoAction.call],
        CargoStatus.coming => [
            CargoAction.cancel,
            CargoAction.location,
            CargoAction.call,
          ],
        CargoStatus.delivering => [CargoAction.location, CargoAction.call],
        CargoStatus.delivered => [CargoAction.call],
      };

  /// Grey "Etiroz bildirish" bottom button (present in every state).
  bool get showComplain => true;

  /// Brand outline "Baholash" bottom button (terminal state only).
  bool get showRate => this == CargoStatus.delivered;
}
