# الأزرار المحسنة - Modern Buttons

هذا المجلد يحتوي على مجموعة من الأزرار المحسنة والمتطورة للتطبيق.

## المكونات المتاحة

### 1. ModernButton
زر أساسي محسن مع تأثيرات بصرية متقدمة.

**الخصائص:**
- تأثيرات حركية عند الضغط
- دعم للوضع المظلم والفاتح
- 4 أنماط مختلفة: elevated, filled, outlined, glass
- دعم للنص الفرعي
- إمكانية تعطيل الزر

**مثال الاستخدام:**
```dart
ModernButton(
  title: 'زر المثال',
  icon: Icons.star,
  color: Colors.blue,
  onTap: () => print('تم الضغط'),
  style: ButtonStyle.elevated,
  subtitle: 'نص فرعي اختياري',
)
```

### 2. SubjectUnitButton
زر مخصص لعرض المواد والوحدات الدراسية.

**الخصائص:**
- تصميم موحد للمواد والوحدات
- أيقونة دائرية مع تدرج لوني
- نص فرعي اختياري
- سهم للانتقال

**مثال الاستخدام:**
```dart
SubjectUnitButton(
  title: 'علم التشريح',
  icon: Icons.favorite,
  color: Colors.red,
  onTap: () => Navigator.push(...),
  subtitle: 'السنة الأولى',
)
```

### 3. CompactButton
زر صغير للإجراءات السريعة.

**الخصائص:**
- حجم صغير
- تصميم بسيط
- مناسب للإجراءات الثانوية

**مثال الاستخدام:**
```dart
CompactButton(
  title: 'إعدادات',
  icon: Icons.settings,
  color: Colors.grey,
  onTap: () => print('إعدادات'),
)
```

### 4. ModernFAB
زر عائم محسن.

**الخصائص:**
- تصميم متدرج
- تأثيرات ظل
- مناسب للإجراءات الرئيسية

**مثال الاستخدام:**
```dart
ModernFAB(
  icon: Icons.add,
  color: Colors.blue,
  onTap: () => print('إضافة'),
  tooltip: 'إضافة عنصر جديد',
)
```

### 5. ModernElevatedButton
زر عادي محسن مع تصميم موحد.

**الخصائص:**
- تصميم موحد مع باقي الأزرار
- دعم للأيقونة والنص
- قابلية تخصيص الألوان والأبعاد
- مناسب للأزرار العادية في التطبيق

**مثال الاستخدام:**
```dart
ModernElevatedButton(
  title: 'بدء الامتحان',
  icon: Icons.play_arrow,
  onTap: () => print('بدء'),
  backgroundColor: Colors.orange,
  foregroundColor: Colors.white,
)
```

## أنماط الأزرار

### ButtonStyle.elevated
زر مرتفع مع ظلال وتأثيرات بصرية.

### ButtonStyle.filled
زر مملوء بلون متدرج.

### ButtonStyle.outlined
زر محاط بإطار فقط.

### ButtonStyle.glass
زر زجاجي شفاف.

## التطبيق في المشروع

تم تطبيق الأزرار الجديدة في:
- شاشة السنوات الدراسية (`years_screen.dart`)
- شاشة المواد في السنة الأولى (`first_year_subjects.dart`)
- شاشة الوحدات في علم التشريح (`s1_screen.dart`)
- شاشة الوحدات في علم التشريح السيمستر الثاني (`s2_screen.dart`)
- شاشة البيو كيمياء (`biochimie_screen.dart`)

## المميزات

1. **تأثيرات حركية متقدمة**
2. **دعم كامل للوضع المظلم والفاتح**
3. **تصميم موحد ومتسق**
4. **سهولة الاستخدام والتخصيص**
5. **أداء محسن**
6. **قابلية إعادة الاستخدام**

## التطوير المستقبلي

- إضافة المزيد من الأنماط
- دعم للصور بدلاً من الأيقونات
- تأثيرات صوتية
- دعم للاهتزاز عند الضغط 