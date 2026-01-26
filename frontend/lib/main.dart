/*
코드 생성 명령어:
flutter pub run build_runner build --delete-conflicting-outputs

DTO 모델의 fromJson/toJson 메서드를 생성하기 위해 위 명령어를 실행하세요.
모델 파일을 수정한 후에는 반드시 다시 실행해야 합니다.
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // .env 파일 로드
  await dotenv.load(fileName: ".env");
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
