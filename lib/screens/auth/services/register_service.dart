import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aymologypro_new/root/root_screen.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';

class RegisterService {
  static Future<void> handleRegister({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required VoidCallback onLoadingChanged,
  }) async {
    if (!formKey.currentState!.validate()) return;

    onLoadingChanged();

    // محاكاة عملية التسجيل
    await Future.delayed(const Duration(seconds: 2));

    // إظهار رسالة نجاح
    HapticFeedback.lightImpact();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إنشاء الحساب بنجاح!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // الانتقال إلى الشاشة التالية
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
}
