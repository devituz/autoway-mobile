import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

/// Account type the user registers as (screen 2).
enum UserType { passenger, driver, serviceA, serviceB }

enum Gender { male, female }

/// Single immutable state carried across the whole register flow.
@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default('uz') String language,
    // Passenger pre-selected to match the design's default state.
    @Default(UserType.passenger) UserType userType,
    @Default('') String phone,
    @Default('') String otp,
    @Default('') String name,
    @Default('') String birthDate,
    Gender? gender,
  }) = _RegisterState;
}
