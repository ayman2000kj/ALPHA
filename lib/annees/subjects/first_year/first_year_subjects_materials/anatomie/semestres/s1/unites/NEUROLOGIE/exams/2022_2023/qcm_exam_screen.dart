import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/qcm/unified_exam_widget.dart';
import 'package:aymologypro_new/widgets/qcm/qcm_widget.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/qcm_json_service.dart';

class QcmExamVascularisation2022_2023Screen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const QcmExamVascularisation2022_2023Screen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<QcmExamVascularisation2022_2023Screen> createState() =>
      _QcmExamVascularisation2022_2023ScreenState();
}

class _QcmExamVascularisation2022_2023ScreenState
    extends State<QcmExamVascularisation2022_2023Screen> {
  List<QcmQuestion> _questions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      // تحميل الأسئلة من ملف JSON الموحد لـ VASCULARISATION
      final questions =
          await QcmJsonService.instance.loadVascularisationQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des questions: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Chargement en cours...'),
            ],
          ),
        ),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Vérifiez votre connexion et réessayez',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Aucune question disponible',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }
    return UnifiedExamWidget(
      questions: _questions,
      examTitle: 'Examen Vascularisation 2022-2023',
      appThemeMode: widget.appThemeMode,
      onThemeChanged: widget.onThemeChanged,
      onExamCompleted: (answers) {
        // معالجة النتائج هنا
        print('Exam completed with answers: $answers');
      },
    );
  }
}
