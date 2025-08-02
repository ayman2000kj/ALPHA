# دليل بناء APK - Aymology Pro

## المتطلبات الأساسية

### 1. تثبيت Flutter
```bash
# تحقق من إصدار Flutter
flutter --version

# إذا لم يكن مثبت، اتبع الدليل الرسمي:
# https://flutter.dev/docs/get-started/install
```

### 2. تثبيت Git
```bash
# تحقق من تثبيت Git
git --version

# إذا لم يكن مثبت، نزله من:
# https://git-scm.com/downloads
```

### 3. تثبيت Android Studio
- نزل Android Studio من: https://developer.android.com/studio
- ثبت Android SDK
- أضف Android SDK إلى PATH

## خطوات البناء

### 1. تحضير المشروع
```bash
# انتقل إلى مجلد المشروع
cd aymologypro_new

# احصل على التبعيات
flutter pub get

# تحقق من صحة المشروع
flutter doctor
```

### 2. بناء APK للتطوير
```bash
# بناء APK للتطوير (أسرع وأصغر)
flutter build apk --debug
```

### 3. بناء APK للإنتاج
```bash
# بناء APK للإنتاج (مُحسّن)
flutter build apk --release
```

### 4. بناء APK مقسم (للملفات الكبيرة)
```bash
# بناء APK مقسم (مفيد للملفات الكبيرة)
flutter build apk --split-per-abi --release
```

## حل المشاكل الشائعة

### مشكلة 1: "Build failed due to use of deleted Android v1 embedding"

**الحل:**
مشروعك محدث بالفعل إلى v2 embedding. تأكد من:
- استخدام أحدث إصدار من Flutter
- تنظيف المشروع وإعادة البناء

```bash
flutter clean
flutter pub get
flutter build apk --release
```

### مشكلة 2: "git is not recognized"

**الحل:**
1. نزل Git من: https://git-scm.com/downloads
2. أثناء التثبيت، اختر "Add Git to PATH"
3. أعد تشغيل Terminal/PowerShell
4. تحقق من التثبيت:
```bash
git --version
```

### مشكلة 3: مشاكل في الذاكرة
```bash
# زيادة ذاكرة Gradle
export GRADLE_OPTS="-Xmx4096m -XX:MaxPermSize=512m"
flutter build apk --release
```

### مشكلة 4: مشاكل في التوقيع
```bash
# استخدام مفتاح التطوير للتوقيع
flutter build apk --release --debug
```

## مواقع الملفات المبنية

بعد البناء الناجح، ستجد الـ APK في:
- **Debug APK:** `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK:** `build/app/outputs/flutter-apk/app-release.apk`
- **Split APKs:** `build/app/outputs/flutter-apk/`

## اختبار APK

### على جهاز حقيقي
```bash
# تثبيت APK على الجهاز المتصل
flutter install --release
```

### على محاكي
```bash
# تشغيل المحاكي أولاً
flutter emulators --launch <emulator_id>

# تثبيت APK
flutter install --release
```

## نصائح مهمة

1. **تأكد من تحديث Flutter:**
```bash
flutter upgrade
```

2. **تحقق من صحة المشروع:**
```bash
flutter doctor
flutter analyze
```

3. **للملفات الكبيرة، استخدم APK مقسم:**
```bash
flutter build apk --split-per-abi --release
```

4. **للتطوير السريع:**
```bash
flutter run --release
```

## بناء APK للـ GitHub Actions

المشروع يحتوي على ملف `.github/workflows/build.yml` الذي يبني APK تلقائياً عند:
- Push إلى main/master
- Pull Request
- تشغيل يدوي

للوصول إلى APK المبني:
1. اذهب إلى GitHub repository
2. اختر Actions tab
3. اختر آخر workflow run
4. نزل APK من Artifacts 