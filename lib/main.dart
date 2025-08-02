/// تطبيق AymologyPro
///
/// نقطة البداية الرئيسية للتطبيق
/// يدعم الوضع المظلم والفاتح مع تبديل ديناميكي

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aymologypro_new/screens/welcome/main_screen.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'root/tasks/viewmodels/task_viewmodel.dart';
import 'root/tasks/services/task_service.dart';

/// دالة البداية الرئيسية
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إعداد واجهة النظام
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(TaskService(prefs)),
        ),
        // يمكنك إضافة مزودات أخرى هنا إذا لزم الأمر
      ],
      child: const AymologyApp(),
    ),
  );
}

/// التطبيق الرئيسي
class AymologyApp extends StatefulWidget {
  const AymologyApp({super.key});

  @override
  State<AymologyApp> createState() => _AymologyAppState();
}

class _AymologyAppState extends State<AymologyApp> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _updateStatusBar(_themeService.currentTheme);
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  /// الحصول على الثيم الحالي
  ThemeData get _currentTheme {
    return _themeService.currentTheme == AppThemeMode.dark
        ? ThemeData.dark()
        : ThemeData.light();
  }

  /// تغيير الثيم
  void _onThemeChanged() {
    setState(() {});
    _updateStatusBar(_themeService.currentTheme);
  }

  /// تحديث شريط الحالة حسب الثيم
  void _updateStatusBar(AppThemeMode themeMode) {
    final isDark = themeMode == AppThemeMode.dark;
    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AYMOLOGY',
      debugShowCheckedModeBanner: false,
      theme: _currentTheme,
      home: MainScreen(
        appThemeMode: _themeService.currentTheme,
        onThemeChanged: (themeMode) => _themeService.setTheme(themeMode),
      ),
    );
  }
}
