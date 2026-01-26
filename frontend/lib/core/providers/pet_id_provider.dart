import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 현재 선택된 반려동물 ID를 관리하는 프로바이더
/// TODO: 실제로는 SharedPreferences나 로컬 DB에서 가져와야 함
final currentPetIdProvider = StateProvider<String?>((ref) {
  // MVP에서는 null 반환 (나중에 실제 저장소에서 가져오도록 구현)
  return null;
});

