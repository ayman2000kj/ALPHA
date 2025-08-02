import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/qcm/unified_exam_widget.dart';
import 'package:aymologypro_new/widgets/qcm/qcm_widget.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/qcm_json_service.dart';

class BiochimieQcmExam20232024Screen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const BiochimieQcmExam20232024Screen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<BiochimieQcmExam20232024Screen> createState() =>
      _BiochimieQcmExam20232024ScreenState();
}

class _BiochimieQcmExam20232024ScreenState
    extends State<BiochimieQcmExam20232024Screen> {
  List<QcmQuestion> _questions = [];
  bool _isLoading = true;
  // bool _isUpdating = false;
  String? _error;
  // String _updateStatus = '';

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        // _updateStatus = 'جاري تحميل الأسئلة من JSON...';
      });

      // تحميل الأسئلة من ملف JSON
      final questions = await QcmJsonService.instance.loadBiochimieQuestions();

      setState(() {
        _questions = questions;
        _isLoading = false;
        // if (questions.isNotEmpty) {
        //   _updateStatus = '${questions.length} questions chargées';
        // } else {
        //   _updateStatus = 'Aucune question disponible';
        // }
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des questions: $e';
        _isLoading = false;
        // _updateStatus = 'Échec du chargement';
      });
      print('❌ Erreur lors du chargement des questions depuis JSON: $e');
    }
  }

  // Future<void> _forceUpdate() async {
  //   await _loadQuestions();
  // }

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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: null,
                child: Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Aucune question disponible')),
      );
    }

    return UnifiedExamWidget(
      questions: _questions,
      examTitle: 'Examen Biochimie 2023-2024',
      appThemeMode: widget.appThemeMode,
      onThemeChanged: widget.onThemeChanged,
      onExamCompleted: (answers) {
        // معالجة النتائج هنا
        print('Exam completed with answers: $answers');
      },
    );
  }
}
