import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/screens/auth/login_screen.dart';
import 'package:aymologypro_new/screens/auth/widgets/particle_animation.dart';
import 'package:aymologypro_new/screens/auth/widgets/login_animations.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

class MainScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const MainScreen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _animationController.forward();
  }

  void _initializeAnimations() {
    _animationController = LoginAnimations.createMainController(this);
    _fadeAnimation = LoginAnimations.createFadeAnimation(_animationController);
    _slideAnimation =
        LoginAnimations.createSlideAnimation(_animationController);
    _scaleAnimation =
        LoginAnimations.createScaleAnimation(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(
          appThemeMode: widget.appThemeMode,
          onThemeChanged: widget.onThemeChanged,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F0F23),
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                  ]
                : [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                    const Color(0xFFf093fb),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // الجسيمات المتحركة
            const ParticleAnimation(),

            // المحتوى الرئيسي
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        size.height - MediaQuery.of(context).padding.top - 32,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(),

                        // الشعار والعنوان
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              children: [
                                // أيقونة التطبيق
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withAlpha(77),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withAlpha(51),
                                        blurRadius: 40,
                                        spreadRadius: 15,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 15, sigmaY: 15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(38),
                                          border: Border.all(
                                            color: Colors.white.withAlpha(77),
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.school_outlined,
                                          size: 80,
                                          color: Colors.white.withAlpha(230),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                // عنوان التطبيق
                                Text(
                                  'AYMOLOGY',
                                  style: GoogleFonts.cairo(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(102),
                                        offset: const Offset(0, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // وصف التطبيق
                                Text(
                                  'منصة تعليمية متكاملة للطب',
                                  style: GoogleFonts.cairo(
                                    fontSize: 20,
                                    color: Colors.white.withAlpha(230),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'تعلم الطب بطريقة سهلة وممتعة',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    color: Colors.white.withAlpha(179),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),

                        // زر ابدأ
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withAlpha(77),
                                  Colors.white.withAlpha(51),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withAlpha(102),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(51),
                                  blurRadius: 25,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _navigateToLogin,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 28,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'ابدأ',
                                            style: GoogleFonts.cairo(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // معلومات إضافية
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                'مميزات التطبيق',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withAlpha(230),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildFeatureItem(
                                icon: Icons.book_outlined,
                                text: 'محتوى تعليمي شامل',
                              ),
                              const SizedBox(height: 8),
                              _buildFeatureItem(
                                icon: Icons.quiz_outlined,
                                text: 'اختبارات تفاعلية',
                              ),
                              const SizedBox(height: 8),
                              _buildFeatureItem(
                                icon: Icons.track_changes_outlined,
                                text: 'تتبع التقدم',
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.white.withAlpha(204),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: Colors.white.withAlpha(204),
          ),
        ),
      ],
    );
  }
}
