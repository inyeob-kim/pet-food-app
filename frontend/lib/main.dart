/*
코드 생성 명령어:
flutter pub run build_runner build --delete-conflicting-outputs

DTO 모델의 fromJson/toJson 메서드를 생성하기 위해 위 명령어를 실행하세요.
모델 파일을 수정한 후에는 반드시 다시 실행해야 합니다.
*/

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // .env 파일 로드 (파일이 없어도 에러가 나지 않도록 처리)
  if (!kIsWeb) {
    // 네이티브 플랫폼에서만 파일 시스템에서 로드
    // iOS/Android 앱 빌드 시 assets에 포함된 .env 파일은
    // flutter_dotenv가 자동으로 찾지 않으므로 파일 시스템에서 로드
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      // .env 파일이 없어도 앱이 실행되도록 함
      // Env 클래스에서 try-catch로 기본값을 사용함
      debugPrint("Warning: .env file not found. Using default values. Error: $e");
    }
  } else {
    // 웹에서는 assets에서 로드 시도 (현재는 기본값 사용)
    debugPrint("Web platform: Using default values from Env class.");
  }
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
