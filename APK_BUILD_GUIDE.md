# دليل بناء APK - Aymology Pro

## 🎯 الحلول العملية لبناء APK

### ✅ الحل الأول: تثبيت Android Studio (الأفضل)

#### خطوات التثبيت:

1. **تحميل Android Studio**:
   - اذهب إلى: https://developer.android.com/studio
   - حمل أحدث إصدار (حوالي 1GB)

2. **تثبيت Android Studio**:
   - شغل الملف المحمل
   - اتبع خطوات التثبيت
   - تأكد من اختيار "Android SDK" أثناء التثبيت

3. **إعداد Android SDK**:
   - افتح Android Studio
   - اذهب إلى Tools > SDK Manager
   - تأكد من تثبيت:
     - ✅ Android SDK Platform-Tools
     - ✅ Android SDK Build-Tools  
     - ✅ Android SDK Platform (API 34)
     - ✅ Android SDK Platform (API 33)

4. **إعداد متغيرات البيئة**:
   ```bash
   set ANDROID_HOME=C:\Users\aymen\AppData\Local\Android\Sdk
   set PATH=%PATH%;%ANDROID_HOME%\platform-tools
   ```

5. **بناء APK**:
   ```bash
   flutter build apk --release
   ```

### ✅ الحل الثاني: استخدام خدمات البناء السحابية

#### 1. Codemagic (مجاني للاستخدام الشخصي)

1. **رفع المشروع على GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/[username]/aymologypro_new.git
   git push -u origin main
   ```

2. **ربط المشروع بـ Codemagic**:
   - اذهب إلى: https://codemagic.io
   - سجل حساب جديد
   - اربط حساب GitHub
   - اختر المشروع
   - Codemagic سيبني APK تلقائياً

#### 2. GitHub Actions

أنشئ ملف `.github/workflows/build.yml`:

```yaml
name: Build APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - run: flutter pub get
    
    - run: flutter build apk --release
    
    - uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

### ✅ الحل الثالث: استخدام Flutter Desktop (بديل مؤقت)

```bash
flutter build windows
```

**النتيجة**: تطبيق سطح المكتب يعمل على Windows
**الموقع**: `build/windows/runner/Release/aymologypro_new.exe`

### ✅ الحل الرابع: استخدام Flutter iOS (إذا كان لديك Mac)

```bash
flutter build ios
```

## 🚀 الخطوات السريعة لبناء APK

### الطريقة الأسرع:

1. **تثبيت Android Studio** (5 دقائق):
   - حمل من: https://developer.android.com/studio
   - شغل الملف واتبع الخطوات

2. **إعداد المشروع** (2 دقيقة):
   ```bash
   flutter clean
   flutter pub get
   ```

3. **بناء APK** (3 دقائق):
   ```bash
   flutter build apk --release
   ```

4. **موقع APK**:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

## 📱 معلومات التطبيق

### الميزات الجاهزة:
- ✅ **شاشة السنوات الطبية** - تصفح المواد الطبية
- ✅ **قائمة المهام** - إدارة المهام اليومية  
- ✅ **تقنية بومودورو** - مؤقت إنتاجية متقدم
- ✅ **المكتبة الرقمية** - كتب ومراجع طبية
- ✅ **واجهة عربية** - دعم كامل للغة العربية
- ✅ **الوضع المظلم** - دعم الوضع المظلم والفاتح

### المتطلبات التقنية:
- **الحد الأدنى لـ Android**: API 21 (Android 5.0)
- **Flutter**: 3.16.0 أو أحدث
- **Java**: JDK 17 أو أحدث

## 🔧 استكشاف الأخطاء

### إذا ظهرت رسالة "No Android SDK found":

1. تأكد من تثبيت Android Studio
2. افتح Android Studio > Settings > Appearance & Behavior > System Settings > Android SDK
3. تأكد من تحديد مسار SDK الصحيح

### إذا فشل بناء Gradle:

1. حذف مجلد .gradle:
   ```bash
   Remove-Item -Recurse -Force $env:USERPROFILE\.gradle
   ```

2. إعادة بناء المشروع:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
   ```

## 💡 نصائح مهمة

1. **تأكد من وجود اتصال بالإنترنت** أثناء التثبيت الأول
2. **قد يستغرق التثبيت الأول وقتاً أطول** لتحميل التبعيات
3. **للنسخ التجارية**، يجب توقيع APK بمفتاح خاص
4. **تأكد من تحديث Flutter** إلى أحدث إصدار

## 🎯 التوصية

**الأفضل**: تثبيت Android Studio لبناء APK محلياً
**الأسرع**: استخدام Codemagic لبناء APK سحابياً
**البديل**: بناء تطبيق سطح المكتب مؤقتاً 