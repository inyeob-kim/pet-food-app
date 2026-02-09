import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';

/// Device UID 생성 및 관리 서비스 (단일 진실 소스)
/// 
/// 모든 device_uid 접근은 이 서비스를 통해서만 수행해야 합니다.
/// 직접 SecureStorage.read/write('device_uid')를 호출하지 마세요.
class DeviceUidService {
  static const _uuid = Uuid();

  /// Device UID 가져오기 (없으면 생성)
  /// 
  /// 내부 동작:
  /// 1) 디버그 모드에서 .env의 DEVICE_UID 확인 (선택사항)
  /// 2) secureStorage.read('device_uid')
  /// 3) 없으면 UUID v4 생성
  /// 4) secureStorage.write('device_uid', uid)
  /// 5) return uid
  static Future<String> getOrCreate() async {
    // 디버그 모드에서 .env의 고정 UID 사용 (개발용)
    // .env에 DEVICE_UID가 설정되어 있으면 항상 우선 사용
    if (kDebugMode) {
      try {
        final devUid = dotenv.get('DEVICE_UID', fallback: '');
        if (devUid.isNotEmpty) {
          // .env의 값을 SecureStorage에도 저장하여 일관성 유지
          // 기존 값과 다르면 덮어쓰기 (개발용 고정 UID 우선)
          final existing = await SecureStorage.read(StorageKeys.deviceUid);
          if (existing != devUid) {
            await SecureStorage.write(StorageKeys.deviceUid, devUid);
            print('[DeviceUidService] 개발용 고정 UID 사용: ${devUid.substring(0, 8)}... (기존: ${existing?.substring(0, 8) ?? "없음"})');
          }
          return devUid;
        }
      } catch (e) {
        // .env에 DEVICE_UID가 없으면 기존 로직 사용
      }
    }

    // 기존 UID 확인
    final existingUid = await SecureStorage.read(StorageKeys.deviceUid);
    if (existingUid != null && existingUid.isNotEmpty) {
      return existingUid;
    }

    // 새 UID 생성
    final newUid = _uuid.v4();
    await SecureStorage.write(StorageKeys.deviceUid, newUid);
    print('[DeviceUidService] 새 UID 생성: ${newUid.substring(0, 8)}...');
    return newUid;
  }

  /// Device UID 가져오기 (생성하지 않음)
  static Future<String?> get() async {
    return await SecureStorage.read(StorageKeys.deviceUid);
  }

  /// Device UID 삭제 (디버그 빌드에서만 노출)
  /// 
  /// 주의: 디버그 빌드에서만 사용 가능합니다.
  static Future<void> reset() async {
    if (!kDebugMode) {
      throw StateError('reset()은 디버그 빌드에서만 사용 가능합니다.');
    }
    await SecureStorage.delete(StorageKeys.deviceUid);
    print('[DeviceUidService] UID 삭제 완료');
  }
}
