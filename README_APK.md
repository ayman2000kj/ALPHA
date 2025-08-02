# 🚀 بناء APK - Aymology Pro

## ⚡ الطريقة الأسرع (5 دقائق)

### 1. تثبيت Android Studio
- حمل من: https://developer.android.com/studio
- شغل الملف واتبع الخطوات
- تأكد من اختيار "Android SDK" أثناء التثبيت

### 2. بناء APK
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### 3. موقع APK
```
build/app/outputs/flutter-apk/app-release.apk
```

## 🌐 الطريقة السحابية (بدون تثبيت)

### 1. رفع المشروع على GitHub
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/[username]/aymologypro_new.git
git push -u origin main
```

### 2. استخدام Codemagic
- اذهب إلى: https://codemagic.io
- سجل حساب جديد
- اربط حساب GitHub
- اختر المشروع
- Codemagic سيبني APK تلقائياً

## 📱 معلومات التطبيق

### الميزات الجاهزة:
- ✅ **شاشة السنوات الطبية** - تصفح المواد الطبية
- ✅ **قائمة المهام** - إدارة المهام اليومية  
- ✅ **تقنية بومودورو** - مؤقت إنتاجية متقدم
- ✅ **المكتبة الرقمية** - كتب ومراجع طبية
- ✅ **واجهة عربية** - دعم كامل للغة العربية
- ✅ **الوضع المظلم** - دعم الوضع المظلم والفاتح

### المتطلبات:
- **Android**: API 21+ (Android 5.0+)
- **Flutter**: 3.16.0+
- **Java**: JDK 17+

## 🔧 حل المشاكل

### إذا ظهرت "No Android SDK found":
1. تأكد من تثبيت Android Studio
2. افتح Android Studio > SDK Manager
3. تأكد من تثبيت Android SDK Platform-Tools

### إذا فشل بناء Gradle:
```bash
flutter clean
flutter pub get
flutter build apk
```

## 🎯 التوصية

**الأفضل**: تثبيت Android Studio لبناء APK محلياً
**الأسرع**: استخدام Codemagic لبناء APK سحابياً

---

## 📞 الدعم

إذا واجهت أي مشاكل:
1. تأكد من وجود اتصال بالإنترنت
2. تأكد من تحديث Flutter
3. تأكد من تثبيت جميع التبعيات 