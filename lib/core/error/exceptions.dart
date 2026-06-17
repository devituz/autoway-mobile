/// Base exceptions thrown at the data/network level.
///
/// These are converted to [Failure]s in the data layer before reaching domain.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Serverda xatolik yuz berdi']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Keshda xatolik yuz berdi']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Internet aloqasi mavjud emas']);
}
