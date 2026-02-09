import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // iOS 시뮬레이터는 localhost 사용 가능
  // 실제 디바이스는 Mac의 로컬 IP 주소 필요 (예: http://192.168.x.x:8000/api/v1)
  // .env 파일의 API_BASE_URL 값을 사용
  static String get baseUrl {
    // .env 파일에서 값을 읽어옴 (필수)
    return dotenv.get('API_BASE_URL');
  }
  
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool isDevelopment = !isProduction;
  
  /// 실제 디바이스에서 사용할 Mac의 로컬 IP 주소
  /// .env 파일의 DEVICE_API_BASE_URL 값을 사용
  /// iOS 시뮬레이터는 localhost 사용 가능하지만, 실제 디바이스는 Mac의 IP 필요
  static String get deviceBaseUrl {
    // .env 파일에서 값을 읽어옴 (필수)
    return dotenv.get('DEVICE_API_BASE_URL');
  }
}

