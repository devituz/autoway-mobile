/// Base class for all domain-level failures returned inside `Either<Failure, T>`.
///
/// Value equality is implemented by hand (no `equatable`) so two failures with
/// the same [message] compare equal — required for BLoC state comparisons.
sealed class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => runtimeType.hashCode ^ message.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Serverda xatolik']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Internet bilan aloqa yo\'q']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Kesh bilan bog\'liq xatolik']);
}
