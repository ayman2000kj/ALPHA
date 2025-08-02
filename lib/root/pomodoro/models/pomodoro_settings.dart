// نموذج الإعدادات
class PomodoroSettings {
  int workDuration;
  int shortBreakDuration;
  int longBreakDuration;
  int pomodoroCycles;
  bool soundEnabled;
  bool vibrationEnabled;
  bool haloEffect;
  bool showStats;

  PomodoroSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.pomodoroCycles = 4,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.haloEffect = true,
    this.showStats = true,
  });

  PomodoroSettings copyWith({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? pomodoroCycles,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? haloEffect,
    bool? showStats,
  }) {
    return PomodoroSettings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      pomodoroCycles: pomodoroCycles ?? this.pomodoroCycles,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      haloEffect: haloEffect ?? this.haloEffect,
      showStats: showStats ?? this.showStats,
    );
  }
}

// أنواع الحالات
enum TimerMode { work, shortBreak, longBreak } 
