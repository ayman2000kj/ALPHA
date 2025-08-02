import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:aymologypro_new/screens/auth/widgets/particle_animation.dart';
import 'package:aymologypro_new/screens/auth/widgets/register_form.dart';
import 'package:aymologypro_new/screens/auth/widgets/login_animations.dart';
import 'package:aymologypro_new/screens/auth/services/register_service.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

class RegisterScreen extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const RegisterScreen({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    await RegisterService.handleRegister(
      context: context,
      formKey: _formKey,
      onLoadingChanged: () => setState(() => _isLoading = !_isLoading),
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
            // الجسيمات المتحركة في الخلفية
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
                                // أيقونة التطبيق مع تأثير الإشعاع
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
                                          Icons.person_add_outlined,
                                          size: 60,
                                          color: Colors.white.withAlpha(230),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // عنوان التطبيق
                                Text(
                                  'إنشاء حساب جديد',
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
                                  'أدخل بياناتك لإنشاء حساب جديد',
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

                        // نموذج التسجيل
                        RegisterForm(
                          formKey: _formKey,
                          nameController: _nameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          isLoading: _isLoading,
                          onRegister: _handleRegister,
                          scaleAnimation: _scaleAnimation,
                        ),

                        const SizedBox(height: 32),

                        // رابط تسجيل الدخول
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'لديك حساب بالفعل؟ ',
                                style: GoogleFonts.cairo(
                                  color: Colors.white.withAlpha(204),
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'تسجيل الدخول',
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
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
}
