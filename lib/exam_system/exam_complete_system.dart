import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:aymologypro_new/widgets/qcm/qcm_widget.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';
import 'package:aymologypro_new/services/qcm_json_service.dart';
import 'package:aymologypro_new/correction/exam_correction_service.dart';

/// نظام الامتحان الكلي المنظم والمستقل
/// يمكن استخدامه في أي مكان في التطبيق
class ExamCompleteSystem {
  static const int DEFAULT_EXAM_TIME_MINUTES = 120; // ساعتان افتراضياً
}

/// إعدادات الامتحان
class ExamSettings {
  final int examTimeMinutes;
  final double totalPoints;
  final bool showTimer;
  final bool showNotes;
  final List<String> units;
  const ExamSettings({
    this.examTimeMinutes = ExamCompleteSystem.DEFAULT_EXAM_TIME_MINUTES,
    this.totalPoints = 20.0,
    this.showTimer = true,
    this.showNotes = true,
    required this.units,
  });
}

/// إحصائيات الامتحان
class ExamStatistics {
  final int totalQuestions;
  final int answeredQuestions;
  final int unansweredQuestions;
  final Map<String, int> unitStatistics;
  final double progressPercentage;

  const ExamStatistics({
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.unansweredQuestions,
    required this.unitStatistics,
    required this.progressPercentage,
  });
}

/// حالة السؤال
enum QuestionStatus {
  correct, // صحيح
  incorrect, // خطأ
  partial, // صحيح نسبياً
  unanswered // غير مجاب
}

/// إحصائيات مفصلة للسؤال
class QuestionStatistics {
  final int questionNumber;
  final String questionText;
  final QuestionStatus status;
  final double pointsEarned;
  final double totalPoints;
  final String unit;

  const QuestionStatistics({
    required this.questionNumber,
    required this.questionText,
    required this.status,
    required this.pointsEarned,
    required this.totalPoints,
    required this.unit,
  });
}

/// شاشة الإحصائيات المفصلة
class DetailedStatisticsScreen extends StatelessWidget {
  final List<QuestionStatistics> questionStats;
  final ExamResult examResult;
  final VoidCallback onRetry;
  final VoidCallback onBack;
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const DetailedStatisticsScreen({
    super.key,
    required this.questionStats,
    required this.examResult,
    required this.onRetry,
    required this.onBack,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        title: Text(
          'Statistiques Détaillées',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        actions: [
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            tooltip: 'Recommencer',
          ),
          IconButton(
            onPressed: () {
              ThemeService().toggleTheme();
            },
            icon: Icon(ThemeService().currentThemeIcon),
          ),
        ],
      ),
      body: Column(
        children: [
          // ملخص النتائج
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Résumé de l\'Examen',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            const Color(0xFF1976D2), // أزرق بدلاً من البنفسجي
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryCard(
                            'Score Total',
                            '${examResult.totalScore.toStringAsFixed(1)}/${examResult.maxScore}',
                            Icons.grade,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSummaryCard(
                            'Questions Correctes',
                            '${examResult.correctAnswers}',
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSummaryCard(
                            'Questions Incorrectes',
                            '${examResult.wrongAnswers}',
                            Icons.cancel,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // قائمة الأسئلة المفصلة
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: questionStats.length,
              itemBuilder: (context, index) {
                final stat = questionStats[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // رأس السؤال
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(stat.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Question ${stat.questionNumber}',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(26),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  stat.unit,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    color: const Color(
                                        0xFF1976D2), // أزرق بدلاً من البنفسجي
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(stat.status)
                                      .withAlpha(26),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _getStatusColor(stat.status),
                                  ),
                                ),
                                child: Text(
                                  _getStatusText(stat.status),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(stat.status),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // نص السؤال
                          Text(
                            stat.questionText,
                            style: GoogleFonts.montserrat(
                              fontSize: 16, // تكبير الخط من 14 إلى 16
                              fontWeight: FontWeight
                                  .w600, // زيادة الوزن من w500 إلى w600
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface, // إضافة لون واضح
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),

                          // النقاط
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: const Color(
                                    0xFF1976D2), // أزرق بدلاً من البنفسجي
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${stat.pointsEarned.toStringAsFixed(1)}/${stat.totalPoints} points',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14, // تكبير الخط من 12 إلى 14
                                  fontWeight: FontWeight.bold,
                                  color: const Color(
                                      0xFF1976D2), // أزرق بدلاً من البنفسجي
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // أزرار التحكم
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Retour'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recommencer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF1976D2), // أزرق بدلاً من البنفسجي
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              color: color.withAlpha(204),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(QuestionStatus status) {
    switch (status) {
      case QuestionStatus.correct:
        return Colors.green;
      case QuestionStatus.incorrect:
        return Colors.red;
      case QuestionStatus.partial:
        return Colors.orange;
      case QuestionStatus.unanswered:
        return Colors.grey;
    }
  }

  String _getStatusText(QuestionStatus status) {
    switch (status) {
      case QuestionStatus.correct:
        return 'CORRECT';
      case QuestionStatus.incorrect:
        return 'INCORRECT';
      case QuestionStatus.partial:
        return 'PARTIEL';
      case QuestionStatus.unanswered:
        return 'NON RÉPONDU';
    }
  }
}

/// شاشة الامتحان الكلي مع إمكانية التمرير الحر
class CompleteExamScreen extends StatefulWidget {
  final ExamSettings settings;
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const CompleteExamScreen({
    super.key,
    required this.settings,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<CompleteExamScreen> createState() => _CompleteExamScreenState();
}

class _CompleteExamScreenState extends State<CompleteExamScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  List<QcmQuestion> _allQuestions = [];
  Timer? _examTimer;
  int _remainingSeconds = 0;
  bool _isExamStarted = false;
  Map<int, Set<int>> _studentAnswers = {};
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.settings.examTimeMinutes * 60;
    _loadAllQuestions();
  }

  @override
  void dispose() {
    _examTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAllQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final qcmService = QcmJsonService.instance;

      // تحميل الأسئلة حسب الترتيب المطلوب
      final List<Future<List<QcmQuestion>>> futures = [];

      for (final unit in widget.settings.units) {
        switch (unit.toLowerCase()) {
          case 'osteologie':
            futures.add(qcmService.loadOsteologieQuestions());
            break;
          case 'arthologie':
            futures.add(qcmService.loadArthologieQuestions());
            break;
          case 'myologie':
            futures.add(qcmService.loadMyologieQuestions());
            break;
          case 'vascularisation':
            futures.add(qcmService.loadVascularisationQuestions());
            break;
          case 'anatomie_generale':
            futures.add(qcmService.loadAnatomieGeneraleQuestions());
            break;
        }
      }

      final List<List<QcmQuestion>> results = await Future.wait(futures);

      // دمج الأسئلة بالترتيب المطلوب
      _allQuestions = results.expand((questions) => questions).toList();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des questions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startExam() {
    setState(() {
      _isExamStarted = true;
    });

    // بدء المؤقت
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _finishExam();
      }
    });
  }

  void _finishExam() {
    _examTimer?.cancel();

    // حساب النتائج باستخدام نظام التصحيح المعقد
    final result = ExamCorrectionService.calculateResult(
      questions: _allQuestions,
      studentAnswers: _studentAnswers,
      totalPoints: widget.settings.totalPoints,
    );

    // إنشاء إحصائيات مفصلة
    final questionStats = _createDetailedStatistics(result);

    // عرض شاشة الإحصائيات المفصلة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedStatisticsScreen(
          questionStats: questionStats,
          examResult: result,
          onRetry: () {
            Navigator.of(context).pop();
            _restartExam();
          },
          onBack: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          appThemeMode: widget.appThemeMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }

  List<QuestionStatistics> _createDetailedStatistics(ExamResult result) {
    final List<QuestionStatistics> stats = [];

    for (int i = 0; i < _allQuestions.length; i++) {
      final question = _allQuestions[i];
      final studentAnswer = _studentAnswers[i];
      final questionResult = result.questionResults[i];

      // تحديد الوحدة
      final unitIndex = i % widget.settings.units.length;
      final unit = _getUnitDisplayName(widget.settings.units[unitIndex]);

      // تحديد حالة السؤال
      QuestionStatus status;
      if (studentAnswer == null || studentAnswer.isEmpty) {
        status = QuestionStatus.unanswered;
      } else if (questionResult.score == questionResult.maxScore) {
        status = QuestionStatus.correct;
      } else if (questionResult.score == 0) {
        status = QuestionStatus.incorrect;
      } else {
        status = QuestionStatus.partial;
      }

      stats.add(QuestionStatistics(
        questionNumber: i + 1,
        questionText: question.question,
        status: status,
        pointsEarned: questionResult.score,
        totalPoints: questionResult.maxScore,
        unit: unit,
      ));
    }

    return stats;
  }

  void _restartExam() {
    setState(() {
      _remainingSeconds = widget.settings.examTimeMinutes * 60;
      _studentAnswers.clear();
      _isExamStarted = false;
    });
    _loadAllQuestions();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // حساب الإحصائيات
  ExamStatistics _calculateStatistics() {
    final answeredQuestions = _studentAnswers.length;
    final totalQuestions = _allQuestions.length;
    final unansweredQuestions = totalQuestions - answeredQuestions;
    final progressPercentage =
        totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;

    // إحصائيات الوحدات
    final Map<String, int> unitStats = {};
    for (final unit in widget.settings.units) {
      unitStats[unit] = 0;
    }

    // حساب الأسئلة المجاب عليها لكل وحدة
    for (int i = 0; i < _allQuestions.length; i++) {
      if (_studentAnswers.containsKey(i)) {
        // تحديد الوحدة بناءً على ترتيب الأسئلة
        final unitIndex = i % widget.settings.units.length;
        final unit = widget.settings.units[unitIndex];
        unitStats[unit] = (unitStats[unit] ?? 0) + 1;
      }
    }

    return ExamStatistics(
      totalQuestions: totalQuestions,
      answeredQuestions: answeredQuestions,
      unansweredQuestions: unansweredQuestions,
      unitStatistics: unitStats,
      progressPercentage: progressPercentage,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
              Colors.transparent,
          elevation: 0,
          title: Text(
            'Examen Complet',
            style: GoogleFonts.montserrat(
              color: Theme.of(context).appBarTheme.foregroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          iconTheme: IconThemeData(
              color: Theme.of(context).appBarTheme.foregroundColor),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Chargement des questions...'),
            ],
          ),
        ),
      );
    }

    // بدء الامتحان مباشرة
    if (!_isExamStarted) {
      _startExam();
    }

    final statistics = _calculateStatistics();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Examen Complet',
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (widget.settings.showTimer) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _remainingSeconds <= 300 ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        actions: [
          IconButton(
            onPressed: () {
              ThemeService().toggleTheme();
            },
            icon: Icon(ThemeService().currentThemeIcon),
          ),
          IconButton(
            onPressed: _finishExam,
            icon: const Icon(Icons.stop),
            tooltip: 'Terminer l\'examen',
          ),
        ],
      ),
      body: Column(
        children: [
          // مؤشر التقدم البسيط
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Questions répondues: ',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: statistics.progressPercentage,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF1976D2), // أزرق بدلاً من البنفسجي
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${statistics.answeredQuestions}/${statistics.totalQuestions}',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // الأسئلة مع إمكانية التمرير الحر
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // تحسين الأداء
              physics: const ClampingScrollPhysics(),
              itemCount: _allQuestions.length,
              itemBuilder: (context, index) {
                final question = _allQuestions[index];
                final currentAnswers = _studentAnswers[index] ?? <int>{};

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(51),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رقم السؤال
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF1976D2), // أزرق بدلاً من البنفسجي
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Question ${index + 1} sur ${_allQuestions.length}',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14, // تكبير الخط من 12 إلى 14
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // السؤال
                      Text(
                        question.question,
                        style: GoogleFonts.montserrat(
                          fontSize: 18, // تكبير الخط من 16 إلى 18
                          fontWeight:
                              FontWeight.w600, // زيادة الوزن من w500 إلى w600
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface, // إضافة لون واضح
                        ),
                      ),

                      const SizedBox(height: 16),

                      // الخيارات
                      ...question.options.asMap().entries.map((optionEntry) {
                        final optionIndex = optionEntry.key;
                        final option = optionEntry.value;
                        final isSelected = currentAnswers.contains(optionIndex);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    currentAnswers.remove(optionIndex);
                                  } else {
                                    currentAnswers.add(optionIndex);
                                  }
                                  _studentAnswers[index] =
                                      Set.from(currentAnswers);
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF1976D2).withAlpha(
                                          26) // أزرق بدلاً من البنفسجي
                                      : null,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(
                                            0xFF1976D2) // أزرق بدلاً من البنفسجي
                                        : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? const Color(
                                              0xFF1976D2) // أزرق بدلاً من البنفسجي
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        option.text,
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              16, // تكبير الخط من 14 إلى 16
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight
                                                  .w500, // زيادة الوزن من normal إلى w500
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface, // إضافة لون واضح
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getUnitDisplayName(String unit) {
    switch (unit.toLowerCase()) {
      case 'osteologie':
        return 'Ostéologie';
      case 'arthologie':
        return 'Arthrologie';
      case 'myologie':
        return 'Myologie';
      case 'vascularisation':
        return 'Vascularisation';
      case 'anatomie_generale':
        return 'Anatomie Générale';
      default:
        return unit;
    }
  }
}
