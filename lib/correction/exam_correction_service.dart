import 'package:aymologypro_new/widgets/qcm/qcm_widget.dart';

class ExamCorrectionService {
  /// حساب النتيجة النهائية مع نظام التصحيح الجزئي السلبي
  ///
  /// [questions] - قائمة الأسئلة
  /// [studentAnswers] - إجابات الطالب (Map<questionIndex, Set<optionIndex>>)
  /// [totalPoints] - النقاط الكلية (افتراضي: 20)
  ///
  /// Returns: ExamResult object
  static ExamResult calculateResult({
    required List<QcmQuestion> questions,
    required Map<int, Set<int>> studentAnswers,
    double totalPoints = 20.0,
  }) {
    double totalScore = 0.0;
    int correctAnswers = 0;
    int partialAnswers = 0;
    int wrongAnswers = 0;
    int unansweredQuestions = 0;
    List<QuestionResult> questionResults = [];

    // نقاط لكل سؤال = النقاط الكلية / عدد الأسئلة
    final pointsPerQuestion = totalPoints / questions.length;

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final studentAnswer = studentAnswers[i] ?? <int>{};

      if (studentAnswer.isEmpty) {
        // سؤال لم يُجاب عليه
        unansweredQuestions++;
        questionResults.add(QuestionResult(
          questionIndex: i,
          score: 0.0,
          maxScore: pointsPerQuestion,
          isCorrect: false,
          isPartial: false,
          isUnanswered: true,
          hasWrongAnswer: false,
          correctSelected: 0,
          totalCorrect: 0,
        ));
        continue;
      }

      // حساب الإجابات الصحيحة والخاطئة
      final correctOptions = question.options
          .asMap()
          .entries
          .where((e) => e.value.isCorrect)
          .map((e) => e.key)
          .toSet();

      final wrongSelected =
          studentAnswer.any((index) => !correctOptions.contains(index));
      final correctSelected =
          studentAnswer.where((index) => correctOptions.contains(index)).length;
      final totalCorrect = correctOptions.length;

      double questionScore = 0.0;
      bool isCorrect = false;
      bool isPartial = false;
      bool isUnanswered = false;
      bool hasWrongAnswer = wrongSelected;

      if (wrongSelected) {
        // إذا اختار إجابة خاطئة، يفقد كل النقاط
        questionScore = 0.0;
        wrongAnswers++;
      } else if (correctSelected == totalCorrect) {
        // إجابة صحيحة كاملة
        questionScore = pointsPerQuestion;
        correctAnswers++;
        isCorrect = true;
      } else if (correctSelected > 0) {
        // إجابة جزئية صحيحة
        questionScore = (correctSelected / totalCorrect) * pointsPerQuestion;
        partialAnswers++;
        isPartial = true;
      } else {
        // لم يختر أي إجابة صحيحة
        questionScore = 0.0;
        wrongAnswers++;
      }

      totalScore += questionScore;

      questionResults.add(QuestionResult(
        questionIndex: i,
        score: questionScore,
        maxScore: pointsPerQuestion,
        isCorrect: isCorrect,
        isPartial: isPartial,
        isUnanswered: isUnanswered,
        hasWrongAnswer: hasWrongAnswer,
        correctSelected: correctSelected,
        totalCorrect: totalCorrect,
      ));
    }

    return ExamResult(
      totalScore: totalScore,
      maxScore: totalPoints,
      correctAnswers: correctAnswers,
      partialAnswers: partialAnswers,
      wrongAnswers: wrongAnswers,
      unansweredQuestions: unansweredQuestions,
      questionResults: questionResults,
      pointsPerQuestion: pointsPerQuestion,
    );
  }

  /// حساب النسبة المئوية للنجاح
  static double calculatePercentage(double score, double maxScore) {
    return (score / maxScore) * 100;
  }

  /// تحديد حالة النجاح
  static bool isPassed(double score, double maxScore,
      {double passThreshold = 10.0}) {
    return score >= passThreshold;
  }

  /// الحصول على تقرير مفصل للنتيجة
  static String getDetailedReport(ExamResult result) {
    final percentage = calculatePercentage(result.totalScore, result.maxScore);
    final isPassed =
        ExamCorrectionService.isPassed(result.totalScore, result.maxScore);

    return '''
Résultat détaillé:
- Note: ${result.totalScore.toStringAsFixed(2)}/${result.maxScore}
- Pourcentage: ${percentage.toStringAsFixed(1)}%
- Statut: ${isPassed ? 'Réussi' : 'Échoué'}
- Réponses correctes: ${result.correctAnswers}
- Réponses partielles: ${result.partialAnswers}
- Réponses incorrectes: ${result.wrongAnswers}
- Questions non répondues: ${result.unansweredQuestions}
''';
  }
}

/// نتيجة سؤال واحد
class QuestionResult {
  final int questionIndex;
  final double score;
  final double maxScore;
  final bool isCorrect;
  final bool isPartial;
  final bool isUnanswered;
  final bool hasWrongAnswer;
  final int correctSelected;
  final int totalCorrect;

  QuestionResult({
    required this.questionIndex,
    required this.score,
    required this.maxScore,
    required this.isCorrect,
    required this.isPartial,
    required this.isUnanswered,
    required this.hasWrongAnswer,
    required this.correctSelected,
    required this.totalCorrect,
  });

  /// الحصول على النسبة المئوية للسؤال
  double get percentage => (score / maxScore) * 100;

  /// الحصول على وصف الحالة
  String get status {
    if (isUnanswered) return 'Non répondu';
    if (hasWrongAnswer) return 'Incorrect (mauvaise réponse)';
    if (isCorrect) return 'Correct';
    if (isPartial) return 'Partiel';
    return 'Incorrect';
  }
}

/// النتيجة النهائية للامتحان
class ExamResult {
  final double totalScore;
  final double maxScore;
  final int correctAnswers;
  final int partialAnswers;
  final int wrongAnswers;
  final int unansweredQuestions;
  final List<QuestionResult> questionResults;
  final double pointsPerQuestion;

  ExamResult({
    required this.totalScore,
    required this.maxScore,
    required this.correctAnswers,
    required this.partialAnswers,
    required this.wrongAnswers,
    required this.unansweredQuestions,
    required this.questionResults,
    required this.pointsPerQuestion,
  });

  /// الحصول على النسبة المئوية
  double get percentage =>
      ExamCorrectionService.calculatePercentage(totalScore, maxScore);

  /// تحديد النجاح
  bool get isPassed => ExamCorrectionService.isPassed(totalScore, maxScore);

  /// الحصول على التقرير المفصل
  String get detailedReport => ExamCorrectionService.getDetailedReport(this);

  /// الحصول على إجمالي الأسئلة
  int get totalQuestions => questionResults.length;

  /// الحصول على الأسئلة المجاب عليها
  int get answeredQuestions => totalQuestions - unansweredQuestions;
}
