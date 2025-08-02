# دليل إعداد Git - Aymology Pro

## المشكلة
```
git : The term 'git' is not recognized as an internal or external command
```

## الحل السريع

### 1. تثبيت Git
1. اذهب إلى: https://git-scm.com/downloads
2. نزل النسخة المناسبة لنظامك (Windows)
3. شغل ملف التثبيت

### 2. إعدادات التثبيت المهمة
أثناء التثبيت، تأكد من اختيار:
- ✅ **Add Git to PATH** (مهم جداً!)
- ✅ **Git from the command line and also from 3rd-party software**
- ✅ **Use bundled OpenSSH**
- ✅ **Use the OpenSSL library**

### 3. التحقق من التثبيت
بعد التثبيت، افتح **PowerShell** أو **Command Prompt** جديد واكتب:
```bash
git --version
```

إذا ظهر رقم الإصدار، كل شيء تمام!

## رفع المشروع إلى GitHub

### 1. إنشاء Repository على GitHub
1. اذهب إلى: https://github.com
2. اضغط **New repository**
3. اكتب اسم المشروع: `aymologypro_new`
4. اختر **Public** أو **Private**
5. **لا** تضع README أو .gitignore
6. اضغط **Create repository**

### 2. رفع المشروع
افتح PowerShell في مجلد المشروع واكتب:

```bash
# تهيئة Git
git init

# إضافة جميع الملفات
git add .

# عمل commit أول
git commit -m "Initial commit - Aymology Pro App"

# إضافة remote repository
git remote add origin https://github.com/USERNAME/aymologypro_new.git

# تغيير اسم الفرع الرئيسي
git branch -M main

# رفع المشروع
git push -u origin main
```

**ملاحظة:** استبدل `USERNAME` باسم المستخدم الخاص بك على GitHub.

## أوامر Git الأساسية

### عرض حالة المشروع
```bash
git status
```

### إضافة ملفات جديدة
```bash
git add .
git add filename.dart
```

### حفظ التغييرات
```bash
git commit -m "وصف التغييرات"
```

### رفع التغييرات
```bash
git push
```

### تحميل التحديثات
```bash
git pull
```

## حل مشاكل Git شائعة

### مشكلة 1: "fatal: not a git repository"
```bash
git init
```

### مشكلة 2: "fatal: remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/USERNAME/aymologypro_new.git
```

### مشكلة 3: "fatal: refusing to merge unrelated histories"
```bash
git pull origin main --allow-unrelated-histories
```

## نصائح مهمة

1. **استخدم رسائل commit واضحة:**
```bash
git commit -m "إضافة شاشة المهام الجديدة"
git commit -m "إصلاح مشكلة في البومودورو"
git commit -m "تحديث التصميم"
```

2. **تحقق من التغييرات قبل الرفع:**
```bash
git status
git diff
```

3. **احفظ عملك بانتظام:**
```bash
git add .
git commit -m "حفظ التقدم"
git push
```

## ربط GitHub Actions

بعد رفع المشروع، GitHub Actions سيبني APK تلقائياً عند:
- كل push إلى main
- كل pull request
- تشغيل يدوي

للوصول إلى APK المبني:
1. اذهب إلى repository على GitHub
2. اختر **Actions** tab
3. اختر آخر workflow run
4. نزل APK من **Artifacts** 