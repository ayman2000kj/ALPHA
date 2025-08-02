import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'package:aymologypro_new/widgets/theme/theme_toggle_button.dart';
import 'package:aymologypro_new/widgets/theme/theme_mixin.dart';
import 'package:aymologypro_new/widgets/theme/theme_extensions.dart';

/// مثال على استخدام زر الوضع الليلي بطرق مختلفة

// الطريقة الأولى: استخدام ThemeToggleButton مباشرة
class ExampleScreen1 extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const ExampleScreen1({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مثال 1 - استخدام ThemeToggleButton'),
        actions: [
          ThemeToggleButton(
            appThemeMode: appThemeMode,
            onThemeChanged: onThemeChanged,
          ),
        ],
      ),
      body: Center(
        child: Text('هذا مثال على استخدام ThemeToggleButton'),
      ),
    );
  }
}

// الطريقة الثانية: استخدام Mixin
class ExampleScreen2 extends StatefulWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const ExampleScreen2({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<ExampleScreen2> createState() => _ExampleScreen2State();
}

class _ExampleScreen2State extends State<ExampleScreen2> with ThemeMixin {
  @override
  AppThemeMode get appThemeMode => widget.appThemeMode;

  @override
  ValueChanged<AppThemeMode> get onThemeChanged => widget.onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مثال 2 - استخدام ThemeMixin'),
        actions: [
          buildThemeToggleButton(),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('الوضع الحالي: $currentThemeText'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleTheme,
              child: Text('تبديل الوضع'),
            ),
          ],
        ),
      ),
    );
  }
}

// الطريقة الثالثة: استخدام Extension
class ExampleScreen3 extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const ExampleScreen3({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مثال 3 - استخدام Extension'),
      ).withThemeToggle(
        appThemeMode: appThemeMode,
        onThemeChanged: onThemeChanged,
      ),
      body: Center(
        child: Text('هذا مثال على استخدام Extension'),
      ),
    );
  }
}

// الطريقة الرابعة: استخدام Extension مع Scaffold
class ExampleScreen4 extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const ExampleScreen4({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مثال 4 - استخدام Extension مع Scaffold'),
      ),
      body: Center(
        child: Text('هذا مثال على استخدام Extension مع Scaffold'),
      ),
    ).withThemeToggle(
      appThemeMode: appThemeMode,
      onThemeChanged: onThemeChanged,
    );
  }
}

// الطريقة الخامسة: استخدام IconButton مباشرة (الطريقة الحالية)
class ExampleScreen5 extends StatelessWidget {
  final AppThemeMode appThemeMode;
  final ValueChanged<AppThemeMode> onThemeChanged;

  const ExampleScreen5({
    super.key,
    required this.appThemeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مثال 5 - استخدام IconButton مباشرة'),
        actions: [
          IconButton(
            onPressed: () {
              onThemeChanged(appThemeMode == AppThemeMode.light
                  ? AppThemeMode.dark
                  : AppThemeMode.light);
            },
            icon: Icon(appThemeMode == AppThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: Center(
        child: Text('هذا مثال على استخدام IconButton مباشرة'),
      ),
    );
  }
}
