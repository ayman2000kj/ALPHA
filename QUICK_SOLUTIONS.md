# حلول سريعة - Aymology Pro

## 🚀 بناء APK فوري

### الطريقة الأولى: سكريبت تلقائي
```bash
# شغل ملف البناء التلقائي
.\build_apk.bat
```

### الطريقة الثانية: أوامر يدوية
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## 🔧 حل المشاكل الشائعة

### مشكلة 1: "Build failed due to use of deleted Android v1 embedding"
**الحل:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### مشكلة 2: "git is not recognized"
**الحل:**
1. نزل Git: https://git-scm.com/downloads
2. اختر "Add Git to PATH" أثناء التثبيت
3. أعد تشغيل PowerShell
4. تحقق: `git --version`

### مشكلة 3: "No Android SDK found"
**الحل:**
1. نزل Android Studio: https://developer.android.com/studio
2. ثبت Android SDK
3. أضف إلى PATH:
```bash
set ANDROID_HOME=C:\Users\[USERNAME]\AppData\Local\Android\Sdk
set PATH=%PATH%;%ANDROID_HOME%\platform-tools
```

### مشكلة 4: "Gradle build failed"
**الحل:**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter build apk --release
```

### مشكلة 5: "Out of memory"
**الحل:**
```bash
set GRADLE_OPTS="-Xmx4096m -XX:MaxPermSize=512m"
flutter build apk --release
```

## 📱 اختبار APK

### على جهاز حقيقي
```bash
flutter install --release
```

### على محاكي
```bash
flutter emulators --launch <emulator_id>
flutter install --release
```

## 🔄 رفع المشروع إلى GitHub

### إعداد Git
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/USERNAME/aymologypro_new.git
git push -u origin main
```

### تحديث المشروع
```bash
git add .
git commit -m "تحديث جديد"
git push
```

## 📊 فحص صحة المشروع

```bash
flutter doctor
flutter analyze
flutter test
```

## 🎯 نصائح سريعة

1. **للتطوير السريع:**
```bash
flutter run --release
```

2. **للملفات الكبيرة:**
```bash
flutter build apk --split-per-abi --release
```

3. **للتحديث:**
```bash
flutter upgrade
flutter pub upgrade
```

4. **للمشاكل المستعصية:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## 📞 الدعم السريع

إذا استمرت المشكلة:
1. تأكد من تحديث Flutter: `flutter upgrade`
2. تحقق من الإعدادات: `flutter doctor`
3. امسح الكاش: `flutter clean`
4. أعد بناء المشروع: `flutter build apk --release` 