import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

/// زر تبديل الوضع الليلي قابل لإعادة الاستخدام
/// يمكن استخدامه في أي مكان في التطبيق
class ThemeToggleButton extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;
  final double? size;
  final Color? iconColor;
  final String? tooltip;

  const ThemeToggleButton({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
    this.size,
    this.iconColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        onThemeChanged(appThemeMode == AppThemeMode.light
            ? AppThemeMode.dark
            : AppThemeMode.light);
      },
      icon: Icon(
        appThemeMode == AppThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
        size: size,
        color: iconColor,
      ),
      tooltip: tooltip ?? (appThemeMode == AppThemeMode.dark ? 'الوضع النهاري' : 'الوضع الليلي'),
    );
  }
} 
