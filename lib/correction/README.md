# نظام التصحيح الموحد

هذا المجلد يحتوي على جميع مكونات نظام التصحيح المستخدم في تطبيق AymologyPro.

## الملفات

### 1. `exam_correction_service.dart`
الخدمة الرئيسية للتصحيح التي تحتوي على:
- `ExamCorrectionService` - حساب النتائج
- `ExamResult` - نموذج نتيجة الامتحان
- `QuestionResult` - نموذج نتيجة سؤال واحد

### 2. `exam_results_widget.dart`
Widgets لعرض النتائج:
- `ExamResultsWidget` - عرض النتائج النهائية
- `QuestionResultWidget` - عرض تفاصيل سؤال واحد

### 3. `index.dart`
ملف لتسهيل الاستيراد - يمكنك استيراد جميع المكونات مرة واحدة:
```dart
import 'package:aymologypro_new/correction/index.dart';
```

## كيفية الاستخدام

```dart
// استيراد النظام
import 'package:aymologypro_new/correction/index.dart';

// حساب النتائج
ExamResult result = ExamCorrectionService.calculateResult(
  questions: questions,
  studentAnswers: studentAnswers,
  totalPoints: 20.0,
);

// عرض النتائج
ExamResultsWidget(
  result: result,
  onRetry: () => // إعادة الامتحان,
  onBack: () => // العودة للصفحة السابقة,
)
```

## نظام التصحيح PARTIELLE NEGATIVE

- إذا كان السؤال يحتوي على 3 إجابات صحيحة واختار الطالب واحدة فقط، يأخذ 0.11 (إذا كانت النقطة 0.33)
- إذا اختار الطالب أي إجابة خاطئة، يفقد كل النقاط لهذا السؤال
- النقاط الإجمالية = 20 نقطة مقسمة على عدد الأسئلة 