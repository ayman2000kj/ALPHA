import 'package:flutter/material.dart';
import 'package:aymologypro_new/annees/subjects/second_year/second_year_subjects.dart';
import 'package:aymologypro_new/annees/subjects/third_year/third_year_subjects.dart';
import 'package:aymologypro_new/annees/subjects/first_year/first_year_subjects.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class MedicalYearsScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  const MedicalYearsScreen(
      {super.key, required this.appThemeMode, required this.onThemeChanged});

  @override
  State<MedicalYearsScreen> createState() => _MedicalYearsScreenState();
}

class _MedicalYearsScreenState extends State<MedicalYearsScreen> {
  @override
  Widget build(BuildContext context) {
    final buttons = [
      {
        'label': '1ère Année',
        'icon': Icons.school,
        'color': const Color(0xFF1976D2),
        'shadow': Colors.blueAccent,
        'page': FirstYearSubjectsScreen(
          appThemeMode: ThemeService().currentTheme,
          onThemeChanged: (themeMode) => ThemeService().setTheme(themeMode),
        ),
      },
      {
        'label': '2ème Année',
        'icon': Icons.school,
        'color': const Color(0xFF43CEA2),
        'shadow': Colors.greenAccent,
        'page': SecondYearSubjectsScreen(
          appThemeMode: ThemeService().currentTheme,
          onThemeChanged: (themeMode) => ThemeService().setTheme(themeMode),
        ),
      },
      {
        'label': '3ème Année',
        'icon': Icons.school,
        'color': const Color(0xFFEA4335),
        'shadow': Colors.redAccent,
        'page': ThirdYearSubjectsScreen(
          appThemeMode: ThemeService().currentTheme,
          onThemeChanged: (themeMode) => ThemeService().setTheme(themeMode),
        ),
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        title: Text(
          'Années Médicales',
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  size: 28),
              onPressed: () => Navigator.of(context).pop(),
              padding:
                  const EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 0),
              splashRadius: 24,
              tooltip: 'رجوع',
            ),
            const SizedBox(height: 2),
            Center(
              child: Text(
                'Choisissez votre année',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 38),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: buttons.asMap().entries.map((entry) {
                    final i = entry.key;
                    final btn = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 28),
                      child: _buildYearButton(
                        title: btn['label'] as String,
                        icon: btn['icon'] as IconData,
                        color: btn['color'] as Color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => btn['page'] as Widget),
                          );
                        },
                        subtitle: '${i + 1} مواد',
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String subtitle,
  }) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(77),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withAlpha(204)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withAlpha(77),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.white.withAlpha(204),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
