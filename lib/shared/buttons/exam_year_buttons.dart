import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Bouton personnalisé pour les années d'examen
class ExamYearButton extends StatefulWidget {
  final String year;
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;
  final bool isNew;
  final bool isPopular;

  const ExamYearButton({
    super.key,
    required this.year,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.isNew = false,
    this.isPopular = false,
  });

  @override
  State<ExamYearButton> createState() => _ExamYearButtonState();
}

class _ExamYearButtonState extends State<ExamYearButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onTap,
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _controller.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _controller.reverse();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _controller.reverse();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: _isPressed
                      ? widget.color.withValues(alpha: 204)
                      : widget.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color
                          .withValues(alpha: _isPressed ? 100 : 130),
                      blurRadius: _isPressed ? 8 : 12,
                      offset: Offset(0, _isPressed ? 2 : 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                                                 // Icône avec arrière-plan circulaire
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.color
                                    .withValues(alpha: _isPressed ? 180 : 196),
                                widget.color,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color
                                    .withValues(alpha: _isPressed ? 100 : 130),
                                blurRadius: _isPressed ? 8 : 12,
                                offset: Offset(0, _isPressed ? 2 : 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  if (widget.isNew)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                                                             child: Text(
                                         'Nouveau',
                                         style: GoogleFonts.montserrat(
                                           fontSize: 10,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white,
                                         ),
                                       ),
                                    ),
                                  if (widget.isPopular)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.amber.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                                                             child: Text(
                                         'Populaire',
                                         style: GoogleFonts.montserrat(
                                           fontSize: 10,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.white,
                                         ),
                                       ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.year,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  widget.subtitle!,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isPressed ? 0.1 : 0,
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Liste des boutons d'années d'examen
class ExamYearButtonsList extends StatelessWidget {
  final List<Map<String, dynamic>> examYears;
  final Function(String year) onYearSelected;

  const ExamYearButtonsList({
    super.key,
    required this.examYears,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: examYears.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final year = examYears[index];
        return ExamYearButton(
          year: year['year'] as String,
          title: year['title'] as String,
          icon: year['icon'] as IconData,
          color: year['color'] as Color,
          subtitle: year['subtitle'] as String?,
          isNew: year['isNew'] as bool? ?? false,
          isPopular: year['isPopular'] as bool? ?? false,
          onTap: () => onYearSelected(year['year'] as String),
        );
      },
    );
  }
}

// Exemples d'années d'examen
class ExamYearExamples {
  static List<Map<String, dynamic>> getDefaultYears() {
    return [
      {
        'year': '2022-2023',
        'title': 'Examen 2022-2023',
        'icon': Icons.auto_awesome_rounded,
        'color': const Color(0xFF1976D2),
                 'subtitle': 'Examen complet',
        'isNew': false,
        'isPopular': true,
      },
    ];
  }
}
