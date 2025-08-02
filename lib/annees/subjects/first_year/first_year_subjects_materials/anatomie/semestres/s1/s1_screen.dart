import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/shared/buttons/app_buttons.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

import 'unites/ANATOMIEGENERALE/anatomie_generale_screen.dart';
import 'unites/OSTEOLOGIE/osteologie_screen.dart';
import 'unites/ARTHOLOGIE/arthologie_screen.dart';
import 'unites/MYOLOGIE/myologie_screen.dart';
import 'unites/NEUROLOGIE/neurologie_screen.dart';
import 'examen_complet/examen_complet_screen.dart';

class AnatomieS1Screen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const AnatomieS1Screen({
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
        automaticallyImplyLeading: true,
        title: Text(
          'Anatomie S1',
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
              'Choisissez une unité:',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final units = [
                    {
                      'title': 'Anatomie Générale',
                      'icon': Icons.medical_services,
                      'color': const Color(0xFF1976D2),
                      'screen': AnatomieGeneraleScreen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                      'subtitle': 'Anatomie S1',
                    },
                    {
                      'title': 'Ostéologie',
                      'icon': Icons.science,
                      'color': const Color(0xFF43CEA2),
                      'screen': OsteologieScreen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                      'subtitle': 'Anatomie S1',
                    },
                    {
                      'title': 'Arthrologie',
                      'icon': Icons.link,
                      'color': const Color(0xFFEA4335),
                      'screen': ArthologieScreen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                      'subtitle': 'Anatomie S1',
                    },
                    {
                      'title': 'Myologie',
                      'icon': Icons.fitness_center,
                      'color': const Color(0xFFFF9800),
                      'screen': MyologieScreen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                      'subtitle': 'Anatomie S1',
                    },
                    {
                      'title': 'Neurologie',
                      'icon': Icons.psychology,
                      'color': const Color(0xFF9C27B0),
                      'screen': NeurologieScreen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                      'subtitle': 'Anatomie S1',
                    },
                    {
                      'title': 'Examen Complet',
                      'icon': Icons.quiz,
                      'color': const Color(0xFF4CAF50),
                      'screen': ExamenCompletScreen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                      'subtitle': 'جميع الوحدات في امتحان واحد',
                    },
                  ];

                  final unit = units[index];
                  return SubjectButton(
                    title: unit['title'] as String,
                    icon: unit['icon'] as IconData,
                    color: unit['color'] as Color,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => unit['screen'] as Widget,
                        ),
                      );
                    },
                    subtitle: unit['subtitle'] as String,
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
