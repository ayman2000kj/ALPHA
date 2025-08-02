import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

/// بطاقة المهمة المحسنة
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onStartPomodoro;
  final VoidCallback? onDuplicate;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onStartPomodoro,
    this.onDuplicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final isOverdue = task.dueDate.isBefore(now) && !task.isCompleted;
    final isDueToday = task.dueDate.day == now.day &&
        task.dueDate.month == now.month &&
        task.dueDate.year == now.year;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue
                          ? Colors.red.withValues(alpha: 0.6)
            : const Color(0xFF4ECDC4).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isOverdue
                            ? Colors.red.withValues(alpha: 0.3)
            : const Color(0xFF4ECDC4).withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted
                  ? Colors.green
                  : _getPriorityColor(task.priority).withAlpha(77),
              border: !task.isCompleted
                  ? Border.all(
                      color: _getPriorityColor(task.priority), width: 2)
                  : null,
            ),
            child: task.isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ),
        title: Text(
          task.title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color:
                task.isCompleted ? Colors.white.withValues(alpha: 0.5) : Colors.white,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  task.description,
                  style: GoogleFonts.montserrat(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                // تاريخ الاستحقاق
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 14,
                      color: isOverdue
                          ? Colors.red
                          : isDueToday
                              ? Colors.orange
                              : Colors.white.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('yyyy/MM/dd').format(task.dueDate),
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: isOverdue
                            ? Colors.red
                            : isDueToday
                                ? Colors.orange
                                : Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // البومودورو
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 14,
                      color: const Color(0xFF4ECDC4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${task.actualPomodoros}/${task.estimatedPomodoros}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: const Color(0xFF4ECDC4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // الوسوم
            if (task.tags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  spacing: 4,
                  children: task.tags
                      .take(3)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: const Color(0xFF4ECDC4),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أولوية المهمة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getPriorityColor(task.priority).withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Text(
                _getPriorityText(task.priority),
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: _getPriorityColor(task.priority),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // قائمة الإجراءات
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                  case 'pomodoro':
                    onStartPomodoro();
                    break;
                  case 'duplicate':
                    onDuplicate?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('تعديل'),
                    ],
                  ),
                ),
                if (onDuplicate != null)
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('تكرار'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'pomodoro',
                  child: Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 8),
                      Text('بدء جلسة بومودورو'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('حذف', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onToggle,
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return const Color(0xFFFF6B6B);
      case TaskPriority.medium:
        return const Color(0xFFFFA726);
      case TaskPriority.low:
        return const Color(0xFF66BB6A);
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'عالية';
      case TaskPriority.medium:
        return 'متوسطة';
      case TaskPriority.low:
        return 'منخفضة';
    }
  }
} 
