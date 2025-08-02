@echo off
echo ========================================
echo    بناء APK - Aymology Pro
echo ========================================

echo.
echo [1/5] تنظيف المشروع...
flutter clean

echo.
echo [2/5] تحميل التبعيات...
flutter pub get

echo.
echo [3/5] فحص صحة المشروع...
flutter doctor

echo.
echo [4/5] بناء APK للإنتاج...
flutter build apk --release

echo.
echo [5/5] فحص وجود APK...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ✅ تم بناء APK بنجاح!
    echo 📁 موقع الملف: build\app\outputs\flutter-apk\app-release.apk
    echo 📏 حجم الملف:
    for %%A in ("build\app\outputs\flutter-apk\app-release.apk") do echo    %%~zA bytes
) else (
    echo.
    echo ❌ فشل في بناء APK
    echo 🔍 تحقق من الأخطاء أعلاه
)

echo.
echo ========================================
pause 