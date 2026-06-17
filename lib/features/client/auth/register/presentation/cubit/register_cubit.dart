import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_state.dart';

/// Holds the data collected step-by-step during registration.
///
/// Pure CRUD over the form state → Cubit (per project convention; BLoC is
/// reserved for event-transforming flows like search/map tracking).
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  void setLanguage(String language) => emit(state.copyWith(language: language));

  void setUserType(UserType type) => emit(state.copyWith(userType: type));

  void setPhone(String phone) => emit(state.copyWith(phone: phone));

  void setOtp(String otp) => emit(state.copyWith(otp: otp));

  void setName(String name) => emit(state.copyWith(name: name));

  void setBirthDate(String date) => emit(state.copyWith(birthDate: date));

  void setGender(Gender gender) => emit(state.copyWith(gender: gender));
}
