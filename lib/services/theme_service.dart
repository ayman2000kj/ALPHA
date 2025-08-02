import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';

/// Service لإدارة الوضع الليلي بشكل مركزي
class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  AppThemeMode _currentTheme = AppThemeMode.dark;
  
  AppThemeMode get currentTheme => _currentTheme;

  /// تغيير الوضع الليلي
  void toggleTheme() {
    _currentTheme = _currentTheme == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    notifyListeners();
  }

  /// تعيين الوضع الليلي
  void setTheme(AppThemeMode theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  /// الحصول على أيقونة الوضع الحالي
  IconData get currentThemeIcon {
    return _currentTheme == AppThemeMode.dark ? Icons.light_mode : Icons.dark_mode;
  }

  /// الحصول على نص الوضع الحالي
  String get currentThemeText {
    return _currentTheme == AppThemeMode.dark ? 'الوضع النهاري' : 'الوضع الليلي';
  }
} 
