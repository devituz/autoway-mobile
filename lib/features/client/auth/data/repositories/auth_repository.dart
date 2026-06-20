import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/storage/token_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_models.dart';

/// Auth use-cases for the register/login flow. Returns `Either<Failure, T>` so
/// the cubit never sees raw exceptions, and persists tokens on success.
class AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  AuthRepository(this._remote, this._tokenStorage);

  Future<Either<Failure, RequestOtpResult>> requestOtp(String phone) =>
      _guard(() => _remote.requestOtp(phone));

  Future<Either<Failure, AuthTokens>> verify({
    required String phone,
    required String code,
    String? fullName,
    String? birthDate,
    String? gender,
    String? role,
  }) =>
      _guard(() async {
        final tokens = await _remote.verify(
          phone: phone,
          code: code,
          fullName: fullName,
          birthDate: birthDate,
          gender: gender,
          role: role,
        );
        await _persist(tokens);
        return tokens;
      });

  Future<Either<Failure, AuthTokens>> refresh(String refreshToken) =>
      _guard(() async {
        final tokens = await _remote.refresh(refreshToken);
        await _persist(tokens);
        return tokens;
      });

  Future<Either<Failure, Unit>> logout() => _guard(() async {
        await _remote.logout();
        await _tokenStorage.clear();
        return unit;
      });

  Future<void> _persist(AuthTokens tokens) => _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

  /// Runs [action], translating typed exceptions into [Failure]s.
  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DioException catch (e) {
      // ErrorInterceptor wraps the typed exception in DioException.error.
      final inner = e.error;
      if (inner is NetworkException) return Left(NetworkFailure(inner.message));
      if (inner is ServerException) return Left(ServerFailure(inner.message));
      return const Left(ServerFailure());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
