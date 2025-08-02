import 'dart:convert';
import 'package:flutter/services.dart';
import '../widgets/qcm/qcm_widget.dart';

/// Service for handling QCM (Multiple Choice Questions) data from JSON files
class QcmJsonService {
  static final QcmJsonService instance = QcmJsonService._();

  final Map<String, String> _unitPaths = {
    'anatomie_generale':
        'assets/data/anatomie_generale/questions_2022_2023.json',
    'osteologie': 'assets/data/osteologie/questions_2022_2023.json',
    'arthologie': 'assets/data/arthologie/questions_2022_2023.json',
    'myologie': 'assets/data/myologie/questions_2022_2023.json',
    'vascularisation': 'assets/data/vascularisation/questions_2022_2023.json',
    'biochimie': 'assets/data/biochimie/questions_2023_2024.json',
  };

  QcmJsonService._();

  /// تحميل الأسئلة من ملف JSON
  Future<List<QcmQuestion>> loadQuestionsFromJson(String jsonPath) async {
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> questionsData = jsonData['questions'] ?? [];
      if (questionsData.isEmpty) {
        throw Exception('لا توجد أسئلة في الملف: $jsonPath');
      }

      return questionsData.map((questionData) {
        final String id = questionData['id'] ?? '';
        final String question = questionData['question'] ?? '';
        final List<dynamic> optionsData = questionData['options'] ?? [];

        List<QcmOption> options = optionsData.map((optionData) {
          final String text = optionData['text'] ?? '';
          final bool isCorrect = optionData['isCorrect'] ?? false;
          return QcmOption(text: text, isCorrect: isCorrect);
        }).toList();

        return QcmQuestion(id: id, question: question, options: options);
      }).toList();
    } catch (e) {
      print('❌ خطأ في تحميل الأسئلة من JSON: $e');
      return [];
    }
  }

  /// تحميل أسئلة التشريح العام
  Future<List<QcmQuestion>> loadAnatomieGeneraleQuestions() async {
    return loadQuestionsFromJson(_unitPaths['anatomie_generale']!);
  }

  /// تحميل أسئلة حسب الوحدة
  Future<List<QcmQuestion>> loadQuestionsByUnit(String unit) async {
    final String? path = _unitPaths[unit.toLowerCase()];
    if (path == null) {
      throw Exception('وحدة غير معروفة: $unit\n'
          'الوحدات المتاحة: ${_unitPaths.keys.join(", ")}');
    }
    return loadQuestionsFromJson(path);
  }

  /// تحميل أسئلة أوستيولوجي
  Future<List<QcmQuestion>> loadOsteologieQuestions() async {
    return loadQuestionsFromJson(_unitPaths['osteologie']!);
  }

  /// تحميل أسئلة أرثولوجي
  Future<List<QcmQuestion>> loadArthologieQuestions() async {
    return loadQuestionsFromJson(_unitPaths['arthologie']!);
  }

  /// تحميل أسئلة ميولوجي
  Future<List<QcmQuestion>> loadMyologieQuestions() async {
    return loadQuestionsFromJson(_unitPaths['myologie']!);
  }

  /// تحميل أسئلة التوعية الدموية
  Future<List<QcmQuestion>> loadVascularisationQuestions() async {
    return loadQuestionsFromJson(_unitPaths['vascularisation']!);
  }

  /// تحميل أسئلة الكيمياء الحيوية
  Future<List<QcmQuestion>> loadBiochimieQuestions() async {
    return loadQuestionsFromJson(_unitPaths['biochimie']!);
  }

  /// الحصول على معلومات الاختبار
  Future<Map<String, dynamic>> getExamInfo(String jsonPath) async {
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return jsonData['exam_info'] ?? {};
    } catch (e) {
      print('❌ خطأ في تحميل معلومات الاختبار: $e');
      return {};
    }
  }

  /// الحصول على قائمة الوحدات المتاحة
  List<String> getAvailableUnits() {
    return _unitPaths.keys.toList();
  }

  /// إضافة وحدة جديدة (للمطورين)
  void addNewUnit(String unitName, String jsonPath) {
    print('📝 إضافة وحدة جديدة: $unitName -> $jsonPath');
    print('⚠️ يجب تحديث Map في loadQuestionsByUnit يدوياً');
  }
}
