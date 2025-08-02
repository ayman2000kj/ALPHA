import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/exam_system/index.dart';
import 'package:aymologypro_new/shared/buttons/exam_year_buttons.dart';

/// شاشة الامتحان الكلي - تستخدم النظام المنظم الجديد
///
/// الميزات الجديدة:
/// - التمرير الحر بين الأسئلة
/// - إمكانية العودة وتعديل الإجابات
/// - مؤشر تقدم الأسئلة المجاب عليها
/// - عرض النتيجة فقط في النهاية
class ExamenCompletScreen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const ExamenCompletScreen({
    super.key,
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
          'Examen Complet',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.quiz,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Examen Complet',
                    style: GoogleFonts.montserrat(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toutes les unités dans un seul examen',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(179),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // اختيار سنة الامتحان
            Text(
              "Choisissez l'année de l'examen :",
              style: GoogleFonts.montserrat(
                fontSize: 22,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Choisissez l'année d'examen pour vous entraîner",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 32),

            // زر سنة الامتحان
            Container(
              height: 120,
              child: ExamYearButtonsList(
                examYears: ExamYearExamples.getDefaultYears(),
                onYearSelected: (year) {
                  // إعدادات الامتحان الكلي
                  final examSettings = ExamSettings(
                    examTimeMinutes: 120, // ساعتان
                    totalPoints: 20.0,
                    showTimer: true,
                    showNotes: true,
                    units: [
                      'anatomie_generale', // التشريح العام - تم إضافته
                      'osteologie', // علم العظام
                      'arthologie', // علم المفاصل
                      'myologie', // علم العضلات
                      'vascularisation' // التوعية الدموية
                    ], // الترتيب المطلوب
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompleteExamScreen(
                        settings: examSettings,
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
