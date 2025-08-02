# الأزرار المشتركة - Shared Buttons

هذا المجلد يحتوي على جميع الأزرار المشتركة المستخدمة في التطبيق.

## المكونات المتاحة

### 1. AppButton - الزر الأساسي المشترك
زر متعدد الاستخدامات مع 6 أنماط مختلفة.

**الخصائص:**
- `title`: نص الزر
- `icon`: أيقونة الزر (اختياري)
- `onTap`: دالة الضغط
- `style`: نمط الزر (AppButtonStyle)
- `color`: لون الزر
- `isEnabled`: تفعيل/تعطيل الزر
- `width/height`: أبعاد الزر
- `subtitle`: نص فرعي (اختياري)
- `showArrow`: إظهار سهم (اختياري)

**الأنماط المتاحة:**
- `AppButtonStyle.primary`: زر أساسي مع خلفية ملونة
- `AppButtonStyle.secondary`: زر ثانوي مع إطار
- `AppButtonStyle.outline`: زر محاط بإطار رفيع
- `AppButtonStyle.text`: زر نصي فقط
- `AppButtonStyle.icon`: زر أيقونة فقط
- `AppButtonStyle.fab`: زر عائم دائري

**مثال الاستخدام:**
```dart
AppButton(
  title: 'زر المثال',
  icon: Icons.star,
  onTap: () => print('تم الضغط'),
  style: AppButtonStyle.primary,
  color: Colors.blue,
  subtitle: 'نص فرعي',
  showArrow: true,
)
```

### 2. SubjectButton - زر مخصص للمواد
زر مخصص لعرض المواد والوحدات الدراسية.

**الخصائص:**
- `title`: اسم المادة
- `icon`: أيقونة المادة
- `color`: لون المادة
- `onTap`: دالة الضغط
- `subtitle`: السنة الدراسية (اختياري)

**مثال الاستخدام:**
```dart
SubjectButton(
  title: 'علم التشريح',
  icon: Icons.favorite,
  color: Colors.red,
  onTap: () => Navigator.push(...),
  subtitle: 'السنة الأولى',
)
```

### 3. CompactButton - زر صغير
زر صغير للإجراءات السريعة.

**الخصائص:**
- `title`: نص الزر
- `icon`: أيقونة الزر
- `onTap`: دالة الضغط
- `color`: لون الزر

**مثال الاستخدام:**
```dart
CompactButton(
  title: 'إعدادات',
  icon: Icons.settings,
  color: Colors.grey,
  onTap: () => print('إعدادات'),
)
```

## التطبيق في الشاشات

### شاشة السنوات الدراسية
```dart
SubjectButton(
  title: 'السنة الأولى',
  icon: Icons.school,
  color: Colors.blue,
  onTap: () => Navigator.push(...),
  subtitle: '6 مواد',
)
```

### شاشة المواد
```dart
SubjectButton(
  title: 'علم التشريح',
  icon: Icons.favorite,
  color: Colors.red,
  onTap: () => Navigator.push(...),
  subtitle: 'السنة الأولى',
)
```

### أزرار الإجراءات
```dart
AppButton(
  title: 'بدء الامتحان',
  icon: Icons.play_arrow,
  onTap: () => startExam(),
  style: AppButtonStyle.primary,
  color: Colors.green,
)
```

## المميزات

1. **تصميم موحد**: جميع الأزرار تتبع نفس التصميم
2. **تأثيرات حركية**: تأثيرات عند الضغط والتحرير
3. **دعم الوضع المظلم**: يتكيف مع الوضع المظلم والفاتح
4. **قابلية التخصيص**: ألوان وأحجام قابلة للتخصيص
5. **سهولة الاستخدام**: واجهة بسيطة وواضحة
6. **أداء محسن**: تأثيرات حركية محسنة

## التطوير المستقبلي

- إضافة المزيد من الأنماط
- دعم للصور بدلاً من الأيقونات
- تأثيرات صوتية
- دعم للاهتزاز عند الضغط
- إضافة أزرار متقدمة (مثل أزرار التحميل)

## كيفية الاستخدام

1. استورد الملف:
```dart
import 'package:aymologypro_new/shared/buttons/app_buttons.dart';
```

2. استخدم الزر المناسب:
```dart
AppButton(
  title: 'نص الزر',
  icon: Icons.star,
  onTap: () => yourFunction(),
  style: AppButtonStyle.primary,
  color: Colors.blue,
)
```

3. للمواد والوحدات:
```dart
SubjectButton(
  title: 'اسم المادة',
  icon: Icons.science,
  color: Colors.red,
  onTap: () => navigateToSubject(),
  subtitle: 'السنة الدراسية',
)
``` 