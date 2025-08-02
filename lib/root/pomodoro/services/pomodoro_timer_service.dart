import 'dart:async';
import 'package:flutter/services.dart';
import '../models/pomodoro_settings.dart';

// خدمة المؤقت
class PomodoroTimerService {
  Timer? _timer;
  TimerMode _currentMode = TimerMode.work;
  bool _isRunning = false;
  int _remainingSeconds = 25 * 60;
  int _currentCycle = 1;
  int _completedPomodoros = 0;
  int _totalFocusTime = 0;
  DateTime? _sessionStart;
  PomodoroSettings _settings = PomodoroSettings();

  // Getters
  TimerMode get currentMode => _currentMode;
  bool get isRunning => _isRunning;
  int get remainingSeconds => _remainingSeconds;
  int get currentCycle => _currentCycle;
  int get completedPomodoros => _completedPomodoros;
  int get totalFocusTime => _totalFocusTime;
  PomodoroSettings get settings => _settings;

  // تحديث الإعدادات
  void updateSettings(PomodoroSettings settings) {
    _settings = settings;
    if (!_isRunning) {
      _updateRemainingTime();
    }
  }

  // تحديث الوقت المتبقي
  void _updateRemainingTime() {
    switch (_currentMode) {
      case TimerMode.work:
        _remainingSeconds = _settings.workDuration * 60;
        break;
      case TimerMode.shortBreak:
        _remainingSeconds = _settings.shortBreakDuration * 60;
        break;
      case TimerMode.longBreak:
        _remainingSeconds = _settings.longBreakDuration * 60;
        break;
    }
  }

  // الحصول على المدة الإجمالية
  int get _totalDuration {
    switch (_currentMode) {
      case TimerMode.work:
        return _settings.workDuration * 60;
      case TimerMode.shortBreak:
        return _settings.shortBreakDuration * 60;
      case TimerMode.longBreak:
        return _settings.longBreakDuration * 60;
    }
  }

  // الحصول على نسبة التقدم
  double get progress => 1 - (_remainingSeconds / _totalDuration);

  // تنسيق الوقت
  String get formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // بدء المؤقت
  void startTimer(Function() onTick, Function() onComplete) {
    if (_isRunning) return;

    _isRunning = true;
    _sessionStart ??= DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        onTick();
      } else {
        _completeSession();
        onComplete();
      }
    });
  }

  // إيقاف المؤقت
  void pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
  }

  // إعادة تعيين المؤقت
  void resetTimer() {
    pauseTimer();
    _updateRemainingTime();
    _sessionStart = null;
  }

  // تخطي الجلسة
  void skipSession(Function() onComplete) {
    pauseTimer();
    _completeSession();
    onComplete();
  }

  // إكمال الجلسة
  void _completeSession() {
    pauseTimer();

    // تشغيل الاهتزاز
    if (_settings.vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }

    // تحديث الإحصائيات
    if (_currentMode == TimerMode.work) {
      _completedPomodoros++;
      if (_sessionStart != null) {
        _totalFocusTime += DateTime.now().difference(_sessionStart!).inSeconds;
        _sessionStart = null;
      }
    }

    // تبديل الوضع
    if (_currentMode == TimerMode.work) {
      if (_currentCycle % _settings.pomodoroCycles == 0) {
        _currentMode = TimerMode.longBreak;
      } else {
        _currentMode = TimerMode.shortBreak;
      }
      _currentCycle++;
    } else {
      _currentMode = TimerMode.work;
    }
    _updateRemainingTime();
  }

  // إعادة تعيين الإحصائيات
  void resetStats() {
    _completedPomodoros = 0;
    _totalFocusTime = 0;
    _sessionStart = null;
  }

  // تنسيق المدة
  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  // تنظيف الموارد
  void dispose() {
    _timer?.cancel();
  }
} 
