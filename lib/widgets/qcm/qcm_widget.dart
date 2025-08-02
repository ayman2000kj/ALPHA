import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../notes/note_button.dart';

import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class QcmQuestion {
  final String question;
  final List<QcmOption> options;
  final String? id;
  QcmQuestion({required this.question, required this.options, this.id});
}

class QcmOption {
  final String text;
  final bool isCorrect;
  QcmOption({required this.text, required this.isCorrect});
}

class QcmWidget extends StatefulWidget {
  final List<QcmQuestion> questions;
  final String title;
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  final Function(Map<int, Set<int>>) onExamCompleted;

  const QcmWidget({
    super.key,
    required this.questions,
    required this.title,
    required this.appThemeMode,
    required this.onThemeChanged,
    required this.onExamCompleted,
  });

  @override
  State<QcmWidget> createState() => _QcmWidgetState();
}

class _QcmWidgetState extends State<QcmWidget> with TickerProviderStateMixin {
  int currentIndex = 0;
  final Map<int, Set<int>> selected = {};
  final Map<int, bool?> isCorrect = {};
  final Map<int, bool> submitted = {};
  bool _isExamCompleted = false;

  void _submit() {
    setState(() {
      submitted[currentIndex] = true;
      final qcm = widget.questions[currentIndex];
      final correctIndexes = qcm.options
          .asMap()
          .entries
          .where((e) => e.value.isCorrect)
          .map((e) => e.key)
          .toSet();
      final sel = selected[currentIndex] ?? {};
      final hasWrong = sel.any((i) => !correctIndexes.contains(i));
      final isAllCorrect = sel.length == correctIndexes.length &&
          sel.every((i) => correctIndexes.contains(i));
      final isPartial = sel.isNotEmpty &&
          !hasWrong &&
          sel.length < correctIndexes.length &&
          sel.every((i) => correctIndexes.contains(i));
      if (isAllCorrect) {
        isCorrect[currentIndex] = true;
      } else if (isPartial) {
        isCorrect[currentIndex] = null;
      } else {
        isCorrect[currentIndex] = false;
      }
    });
  }

  void _reset() {
    setState(() {
      selected[currentIndex] = {};
      submitted[currentIndex] = false;
      isCorrect[currentIndex] = null;
    });
  }

  void _next() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _prev() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Aucune question disponible'),
        ),
      );
    }

    final qcm = widget.questions[currentIndex];
    final sel = selected[currentIndex] ?? <int>{};
    final bool isSubmitted = submitted[currentIndex] ?? false;
    final bool? correct = isCorrect[currentIndex];

    if (_isExamCompleted) {
      return _buildResultsScreen();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
        title: null,
        actions: [
          IconButton(
            onPressed: () {
              ThemeService().toggleTheme();
            },
            icon: Icon(ThemeService().currentThemeIcon),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 2),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.questions.length, (i) {
                  final isCurrent = i == currentIndex;
                  final isSubmitted = submitted[i] ?? false;
                  final bool? correct = isCorrect[i];

                  Color circleColor =
                      Theme.of(context).colorScheme.outline.withAlpha(77);
                  if (isCurrent) {
                    circleColor =
                        const Color(0xFF2196F3); // أزرق جميل للسؤال الحالي
                  } else if (isSubmitted) {
                    if (correct == true) {
                      circleColor =
                          const Color(0xFF4CAF50); // أخضر جميل للإجابة الصحيحة
                    } else if (correct == false) {
                      circleColor =
                          const Color(0xFFF44336); // أحمر جميل للإجابة الخاطئة
                    } else {
                      circleColor = const Color(
                          0xFFFF9800); // برتقالي جميل للإجابة الناقصة
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = i;
                        });
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: circleColor,
                        child: Text(
                          '${i + 1}',
                          style: GoogleFonts.montserrat(
                            color: isCurrent
                                ? Colors.white
                                : isSubmitted
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(179),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NoteButton(
                            noteId:
                                qcm.id ?? '${widget.title}_${currentIndex + 1}',
                            noteLabel: qcm.question,
                            appThemeMode: widget.appThemeMode,
                            onThemeChanged: widget.onThemeChanged,
                          ),
                          const SizedBox(width: 8),
                          if (isSubmitted)
                            Icon(
                              correct == true
                                  ? Icons.check_circle_rounded
                                  : correct == false
                                      ? Icons.cancel_rounded
                                      : Icons.warning_amber_rounded,
                              color: correct == true
                                  ? Colors.green
                                  : correct == false
                                      ? Colors.red
                                      : Colors.orange,
                              size: 32,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        qcm.question,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ...qcm.options.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final opt = entry.value;
                        final isSelected = sel.contains(idx);
                        Color borderColor =
                            Theme.of(context).colorScheme.outline;
                        Color? fillColor;
                        Color textColor =
                            Theme.of(context).colorScheme.onSurface;

                        if (isSubmitted) {
                          if (opt.isCorrect && isSelected) {
                            borderColor = Colors.green;
                            fillColor = Colors.green;
                            textColor = Colors.white;
                          } else if (!opt.isCorrect && isSelected) {
                            borderColor = Colors.red;
                            fillColor = Colors.red;
                            textColor = Colors.white;
                          } else if (opt.isCorrect && !isSelected) {
                            borderColor = Colors.orange;
                            fillColor = Colors.orange;
                            textColor = Colors.white;
                          } else if (!opt.isCorrect && !isSelected) {
                            borderColor = Theme.of(context).colorScheme.outline;
                            textColor = Theme.of(context).colorScheme.onSurface;
                          }
                        } else if (isSelected) {
                          borderColor = Theme.of(context).colorScheme.primary;
                          fillColor = Theme.of(context).colorScheme.primary;
                          textColor = Theme.of(context).colorScheme.onPrimary;
                        } else {
                          borderColor = Theme.of(context).colorScheme.outline;
                          fillColor = null;
                          textColor = Theme.of(context).colorScheme.onSurface;
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: isSubmitted
                                  ? null
                                  : () {
                                      setState(() {
                                        if (isSelected) {
                                          sel.remove(idx);
                                        } else {
                                          sel.add(idx);
                                        }
                                        selected[currentIndex] = {...sel};
                                      });
                                    },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 18),
                                decoration: BoxDecoration(
                                  color: fillColor,
                                  border:
                                      Border.all(color: borderColor, width: 3),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: isSubmitted
                                          ? null
                                          : (v) {
                                              setState(() {
                                                if (isSelected) {
                                                  sel.remove(idx);
                                                } else {
                                                  sel.add(idx);
                                                }
                                                selected[currentIndex] = {
                                                  ...sel
                                                };
                                              });
                                            },
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        opt.text,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: textColor,
                                        ).copyWith(
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      if (isSubmitted)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Center(
                            child: Text(
                              correct == true
                                  ? 'Bonne réponse !'
                                  : correct == false
                                      ? 'Mauvaise réponse.'
                                      : 'Réponse incomplète.',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: correct == true
                                    ? Colors.green
                                    : correct == false
                                        ? Colors.red
                                        : Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          if (currentIndex > 0)
                            OutlinedButton(
                              onPressed: _prev,
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 2),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                textStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              child: Text('Précédent',
                                  style: GoogleFonts.montserrat(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  )),
                            ),
                          if (currentIndex > 0) const SizedBox(width: 16),
                          Expanded(
                            child: !isSubmitted
                                ? ElevatedButton(
                                    onPressed: sel.isEmpty ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      textStyle: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    child: Text('Vérifier',
                                        style: GoogleFonts.montserrat(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        )),
                                  )
                                : OutlinedButton(
                                    onPressed: _reset,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          width: 2),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      textStyle: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    child: Text('Réessayer',
                                        style: GoogleFonts.montserrat(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        )),
                                  ),
                          ),
                          if (currentIndex < widget.questions.length - 1) ...[
                            const SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: isSubmitted ? _next : null,
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 2),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                textStyle: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              child: Text('Suivant',
                                  style: GoogleFonts.montserrat(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  )),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        title: Text(
          'نتائج الامتحان',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'تم إكمال الامتحان بنجاح!',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'تم حفظ إجاباتك',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                widget.onExamCompleted(selected);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.home),
                  const SizedBox(width: 8),
                  Text(
                    'العودة للرئيسية',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
