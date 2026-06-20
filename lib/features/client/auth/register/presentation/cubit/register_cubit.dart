import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'register_state.dart';

/// Holds the data collected step-by-step during registration AND drives the
/// two async auth calls (request OTP → verify). Form mutations are plain CRUD;
/// the network actions emit [AuthStatus] transitions the screens listen to.
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterCubit(this._repository) : super(const RegisterState());

  void setLanguage(String language) => emit(state.copyWith(language: language));

  void setUserType(UserType type) => emit(state.copyWith(userType: type));

  void setPhone(String phone) => emit(state.copyWith(phone: phone));

  void setOtp(String otp) => emit(state.copyWith(otp: otp));

  void setName(String name) => emit(state.copyWith(name: name));

  void setBirthDate(String date) => emit(state.copyWith(birthDate: date));

  void setGender(Gender gender) => emit(state.copyWith(gender: gender));

  /// Resets the transient status so a screen can re-arm its BlocListener.
  void resetStatus() =>
      emit(state.copyWith(status: AuthStatus.initial, errorMessage: null));

  /// E.164 phone (`+998901112233`) from the 9 stored national digits.
  String get _e164Phone => '+998${state.phone}';

  /// Step 1 — request the SMS code. On success [AuthStatus.codeSent] carries
  /// [RegisterState.isRegistered] so the OTP screen knows login vs register.
  Future<void> requestOtp() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final res = await _repository.requestOtp(_e164Phone);
    res.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (data) => emit(state.copyWith(
          status: AuthStatus.codeSent, isRegistered: data.isRegistered)),
    );
  }

  /// Step 2 — verify the code. Sends profile fields only when registering a new
  /// user; existing users log in with phone + code only.
  Future<void> verify() async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    final res = await _repository.verify(
      phone: _e164Phone,
      code: state.otp,
      fullName: state.isRegistered ? null : state.name,
      birthDate: state.isRegistered ? null : _normalizeBirthDate(state.birthDate),
      gender: state.isRegistered ? null : state.gender?.name,
      role: state.isRegistered ? null : _role,
    );
    res.fold(
      (failure) => emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: failure.message)),
      (_) => emit(state.copyWith(status: AuthStatus.success)),
    );
  }

  /// Maps the selected account type to the backend `role` value.
  String get _role => state.userType == UserType.driver ? 'driver' : 'client';

  /// Backend expects ISO `yyyy-MM-dd`. The form accepts `dd.mm.yyyy` (and
  /// `dd/mm/yyyy`); anything already ISO or unrecognized is passed through.
  String _normalizeBirthDate(String input) {
    final m = RegExp(r'^(\d{2})[./](\d{2})[./](\d{4})$').firstMatch(input.trim());
    if (m != null) return '${m.group(3)}-${m.group(2)}-${m.group(1)}';
    return input.trim();
  }
}
