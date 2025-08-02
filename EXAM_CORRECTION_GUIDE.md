# دليل نظام التصحيح

## نظرة عامة

نظام التصحيح في تطبيق AymologyPro مصمم لتصحيح الامتحانات بطريقة عادلة ودقيقة. النظام يدعم التصحيح الجزئي السلبي (Partielle Negative).

## كيفية عمل النظام

### 1. حساب النقاط

- **النقاط الإجمالية**: 20 نقطة مقسمة على عدد الأسئلة
- **النقطة لكل سؤال**: 20 ÷ عدد الأسئلة

### 2. قواعد التصحيح

#### التصحيح الجزئي السلبي:
- إذا كان السؤال يحتوي على 3 إجابات صحيحة واختار الطالب واحدة فقط، يأخذ 0.11 (إذا كانت النقطة 0.33)
- إذا اختار الطالب أي إجابة خاطئة، يفقد كل النقاط لهذا السؤال
- إذا لم يجيب الطالب على السؤال، يأخذ 0 نقطة

#### مثال:
```
سؤال بـ 3 إجابات صحيحة:
- النقطة الكاملة = 0.33
- إجابة صحيحة واحدة = 0.11
- إجابة خاطئة = 0 نقطة
- لا إجابة = 0 نقطة
```

### 3. حساب النتيجة النهائية

```dart
double totalScore = 0;
for (QuestionResult result in questionResults) {
  totalScore += result.score;
}
```

## استخدام النظام

### في الكود:

```dart
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

### هيكل البيانات:

```dart
class QcmQuestion {
  final int id;
  final String question;
  final List<String> options;
  final Set<int> correctAnswers;
  final double points;
}

class ExamResult {
  final double totalScore;
  final List<QuestionResult> questionResults;
  final int totalQuestions;
  final double maxScore;
}

class QuestionResult {
  final int questionId;
  final double score;
  final double maxScore;
  final bool isCorrect;
  final Set<int> studentAnswers;
  final Set<int> correctAnswers;
}
```

## الميزات

- **تصحيح دقيق**: حساب النقاط بدقة حسب قواعد التصحيح الجزئي السلبي
- **عرض تفصيلي**: عرض نتائج كل سؤال على حدة
- **إحصائيات**: عرض النتيجة النهائية ونسبة النجاح
- **إعادة الامتحان**: إمكانية إعادة الامتحان من جديد 