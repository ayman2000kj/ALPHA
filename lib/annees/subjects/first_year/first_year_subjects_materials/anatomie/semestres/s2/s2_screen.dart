import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

import 'package:aymologypro_new/shared/buttons/app_buttons.dart';
import 'unites/OSTEOLOGIE/osteologie_screen.dart';
import 'unites/ARTHOLOGIE/arthologie_screen.dart';
import 'unites/MYOLOGIE/myologie_screen.dart';
import 'unites/NEUROLOGIE/neurologie_screen.dart';

class AnatomieS2Screen extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  const AnatomieS2Screen(
      {super.key, required this.appThemeMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final buttons = [
      {
        'label': 'OSTEOLOGIE',
        'icon': Icons.accessibility_new,
        'color': const Color(0xFF1976D2),
        'shadow': Colors.blueAccent,
      },
      {
        'label': 'ARTHOLOGIE',
        'icon': Icons.healing,
        'color': const Color(0xFF43CEA2),
        'shadow': Colors.greenAccent,
      },
      {
        'label': 'MYOLOGIE',
        'icon': Icons.fitness_center,
        'color': const Color(0xFFEA4335),
        'shadow': Colors.redAccent,
      },
      {
        'label': 'NEUROLOGIE',
        'icon': Icons.psychology,
        'color': const Color(0xFF8F94FB),
        'shadow': Colors.deepPurpleAccent,
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
          'Anatomie S2',
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
              'Modules du Semestre 2 - Anatomie',
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
                      Widget page;
                      if (btn['label'] == 'OSTEOLOGIE') {
                        page = OsteologieScreen(
                          appThemeMode: appThemeMode,
                          onThemeChanged: onThemeChanged,
                        );
                      } else if (btn['label'] == 'ARTHOLOGIE') {
                        page = ArthologieScreen(
                          appThemeMode: appThemeMode,
                          onThemeChanged: onThemeChanged,
                        );
                      } else if (btn['label'] == 'MYOLOGIE') {
                        page = MyologieScreen(
                          appThemeMode: appThemeMode,
                          onThemeChanged: onThemeChanged,
                        );
                      } else if (btn['label'] == 'NEUROLOGIE') {
                        page = NeurologieScreen(
                          appThemeMode: appThemeMode,
                          onThemeChanged: onThemeChanged,
                        );
                      } else {
                        page = const SizedBox.shrink();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => page),
                      );
                    },
                    subtitle: 'Anatomie S2',
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
