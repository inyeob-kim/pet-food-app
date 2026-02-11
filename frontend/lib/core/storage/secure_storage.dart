import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Secure Storage 래퍼 클래스
/// 
/// 웹 플랫폼에서는 shared_preferences를 사용하고,
/// 모바일 플랫폼에서는 FlutterSecureStorage를 사용합니다.
class SecureStorage {
  // 모바일용 SecureStorage
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // 웹용 SharedPreferences 인스턴스 (lazy initialization)
  static SharedPreferences? _webStorage;
  
  /// 웹용 SharedPreferences 초기화
  static Future<SharedPreferences> _getWebStorage() async {
    _webStorage ??= await SharedPreferences.getInstance();
    return _webStorage!;
  }

  /// 값 읽기
  static Future<String?> read(String key) async {
    try {
      print('[SecureStorage] read() called, key: $key, platform: ${kIsWeb ? "Web" : "Mobile"}');
      
      if (kIsWeb) {
        // 웹 플랫폼: SharedPreferences 사용
        final prefs = await _getWebStorage();
        final value = prefs.getString(key);
        print('[SecureStorage] read() completed (Web), key: $key, value: $value');
        return value;
      } else {
        // 모바일 플랫폼: FlutterSecureStorage 사용
        final value = await _storage.read(key: key);
        print('[SecureStorage] read() completed (Mobile), key: $key, value: $value');
        return value;
      }
    } catch (e) {
      print('[SecureStorage] read() error, key: $key, error: $e');
      return null;
    }
  }

  /// 값 쓰기
  static Future<void> write(String key, String value) async {
    try {
      print('[SecureStorage] write() called, key: $key, platform: ${kIsWeb ? "Web" : "Mobile"}');
      
      if (kIsWeb) {
        // 웹 플랫폼: SharedPreferences 사용
        final prefs = await _getWebStorage();
        await prefs.setString(key, value);
        print('[SecureStorage] write() completed (Web), key: $key');
      } else {
        // 모바일 플랫폼: FlutterSecureStorage 사용
        await _storage.write(key: key, value: value);
        print('[SecureStorage] write() completed (Mobile), key: $key');
      }
    } catch (e) {
      print('[SecureStorage] write() error, key: $key, error: $e');
      // 에러 처리
    }
  }

  /// 값 삭제
  static Future<void> delete(String key) async {
    try {
      if (kIsWeb) {
        final prefs = await _getWebStorage();
        await prefs.remove(key);
      } else {
        await _storage.delete(key: key);
      }
    } catch (e) {
      print('[SecureStorage] delete() error, key: $key, error: $e');
      // 에러 처리
    }
  }

  /// 모든 값 삭제
  static Future<void> deleteAll() async {
    try {
      if (kIsWeb) {
        final prefs = await _getWebStorage();
        await prefs.clear();
      } else {
        await _storage.deleteAll();
      }
    } catch (e) {
      print('[SecureStorage] deleteAll() error: $e');
      // 에러 처리
    }
  }
}
