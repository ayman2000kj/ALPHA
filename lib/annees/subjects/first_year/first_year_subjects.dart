import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/shared/buttons/app_buttons.dart';
import 'package:aymologypro_new/services/theme_service.dart';
import 'first_year_subjects_materials/anatomie/anatomie_screen.dart';
import 'first_year_subjects_materials/biochimie/biochimie_screen.dart';
import 'first_year_subjects_materials/cytologie/cytologie_screen.dart';

class FirstYearSubjectsScreen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  const FirstYearSubjectsScreen(
      {super.key, required this.appThemeMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {
        'title': 'Anatomie',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFF1976D2),
      },
      {
        'title': 'Biochimie',
        'icon': Icons.whatshot_rounded,
        'color': const Color(0xFF43CEA2),
      },
      {
        'title': 'Cytologie',
        'icon': Icons.radar_rounded,
        'color': const Color(0xFFEA4335),
      },
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          'Matières de la Première Année',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.1,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue en première année! Voici les matières:',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withAlpha(179),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: subjects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 22),
                  itemBuilder: (context, index) {
                    final subject = subjects[index];
                    return SubjectButton(
                      title: subject['title'] as String,
                      icon: subject['icon'] as IconData,
                      color: subject['color'] as Color,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              if (subject['title'] == 'Anatomie') {
                                return AnatomieScreen(
                                  appThemeMode: ThemeService().currentTheme,
                                  onThemeChanged: (themeMode) =>
                                      ThemeService().setTheme(themeMode),
                                );
                              } else if (subject['title'] == 'Biochimie') {
                                return BiochimieScreen(
                                  appThemeMode: ThemeService().currentTheme,
                                  onThemeChanged: (themeMode) =>
                                      ThemeService().setTheme(themeMode),
                                );
                              } else if (subject['title'] == 'Cytologie') {
                                return CytologieScreen(
                                  appThemeMode: ThemeService().currentTheme,
                                  onThemeChanged: (themeMode) =>
                                      ThemeService().setTheme(themeMode),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        );
                      },
                      subtitle: 'السنة الأولى',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
