import 'package:dio/dio.dart';
import '../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final fullUrl = '${options.baseUrl}${options.path}';
    Logger.info('REQUEST[${options.method}] => URL: $fullUrl');
    Logger.debug('Headers: ${options.headers}');
    if (options.data != null) {
      Logger.debug('Data: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      Logger.debug('QueryParams: ${options.queryParameters}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.info(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    Logger.debug('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.error(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    Logger.error('Message: ${err.message}');
    if (err.response != null) {
      Logger.error('Response: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}

