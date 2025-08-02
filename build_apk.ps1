# بناء APK - Aymology Pro
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   بناء APK - Aymology Pro" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "[1/5] تنظيف المشروع..." -ForegroundColor Yellow
flutter clean

Write-Host ""
Write-Host "[2/5] تحميل التبعيات..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "[3/5] فحص صحة المشروع..." -ForegroundColor Yellow
flutter doctor

Write-Host ""
Write-Host "[4/5] بناء APK للإنتاج..." -ForegroundColor Yellow
flutter build apk --release

Write-Host ""
Write-Host "[5/5] فحص وجود APK..." -ForegroundColor Yellow
$apkPath = "build\app\outputs\flutter-apk\app-release.apk"

if (Test-Path $apkPath) {
    $fileSize = (Get-Item $apkPath).Length
    $fileSizeMB = [math]::Round($fileSize / 1MB, 2)
    
    Write-Host ""
    Write-Host "✅ تم بناء APK بنجاح!" -ForegroundColor Green
    Write-Host "📁 موقع الملف: $apkPath" -ForegroundColor White
    Write-Host "📏 حجم الملف: $fileSizeMB MB" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ فشل في بناء APK" -ForegroundColor Red
    Write-Host "🔍 تحقق من الأخطاء أعلاه" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Read-Host "اضغط Enter للخروج" 