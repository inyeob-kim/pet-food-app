import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  // iOS 시뮬레이터는 localhost 사용 가능
  // 실제 디바이스는 Mac의 로컬 IP 주소 필요 (예: http://192.168.x.x:8000/api/v1)
  static String get baseUrl {
    try {
      return dotenv.get('API_BASE_URL', fallback: 'http://localhost:8000/api/v1');
    } catch (e) {
      // dotenv가 초기화되지 않은 경우 기본값 반환
      return 'http://localhost:8000/api/v1';
    }
  }
  
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool isDevelopment = !isProduction;
  
  /// 실제 디바이스에서 사용할 Mac의 로컬 IP 주소
  /// Mac의 로컬 IP: 192.168.75.69 (ifconfig로 확인)
  /// iOS 시뮬레이터는 localhost 사용 가능하지만, 실제 디바이스는 Mac의 IP 필요
  static String get deviceBaseUrl {
    try {
      return dotenv.get('DEVICE_API_BASE_URL', fallback: 'http://192.168.75.69:8000/api/v1');
    } catch (e) {
      // dotenv가 초기화되지 않은 경우 기본값 반환
      return 'http://192.168.75.69:8000/api/v1';
    }
  }
}

