import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class SecondYearSubjectsScreen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const SecondYearSubjectsScreen(
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
          '2ème Année',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              'En cours de développement',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Les matières de la 2ème année\nseront disponibles bientôt',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
