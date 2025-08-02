import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';
import 'package:aymologypro_new/shared/buttons/app_buttons.dart';
import 'unites/BIOCHIMIEGENERALE/biochimie_generale_screen.dart';

class BiochimieS1Screen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const BiochimieS1Screen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {
        'label': 'BIOCHIMIE GENERALE',
        'icon': Icons.science_rounded,
        'color': const Color(0xFF1976D2),
        'shadow': Colors.blueAccent,
      },
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Biochimie S1',
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
              'Modules du Semestre 1 - Biochimie',
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: buttons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 28),
                itemBuilder: (context, i) {
                  final btn = buttons[i];
                  return SubjectButton(
                    title: btn['label'] as String,
                    icon: btn['icon'] as IconData,
                    color: btn['color'] as Color,
                    onTap: () {
                      Widget page = BiochimieGeneraleScreen(
                        appThemeMode: appThemeMode,
                        onThemeChanged: onThemeChanged,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => page),
                      );
                    },
                    subtitle: 'Biochimie S1',
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
