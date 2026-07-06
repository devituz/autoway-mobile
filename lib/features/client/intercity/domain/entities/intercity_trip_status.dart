import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Action circles shown inside the trip-status card.
enum TripAction { cancel, location, telegram, call }

/// Optional header trailing element kind.
enum TripHeaderTrailing { icon, time }

/// All lifecycle states of the intercity (Viloyat taxi) trip-status screen
/// (Figma board, nodes 2174:14190 / 2177:14784 / 2183:10043 / 2183:10174 /
/// 2183:10297). Each state drives the colored status header, the title/subtitle,
/// the driver block, the action circles, the price/time card and the bottom
/// buttons via [IntercityTripStatusX].
enum IntercityTripStatus { awaiting, accepted, coming, onway, completed }

extension IntercityTripStatusX on IntercityTripStatus {
  /// Colored status-header background (encodes progress).
  Color get color => switch (this) {
        // Figma Warning/50 #F59E0B.
        IntercityTripStatus.awaiting => AppColors.orange,
        // Figma Success/50 #22C55E.
        IntercityTripStatus.accepted => AppColors.orderGreen,
        // Figma Blue/50 #3B82F6.
        IntercityTripStatus.coming || IntercityTripStatus.onway =>
          AppColors.orderBlue,
        // Figma Gray/50 #64748B.
        IntercityTripStatus.completed => AppColors.textMuted,
      };

  /// Header trailing: most states show a status icon; the time-tracked states
  /// (awaiting / onway) show an icon-or-clock + a HH:mm timestamp.
  TripHeaderTrailing get headerTrailing => switch (this) {
        IntercityTripStatus.awaiting || IntercityTripStatus.onway =>
          TripHeaderTrailing.time,
        _ => TripHeaderTrailing.icon,
      };

  /// SVG asset name (in assets/icons) for the header trailing icon.
  String get headerIcon => switch (this) {
        IntercityTripStatus.awaiting => 'id_ts_clock',
        IntercityTripStatus.accepted => 'ia_taxi',
        IntercityTripStatus.coming => 'od_driving',
        IntercityTripStatus.onway => 'id_ts_routing',
        IntercityTripStatus.completed => 'ia_flag',
      };

  /// Header timestamp (only used when [headerTrailing] is time).
  String get headerTime => switch (this) {
        IntercityTripStatus.awaiting => '09:26',
        IntercityTripStatus.onway => '09:36',
        _ => '',
      };

  String get labelKey => 'intercity.tstatus_${name}_label';
  String get titleKey => 'intercity.tstatus_${name}_title';
  String get subKey => 'intercity.tstatus_${name}_sub';

  /// Action circles, left-to-right (Figma per state).
  List<TripAction> get actions => switch (this) {
        IntercityTripStatus.awaiting => [TripAction.cancel, TripAction.call],
        IntercityTripStatus.accepted => [
            TripAction.cancel,
            TripAction.telegram,
            TripAction.call,
          ],
        IntercityTripStatus.coming => [
            TripAction.cancel,
            TripAction.location,
            TripAction.telegram,
            TripAction.call,
          ],
        IntercityTripStatus.onway => [TripAction.location, TripAction.call],
        IntercityTripStatus.completed => [TripAction.telegram, TripAction.call],
      };

  /// Strikethrough "old price" appears only before the trip starts.
  bool get showOldPrice =>
      this == IntercityTripStatus.awaiting || this == IntercityTripStatus.accepted;

  /// "Vaqti" value is muted once the trip is on the way / finished.
  bool get mutedTime =>
      this == IntercityTripStatus.onway || this == IntercityTripStatus.completed;

  /// Extra "Boshlanish vaqti" detail row (from the moment the trip starts).
  bool get showStartTime =>
      this == IntercityTripStatus.onway || this == IntercityTripStatus.completed;

  /// Extra "Yakunlandi" detail row (terminal state only).
  bool get showFinishTime => this == IntercityTripStatus.completed;

  /// Red outline "Bekor qilish" bottom button.
  bool get showCancelButton =>
      this == IntercityTripStatus.accepted || this == IntercityTripStatus.coming;

  /// Grey "Etiroz bildirish" bottom button (every state except awaiting).
  bool get showComplain => this != IntercityTripStatus.awaiting;

  /// Brand outline "Baholash" bottom button (trip running / finished).
  bool get showRate =>
      this == IntercityTripStatus.onway || this == IntercityTripStatus.completed;
}
