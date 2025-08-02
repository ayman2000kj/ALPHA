import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aymologypro_new/root/root_screen.dart';
import 'package:aymologypro_new/screens/auth/register_screen.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class LoginService {
  static Future<void> handleLogin({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required VoidCallback onLoadingChanged,
  }) async {
    if (!formKey.currentState!.validate()) return;

    onLoadingChanged();
    await Future.delayed(const Duration(seconds: 2));
    HapticFeedback.lightImpact();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تسجيل الدخول بنجاح!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => RootScreen(
            appThemeMode: ThemeService().currentTheme,
            onThemeChanged: (AppThemeMode themeMode) {
              ThemeService().setTheme(themeMode);
            },
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }

    onLoadingChanged();
  }

  static void navigateToRegister(BuildContext context,
      AppThemeMode appThemeMode, ValueChanged<AppThemeMode> onThemeChanged) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(
          appThemeMode: appThemeMode,
          onThemeChanged: onThemeChanged,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  static void navigateWithoutAccount(BuildContext context,
      AppThemeMode appThemeMode, ValueChanged<AppThemeMode> onThemeChanged) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => RootScreen(
          appThemeMode: appThemeMode,
          onThemeChanged: onThemeChanged,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}
