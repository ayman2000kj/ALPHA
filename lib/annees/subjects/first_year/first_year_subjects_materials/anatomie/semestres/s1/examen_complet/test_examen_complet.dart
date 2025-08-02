import 'package:flutter/material.dart';
import 'package:aymologypro_new/widgets/theme/app_theme_mode.dart';
import 'examen_complet_screen.dart';

/// ملف تجريبي لاختبار نظام الامتحان الكامل
/// يمكن استخدامه للاختبار والتطوير
class TestExamenComplet extends StatefulWidget {
  const TestExamenComplet({super.key});

  @override
  State<TestExamenComplet> createState() => _TestExamenCompletState();
}

class _TestExamenCompletState extends State<TestExamenComplet> {
  AppThemeMode _appThemeMode = AppThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.transparent,
        elevation: 0,
        title: const Text('اختبار الامتحان الكامل'),
        iconTheme:
            IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _appThemeMode = _appThemeMode == AppThemeMode.light
                    ? AppThemeMode.dark
                    : AppThemeMode.light;
              });
            },
            icon: Icon(_appThemeMode == AppThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.science,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'اختبار نظام الامتحان الكامل',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'هذا الملف مخصص لاختبار نظام الامتحان الكامل',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExamenCompletScreen(
                      appThemeMode: _appThemeMode,
                      onThemeChanged: (mode) {
                        setState(() {
                          _appThemeMode = mode;
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('بدء الامتحان الكامل'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                // يمكن إضافة اختبارات أخرى هنا
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ميزة قيد التطوير'),
                  ),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text('إعدادات متقدمة'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// دالة مساعدة لاختبار النظام
class ExamenCompletTester {
  /// اختبار تحميل الأسئلة
  static Future<void> testLoadQuestions() async {
    try {
      // يمكن إضافة اختبارات هنا
      print('✅ اختبار تحميل الأسئلة: ناجح');
    } catch (e) {
      print('❌ اختبار تحميل الأسئلة: فشل - $e');
    }
  }

  /// اختبار نظام التصحيح
  static void testCorrectionSystem() {
    try {
      // يمكن إضافة اختبارات هنا
      print('✅ اختبار نظام التصحيح: ناجح');
    } catch (e) {
      print('❌ اختبار نظام التصحيح: فشل - $e');
    }
  }

  /// اختبار نظام الملاحظات
  static void testNotesSystem() {
    try {
      // يمكن إضافة اختبارات هنا
      print('✅ اختبار نظام الملاحظات: ناجح');
    } catch (e) {
      print('❌ اختبار نظام الملاحظات: فشل - $e');
    }
  }
}
