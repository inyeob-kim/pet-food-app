const fs = require('fs');
const path = require('path');

const distDir = path.join(__dirname, '..', 'dist');
const rootDir = path.join(__dirname, '..');

// 복사할 파일/폴더 목록
const filesToCopy = ['index.html', 'assets'];

// 기존 빌드 파일 삭제 (assets 폴더와 index.html만)
function cleanOldBuild() {
  const assetsDir = path.join(rootDir, 'assets');
  const indexHtml = path.join(rootDir, 'index.html');
  
  if (fs.existsSync(assetsDir)) {
    fs.rmSync(assetsDir, { recursive: true, force: true });
    console.log('✓ 기존 assets 폴더 삭제');
  }
  
  if (fs.existsSync(indexHtml)) {
    fs.unlinkSync(indexHtml);
    console.log('✓ 기존 index.html 삭제');
  }
}

// 파일/폴더 복사
function copyRecursive(src, dest) {
  const stat = fs.statSync(src);
  
  if (stat.isDirectory()) {
    if (!fs.existsSync(dest)) {
      fs.mkdirSync(dest, { recursive: true });
    }
    const files = fs.readdirSync(src);
    files.forEach(file => {
      copyRecursive(path.join(src, file), path.join(dest, file));
    });
  } else {
    fs.copyFileSync(src, dest);
  }
}

// 메인 로직
if (!fs.existsSync(distDir)) {
  console.error('❌ dist 폴더가 없습니다. 먼저 빌드를 실행하세요.');
  process.exit(1);
}

console.log('📦 빌드 파일을 루트로 복사 중...');

// 기존 빌드 파일 정리
cleanOldBuild();

// dist에서 루트로 복사
filesToCopy.forEach(item => {
  const src = path.join(distDir, item);
  const dest = path.join(rootDir, item);
  
  if (fs.existsSync(src)) {
    copyRecursive(src, dest);
    console.log(`✓ ${item} 복사 완료`);
  } else {
    console.warn(`⚠ ${item} 파일/폴더가 없습니다.`);
  }
});

console.log('✅ 빌드 파일 복사 완료!');
