# حل مشكلة بناء APK - Aymology Pro

## المشكلة الحالية
يبدو أن هناك مشكلة في إعدادات Android SDK أو Flutter SDK.

## الحلول المقترحة

### الحل الأول: إعادة تثبيت Flutter

1. **تحميل Flutter SDK**:
   - اذهب إلى: https://docs.flutter.dev/get-started/install/windows
   - حمل أحدث إصدار من Flutter SDK
   - استخرج الملف في `C:\flutter`

2. **إعداد متغيرات البيئة**:
   ```
   FLUTTER_HOME=C:\flutter
   PATH=%PATH%;C:\flutter\bin
   ```

3. **تثبيت Android Studio**:
   - حمل Android Studio من: https://developer.android.com/studio
   - قم بتثبيته مع Android SDK

4. **إعداد Android SDK**:
   - افتح Android Studio
   - اذهب إلى Tools > SDK Manager
   - تأكد من تثبيت:
     - Android SDK Platform-Tools
     - Android SDK Build-Tools
     - Android SDK Platform (API 34)

### الحل الثاني: استخدام Android Studio

1. **فتح المشروع في Android Studio**:
   ```
   File > Open > اختر مجلد المشروع
   ```

2. **بناء APK من Android Studio**:
   ```
   Build > Build Bundle(s) / APK(s) > Build APK(s)
   ```

3. **موقع APK**:
   ```
   app/build/outputs/apk/debug/app-debug.apk
   ```

### الحل الثالث: استخدام Flutter Web

إذا لم تنجح الطرق السابقة، يمكنك بناء نسخة ويب:

```bash
flutter build web
```

### الحل الرابع: استخدام Flutter Desktop

```bash
flutter build windows
```

## خطوات مفصلة لبناء APK

### 1. التحقق من الإعدادات

```bash
# فتح PowerShell كمسؤول
flutter doctor -v
```

### 2. إصلاح المشاكل

```bash
# تنظيف المشروع
flutter clean

# إعادة تحميل التبعيات
flutter pub get

# تحديث Flutter
flutter upgrade
```

### 3. بناء APK

```bash
# بناء نسخة debug
flutter build apk --debug

# بناء نسخة release
flutter build apk --release
```

## معلومات التطبيق

### الميزات المضمنة:
- ✅ **شاشة السنوات الطبية**: تصفح المواد والمواضيع الطبية
- ✅ **قائمة المهام**: إدارة المهام اليومية
- ✅ **تقنية بومودورو**: مؤقت إنتاجية متقدم
- ✅ **المكتبة الرقمية**: كتب ومراجع طبية
- ✅ **واجهة عربية**: دعم كامل للغة العربية
- ✅ **الوضع المظلم**: دعم الوضع المظلم والفاتح

### المتطلبات التقنية:
- **الحد الأدنى لـ Android**: API 21 (Android 5.0)
- **Flutter**: 3.0 أو أحدث
- **Java**: JDK 17 أو أحدث

## استكشاف الأخطاء

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

### إذا ظهرت مشاكل في Java:

1. تأكد من تثبيت Java JDK 17
2. إعداد JAVA_HOME:
   ```bash
   set JAVA_HOME=C:\Program Files\Java\jdk-17
   ```

## بدائل لبناء APK

### 1. استخدام Flutter Web
```bash
flutter build web
```

### 2. استخدام Flutter Desktop
```bash
flutter build windows
```

### 3. استخدام Flutter iOS (إذا كان لديك Mac)
```bash
flutter build ios
```

## الدعم

إذا استمرت المشكلة:

1. **تحقق من إعدادات Flutter**:
   ```bash
   flutter doctor -v
   ```

2. **أعد تشغيل PowerShell كمسؤول**

3. **تأكد من وجود اتصال بالإنترنت**

4. **تحقق من مساحة القرص المتاحة** (يحتاج البناء لمساحة كافية)

## ملاحظات مهمة

- تأكد من وجود اتصال بالإنترنت أثناء البناء الأول
- قد يستغرق البناء الأول وقتاً أطول لتحميل التبعيات
- للنسخ التجارية، يجب توقيع APK بمفتاح خاص
- تأكد من تحديث Flutter إلى أحدث إصدار 