/// 에러 처리 유틸리티 - 단일 책임: Exception을 Failure로 변환
import '../error/failures.dart';
import '../error/exceptions.dart';

/// Exception을 Failure로 변환하는 공통 함수
/// 사용자 친화적인 메시지로 변환
Failure handleException(Exception exception) {
  if (exception is ServerException) {
    // 서버 에러 메시지가 이미 사용자 친화적이면 그대로 사용
    final message = exception.message;
    if (message.isNotEmpty && !message.contains('Exception') && !message.contains('Error')) {
      return ServerFailure(message);
    }
    return ServerFailure('서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
  } else if (exception is NetworkException) {
    return NetworkFailure('인터넷 연결을 확인해주세요. 네트워크가 연결되어 있는지 확인해주세요.');
  } else if (exception is CacheException) {
    return CacheFailure('데이터를 불러오는데 실패했습니다. 다시 시도해주세요.');
  } else {
    return ServerFailure('알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
  }
}
