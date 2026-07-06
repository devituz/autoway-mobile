/// Data models for the auth endpoints (swagger: vio.delgo.uz/api).
///
/// All endpoints return the `{data, error, meta, request_id}` envelope; these
/// models map the `data` payload only — unwrapping happens in the data source.
library;

/// `POST /v1/auth/check` → data. Tells which branch to take next.
class CheckPhoneResult {
  final bool isRegistered;
  final bool isActive;

  const CheckPhoneResult({required this.isRegistered, required this.isActive});

  factory CheckPhoneResult.fromJson(Map<String, dynamic> json) =>
      CheckPhoneResult(
        isRegistered: json['is_registered'] as bool? ?? false,
        isActive: json['is_active'] as bool? ?? true,
      );
}

/// `POST /v1/auth/{login,register}/request` → data.
class RequestOtpResult {
  /// Whether the phone already has an account (login) or not (register).
  final bool isRegistered;

  /// Seconds the SMS code stays valid.
  final int expiresIn;

  const RequestOtpResult({
    required this.isRegistered,
    required this.expiresIn,
  });

  factory RequestOtpResult.fromJson(Map<String, dynamic> json) =>
      RequestOtpResult(
        isRegistered: json['is_registered'] as bool? ?? false,
        expiresIn: (json['expires_in'] as num?)?.toInt() ?? 0,
      );
}

/// `auth.UserResponse`.
class AuthUser {
  final int id;
  final String fullName;
  final String firstName;
  final String lastName;
  final String middleName;
  final String phone;
  final String gender;
  final String birthDate;
  final String avatarUrl;
  final num balance;
  final int idBalance;
  final String language;
  final List<String> roles;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.avatarUrl,
    required this.balance,
    required this.idBalance,
    required this.language,
    required this.roles,
  });

  AuthUser copyWith({
    num? balance,
    String? avatarUrl,
    String? fullName,
    String? firstName,
    String? lastName,
  }) =>
      AuthUser(
        id: id,
        fullName: fullName ?? this.fullName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName,
        phone: phone,
        gender: gender,
        birthDate: birthDate,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        balance: balance ?? this.balance,
        idBalance: idBalance,
        language: language,
        roles: roles,
      );

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final first = json['first_name'] as String? ?? '';
    final last = json['last_name'] as String? ?? '';
    final full = json['full_name'] as String? ?? '';
    return AuthUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      // Prefer the server's full_name; fall back to first+last if absent.
      fullName: full.isNotEmpty ? full : '$first $last'.trim(),
      firstName: first,
      lastName: last,
      middleName: json['middle_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      birthDate: json['birth_date'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      balance: json['balance'] as num? ?? 0,
      idBalance: (json['id_balance'] as num?)?.toInt() ?? 0,
      language: json['language'] as String? ?? 'uz',
      roles: (json['roles'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
    );
  }
}

/// `POST /v1/auth/verify` & `/refresh` → data (`auth.TokenResponse`).
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final bool isNewUser;
  final AuthUser? user;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.isNewUser = false,
    this.user,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['access_token'] as String? ?? '',
        refreshToken: json['refresh_token'] as String? ?? '',
        expiresIn: (json['expires_in'] as num?)?.toInt() ?? 0,
        isNewUser: json['is_new_user'] as bool? ?? false,
        user: json['user'] is Map<String, dynamic>
            ? AuthUser.fromJson(json['user'] as Map<String, dynamic>)
            : null,
      );
}
