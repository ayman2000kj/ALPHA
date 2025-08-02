import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

/// Mixin لإدارة الوضع الليلي
/// يمكن إضافته لأي StatefulWidget
mixin ThemeMixin<T extends StatefulWidget> on State<T> {
  AppThemeMode get appThemeMode;
  ValueChanged<AppThemeMode> get onThemeChanged;

  /// تبديل الوضع الليلي
  void toggleTheme() {
    onThemeChanged(appThemeMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light);
  }

  /// الحصول على أيقونة الوضع الحالي
  IconData get currentThemeIcon {
    return appThemeMode == AppThemeMode.dark ? Icons.light_mode : Icons.dark_mode;
  }

  /// الحصول على نص الوضع الحالي
  String get currentThemeText {
    return appThemeMode == AppThemeMode.dark ? 'الوضع النهاري' : 'الوضع الليلي';
  }

  /// إنشاء زر تبديل الوضع الليلي
  Widget buildThemeToggleButton({
    double? size,
    Color? iconColor,
    String? tooltip,
  }) {
    return IconButton(
      onPressed: toggleTheme,
      icon: Icon(
        currentThemeIcon,
        size: size,
        color: iconColor,
      ),
      tooltip: tooltip ?? currentThemeText,
    );
  }
} 
