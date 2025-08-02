import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

// استورد شاشة الامتحان الموحدة (يجب أن تنشئها أو تعدلها لاحقاً)
import 'exams/2022_2023/qcm_exam_screen.dart';

class OsteologieScreen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  const OsteologieScreen(
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
          'Ostéologie',
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
              onThemeChanged(appThemeMode == AppThemeMode.light
                  ? AppThemeMode.dark
                  : AppThemeMode.light);
            },
            icon: Icon(appThemeMode == AppThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Examen Ostéologie 2022-2023',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QcmExamOsteologie2022_2023Screen(
                              appThemeMode: appThemeMode,
                              onThemeChanged: onThemeChanged,
                            ),
                          ),
                        );
                      },
                      child: const Text('Commencer l\'examen'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
