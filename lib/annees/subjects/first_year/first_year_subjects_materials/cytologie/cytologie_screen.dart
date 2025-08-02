import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';
import 'package:aymologypro_new/shared/buttons/app_buttons.dart';

import 'semestres/s1/s1_screen.dart';
import 'semestres/s2/s2_screen.dart';

class CytologieScreen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  const CytologieScreen(
      {super.key, required this.appThemeMode, required this.onThemeChanged});

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
          'Cytologie',
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
              'اختر السيمستر:',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: 2,
                separatorBuilder: (_, __) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final semesters = [
                    {
                      'title': 'S1 - Semestre 1',
                      'icon': Icons.star_rounded,
                      'color': const Color(0xFF1976D2),
                      'screen': CytologieS1Screen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                    },
                    {
                      'title': 'S2 - Semestre 2',
                      'icon': Icons.star_rounded,
                      'color': const Color(0xFF43CEA2),
                      'screen': CytologieS2Screen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      ),
                    },
                  ];

                  final semester = semesters[index];
                  return SubjectButton(
                    title: semester['title'] as String,
                    icon: semester['icon'] as IconData,
                    color: semester['color'] as Color,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => semester['screen'] as Widget,
                        ),
                      );
                    },
                    subtitle: 'السيتولوجيا',
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
