import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/screens/auth/widgets/particle_animation.dart';
import 'package:aymologypro_new/screens/auth/widgets/login_form.dart';
import 'package:aymologypro_new/screens/auth/widgets/login_animations.dart';
import 'package:aymologypro_new/screens/auth/services/login_service.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

class LoginScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const LoginScreen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isLoading = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    await LoginService.handleLogin(
      context: context,
      formKey: _formKey,
      onLoadingChanged: () => setState(() => _isLoading = !_isLoading),
    );
  }

  void _navigateToRegister() {
    LoginService.navigateToRegister(
        context, widget.appThemeMode, widget.onThemeChanged);
  }

  void _navigateWithoutAccount() {
    LoginService.navigateWithoutAccount(
        context, widget.appThemeMode, widget.onThemeChanged);
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

                        // العنوان والشعار
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withAlpha(51),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withAlpha(26),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withAlpha(26),
                                          border: Border.all(
                                            color: Colors.white.withAlpha(51),
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.account_circle_outlined,
                                          size: 60,
                                          color: Colors.white.withAlpha(230),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'مرحباً بك',
                                  style: GoogleFonts.cairo(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(77),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'سجل دخولك للمتابعة',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    color: Colors.white.withAlpha(204),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // نموذج تسجيل الدخول
                        LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isLoading: _isLoading,
                          onLogin: _handleLogin,
                          scaleAnimation: _scaleAnimation,
                        ),

                        const SizedBox(height: 32),

                        // زر فتح حساب جديد
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _navigateToRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: Colors.white.withAlpha(77),
                                    width: 1,
                                  ),
                                ),
                              ),
                              icon: Icon(Icons.person_add, size: 24),
                              label: Text(
                                'فتح حساب جديد',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // زر المتابعة بدون حساب
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _navigateWithoutAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withAlpha(26),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: Colors.white.withAlpha(51),
                                    width: 1,
                                  ),
                                ),
                              ),
                              icon: Icon(Icons.arrow_forward, size: 24),
                              label: Text(
                                'المتابعة بدون حساب',
                                style: GoogleFonts.cairo(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // نص توضيحي
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'يمكنك المتابعة بدون حساب، لكن لن يتم حفظ تقدمك',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.white.withAlpha(179),
                            ),
                            textAlign: TextAlign.center,
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
}
