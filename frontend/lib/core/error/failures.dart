import 'exceptions.dart';

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

Failure handleException(Exception exception) {
  if (exception is ServerException) {
    return ServerFailure(exception.message);
  } else if (exception is NetworkException) {
    return NetworkFailure(exception.message);
  } else if (exception is CacheException) {
    return CacheFailure(exception.message);
  } else {
    return ServerFailure('알 수 없는 오류가 발생했습니다.');
  }
}

