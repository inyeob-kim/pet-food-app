# Pretendard 폰트 추가 가이드

## 폰트 다운로드

1. **GitHub Releases에서 다운로드**
   - https://github.com/orioncactus/pretendard/releases
   - 최신 버전의 `Pretendard-*.ttf` 파일 다운로드

2. **필요한 폰트 파일**
   - `Pretendard-Regular.ttf` (weight: 400)
   - `Pretendard-Medium.ttf` (weight: 500)
   - `Pretendard-SemiBold.ttf` (weight: 600)
   - `Pretendard-Bold.ttf` (weight: 700)

3. **파일 배치**
   - 이 디렉토리(`frontend/assets/fonts/`)에 폰트 파일을 복사

4. **pubspec.yaml 확인**
   - `pubspec.yaml`의 `fonts` 섹션이 활성화되어 있는지 확인
   - 파일명이 정확한지 확인

5. **앱 재시작**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 참고

- 폰트 파일이 없어도 앱은 실행됩니다 (시스템 폰트 fallback 사용)
- 하지만 토스 스타일을 완벽하게 구현하려면 Pretendard 폰트가 필요합니다
