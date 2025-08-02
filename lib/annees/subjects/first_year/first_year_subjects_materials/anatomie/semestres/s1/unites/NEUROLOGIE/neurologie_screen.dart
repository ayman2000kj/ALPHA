import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';
import 'package:aymologypro_new/shared/buttons/exam_year_buttons.dart';

// استورد شاشة الامتحان الموحدة (يجب أن تنشئها أو تعدلها لاحقاً)
import 'exams/2022_2023/qcm_exam_screen.dart';

class NeurologieScreen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  const NeurologieScreen(
      {super.key, required this.appThemeMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        title: Text(
          'Vascularisation',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ExamYearButtonsList(
                examYears: ExamYearExamples.getDefaultYears(),
                onYearSelected: (year) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QcmExamVascularisation2022_2023Screen(
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
