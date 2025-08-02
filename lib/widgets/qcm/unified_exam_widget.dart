import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'qcm_widget.dart';
import '../notes/notes_manager_screen.dart';
import '../theme/app_theme_mode.dart';
import '../../services/theme_service.dart';

class UnifiedExamWidget extends StatefulWidget {
  final List<QcmQuestion> questions;
  final String examTitle;
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  final Function(Map<int, Set<int>>) onExamCompleted;
  const UnifiedExamWidget({
    super.key,
    required this.questions,
    required this.examTitle,
    required this.appThemeMode,
    required this.onThemeChanged,
    required this.onExamCompleted,
  });

  @override
  State<UnifiedExamWidget> createState() => _UnifiedExamWidgetState();
}

class _UnifiedExamWidgetState extends State<UnifiedExamWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Aucune question disponible')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Question 1 / ${widget.questions.length}',
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _LegendChip(
              color: Colors.green,
              label: 'Correct',
            ),
            const SizedBox(width: 12),
            _LegendChip(
              color: Colors.orange,
              label: 'Oubliée',
            ),
            const SizedBox(width: 12),
            _LegendChip(
              color: Colors.red,
              label: 'Faux',
            ),
            const SizedBox(width: 16),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotesManagerScreen(
                    appThemeMode: ThemeService().currentTheme,
                    onThemeChanged: (themeMode) =>
                        ThemeService().setTheme(themeMode),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.notes),
            tooltip: 'Gérer les notes',
          ),
          IconButton(
            onPressed: () {
              ThemeService().toggleTheme();
            },
            icon: Icon(ThemeService().currentThemeIcon),
          ),
        ],
      ),
      body: QcmWidget(
        questions: widget.questions,
        title: widget.examTitle,
        appThemeMode: ThemeService().currentTheme,
        onThemeChanged: (themeMode) => ThemeService().setTheme(themeMode),
        onExamCompleted: widget.onExamCompleted,
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(102),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
