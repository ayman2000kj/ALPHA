import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

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
      body: Center(
        child: Text(
          'صفحة أوستيولوجي (تخصيص المحتوى لاحقًا)',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
