import 'package:flutter/material.dart';

// نافذة الإحصائيات
class StatsDialog extends StatelessWidget {
  final int completedPomodoros;
  final int totalFocusTime;
  final int currentCycle;
  final VoidCallback onResetStats;

  const StatsDialog({
    super.key,
    required this.completedPomodoros,
    required this.totalFocusTime,
    required this.currentCycle,
    required this.onResetStats,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A2E),
      title: const Text('Statistics', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatRow('Completed Pomodoros', completedPomodoros.toString()),
          _buildStatRow('Total Focus Time', _formatDuration(totalFocusTime)),
          _buildStatRow('Current Cycle', currentCycle.toString()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onResetStats,
          child: const Text('Reset Stats'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFF6B6B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
} 
