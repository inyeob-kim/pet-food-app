/// 에러 처리 유틸리티 - 단일 책임: Exception을 Failure로 변환
import '../error/failures.dart';
import '../error/exceptions.dart';

/// Exception을 Failure로 변환하는 공통 함수
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
