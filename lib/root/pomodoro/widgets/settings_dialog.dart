import 'package:flutter/material.dart';
import '../models/pomodoro_settings.dart';

// نافذة الإعدادات
class SettingsDialog extends StatefulWidget {
  final PomodoroSettings settings;
  final Function(PomodoroSettings) onSettingsChanged;

  const SettingsDialog({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late PomodoroSettings _tempSettings;

  @override
  void initState() {
    super.initState();
    _tempSettings = PomodoroSettings(
      workDuration: widget.settings.workDuration,
      shortBreakDuration: widget.settings.shortBreakDuration,
      longBreakDuration: widget.settings.longBreakDuration,
      pomodoroCycles: widget.settings.pomodoroCycles,
      soundEnabled: widget.settings.soundEnabled,
      vibrationEnabled: widget.settings.vibrationEnabled,
      haloEffect: widget.settings.haloEffect,
      showStats: widget.settings.showStats,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text('Settings', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSliderSetting(
              'Work Duration',
              _tempSettings.workDuration,
              1,
              60,
              'min',
              (value) => _tempSettings.workDuration = value,
            ),
            _buildSliderSetting(
              'Short Break',
              _tempSettings.shortBreakDuration,
              1,
              30,
              'min',
              (value) => _tempSettings.shortBreakDuration = value,
            ),
            _buildSliderSetting(
              'Long Break',
              _tempSettings.longBreakDuration,
              1,
              60,
              'min',
              (value) => _tempSettings.longBreakDuration = value,
            ),
            const SizedBox(height: 20),
            _buildSwitchSetting(
              'Halo Effect',
              _tempSettings.haloEffect,
              (value) => _tempSettings.haloEffect = value,
            ),
            _buildSwitchSetting(
              'Sound Notifications',
              _tempSettings.soundEnabled,
              (value) => _tempSettings.soundEnabled = value,
            ),
            _buildSwitchSetting(
              'Vibration',
              _tempSettings.vibrationEnabled,
              (value) => _tempSettings.vibrationEnabled = value,
            ),
            _buildSwitchSetting(
              'Show Statistics',
              _tempSettings.showStats,
              (value) => _tempSettings.showStats = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSettingsChanged(_tempSettings);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildSliderSetting(
    String title,
    int value,
    int min,
    int max,
    String unit,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white)),
            Text('$value $unit', style: const TextStyle(color: Color(0xFFFF6B6B))),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          activeColor: const Color(0xFFFF6B6B),
          onChanged: (newValue) {
            setState(() {
              onChanged(newValue.round());
            });
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        Switch(
          value: value,
          onChanged: (newValue) {
            setState(() {
              onChanged(newValue);
            });
          },
          activeColor: const Color(0xFFFF6B6B),
        ),
      ],
    );
  }
} 
