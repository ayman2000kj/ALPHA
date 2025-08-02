import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/annees/years_screen.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';
import 'tasks/index.dart';
import 'pomodoro/index.dart';

import 'library/library_screen.dart';

class RootScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const RootScreen(
      {super.key, required this.appThemeMode, required this.onThemeChanged});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutQuart),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buttons = [
      {
        'label': 'Années Médicales',
        'subtitle': 'Explorez les programmes et matières d\'études',
        'icon': Icons.school_rounded,
        'gradient': [const Color(0xFF667eea), const Color(0xFF764ba2)],
        'shadowColor': const Color(0xFF667eea),
        'delay': 0.0,
        'onTap': () {
          _navigateWithAnimation(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicalYearsScreen(
                  appThemeMode: ThemeService().currentTheme,
                  onThemeChanged: (themeMode) =>
                      ThemeService().setTheme(themeMode),
                ),
              ),
            );
          });
        },
      },
      {
        'label': 'Liste de Tâches',
        'subtitle': 'Organisez vos tâches quotidiennes efficacement',
        'icon': Icons.task_alt_rounded,
        'gradient': [const Color(0xFF11998e), const Color(0xFF38ef7d)],
        'shadowColor': const Color(0xFF11998e),
        'delay': 0.2,
        'onTap': () {
          _navigateWithAnimation(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TasksScreenV2(),
              ),
            );
          });
        },
      },
      {
        'label': 'Technique Pomodoro',
        'subtitle': 'Améliorez votre concentration et productivité',
        'icon': Icons.timer_rounded,
        'gradient': [const Color(0xFFee0979), const Color(0xFFff6a00)],
        'shadowColor': const Color(0xFFee0979),
        'delay': 0.4,
        'onTap': () {
          _navigateWithAnimation(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PomodoroScreen(),
              ),
            );
          });
        },
      },
      {
        'label': 'Bibliothèque Numérique',
        'subtitle': 'Accédez aux livres et références médicales',
        'icon': Icons.library_books_rounded,
        'gradient': [const Color(0xFF8360c3), const Color(0xFF2ebf91)],
        'shadowColor': const Color(0xFF8360c3),
        'delay': 0.6,
        'onTap': () {
          _navigateWithAnimation(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LibraryScreen(
                  appThemeMode: ThemeService().currentTheme,
                  onThemeChanged: (themeMode) =>
                      ThemeService().setTheme(themeMode),
                ),
              ),
            );
          });
        },
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0f0f23),
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                  ]
                : [
                    const Color(0xFFffecd2),
                    const Color(0xFFfcb69f),
                    const Color(0xFFa8edea),
                  ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildCustomAppBar(isDark),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 40),
                    _buildWelcomeSection(isDark),
                    const SizedBox(height: 50),
                    ...buttons.asMap().entries.map((entry) {
                      final index = entry.key;
                      final button = entry.value;
                      return Column(
                        children: [
                          _buildEnhancedButton(
                            button: button,
                            index: index,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 30),
                    _buildFooter(isDark),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.black.withAlpha(204),
                    Colors.black.withAlpha(102),
                  ]
                : [
                    Colors.white.withAlpha(230),
                    Colors.white.withAlpha(153),
                  ],
          ),
        ),
        child: FlexibleSpaceBar(
          centerTitle: true,
          title: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Aymology Pro',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2d3748),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withAlpha(26)
                      : Colors.black.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    ThemeService().toggleTheme();
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      ThemeService().currentThemeIcon,
                      key: ValueKey(ThemeService().currentThemeIcon),
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(bool isDark) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              Colors.white.withAlpha(26),
                              Colors.white.withAlpha(13),
                            ]
                          : [
                              Colors.white.withAlpha(230),
                              Colors.white.withAlpha(153),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withAlpha(77)
                            : Colors.black.withAlpha(26),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _floatingAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value * 5),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF764ba2)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF667eea).withAlpha(102),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Bienvenue dans le monde de la médecine',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF2d3748),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Votre compagnon dans le voyage d\'apprentissage et d\'excellence académique',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: isDark
                              ? Colors.white.withAlpha(204)
                              : const Color(0xFF4a5568),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedButton({
    required Map<String, dynamic> button,
    required int index,
    required bool isDark,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = button['delay'] as double;
        final animationValue = Curves.easeOutCubic.transform(
            (((_controller.value - delay).clamp(0.0, 1.0)) / (1.0 - delay))
                .clamp(0.0, 1.0));

        return Opacity(
          opacity: animationValue,
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (button['shadowColor'] as Color).withAlpha(77),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: button['onTap'] as VoidCallback,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: button['gradient'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: PatternPainter(),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
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
                                button['icon'] as IconData,
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
                                    button['label'] as String,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    button['subtitle'] as String,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(bool isDark) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value * 0.6,
          child: Center(
            child: Text(
              'Développé par Aymology Pro',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: isDark
                    ? Colors.white.withAlpha(153)
                    : Colors.black.withAlpha(153),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateWithAnimation(VoidCallback navigation) {
    HapticFeedback.lightImpact();
    navigation();
  }
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(26)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const spacing = 20.0;

    for (double i = 0; i < size.width + spacing; i += spacing) {
      for (double j = 0; j < size.height + spacing; j += spacing) {
        canvas.drawCircle(
          Offset(i, j),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
