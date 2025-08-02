import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

/// خدمة إدارة المهام
class TaskService {
  final SharedPreferences _prefs;
  static const String _tasksKey = 'tasks';
  
  TaskService(this._prefs);
  
  /// الحصول على جميع المهام
  List<TaskModel> getTasks() {
    final tasksJson = _prefs.getString(_tasksKey);
    if (tasksJson == null) return [];
    
    try {
      final List<dynamic> decoded = json.decode(tasksJson);
      return decoded.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
    } catch (e) {
      // في حالة حدوث خطأ في الترميز، إرجاع قائمة فارغة
      return [];
    }
  }
  
  /// حفظ جميع المهام
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final tasksJson = json.encode(tasks.map((task) => task.toJson()).toList());
      await _prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      // معالجة الأخطاء
      throw Exception('فشل في حفظ المهام: $e');
    }
  }
  
  /// إضافة مهمة جديدة
  Future<void> addTask(TaskModel task) async {
    try {
      final tasks = getTasks();
      tasks.add(task);
      await saveTasks(tasks);
    } catch (e) {
      throw Exception('فشل في إضافة المهمة: $e');
    }
  }
  
  /// تحديث مهمة موجودة
  Future<void> updateTask(TaskModel updatedTask) async {
    try {
      final tasks = getTasks();
      final index = tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        await saveTasks(tasks);
      } else {
        throw Exception('المهمة غير موجودة');
      }
    } catch (e) {
      throw Exception('فشل في تحديث المهمة: $e');
    }
  }
  
  /// حذف مهمة
  Future<void> deleteTask(String taskId) async {
    try {
      final tasks = getTasks();
      tasks.removeWhere((task) => task.id == taskId);
      await saveTasks(tasks);
    } catch (e) {
      throw Exception('فشل في حذف المهمة: $e');
    }
  }
  
  /// تبديل حالة إكمال المهمة
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final tasks = getTasks();
      final index = tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        final task = tasks[index];
        tasks[index] = task.copyWith(
          isCompleted: !task.isCompleted,
          completedAt: task.isCompleted ? null : DateTime.now(),
        );
        await saveTasks(tasks);
      } else {
        throw Exception('المهمة غير موجودة');
      }
    } catch (e) {
      throw Exception('فشل في تبديل حالة المهمة: $e');
    }
  }
  
  /// الحصول على المهام المفلترة
  List<TaskModel> getFilteredTasks({
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? dueBefore,
    List<String>? tags,
  }) {
    var tasks = getTasks();
    
    if (isCompleted != null) {
      tasks = tasks.where((task) => task.isCompleted == isCompleted).toList();
    }
    
    if (priority != null) {
      tasks = tasks.where((task) => task.priority == priority).toList();
    }
    
    if (dueBefore != null) {
      tasks = tasks.where((task) => task.dueDate.isBefore(dueBefore)).toList();
    }
    
    if (tags != null && tags.isNotEmpty) {
      tasks = tasks.where((task) => 
        tags.any((tag) => task.tags.contains(tag))).toList();
    }
    
    return tasks;
  }
  
  /// الحصول على المهام المتأخرة
  List<TaskModel> getOverdueTasks() {
    final now = DateTime.now();
    return getTasks().where((task) => 
      task.dueDate.isBefore(now) && !task.isCompleted).toList();
  }
  
  /// الحصول على المهام المستحقة اليوم
  List<TaskModel> getDueTodayTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return getTasks().where((task) => 
      task.dueDate.isAfter(today) && task.dueDate.isBefore(tomorrow)).toList();
  }
  
  /// الحصول على المهام عالية الأولوية
  List<TaskModel> getHighPriorityTasks() {
    return getTasks().where((task) => 
      task.priority == TaskPriority.high && !task.isCompleted).toList();
  }
  
  /// الحصول على المهام المناسبة للبومودورو
  List<TaskModel> getTasksForPomodoro() {
    return getTasks().where((task) => 
      !task.isCompleted && task.actualPomodoros < task.estimatedPomodoros).toList();
  }
  
  /// تحديث عدد جلسات البومودورو المنجزة
  Future<void> updatePomodoroCount(String taskId, int newCount) async {
    try {
      final tasks = getTasks();
      final index = tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        final task = tasks[index];
        tasks[index] = task.copyWith(actualPomodoros: newCount);
        await saveTasks(tasks);
      }
    } catch (e) {
      throw Exception('فشل في تحديث عدد جلسات البومودورو: $e');
    }
  }
  
  /// الحصول على إحصائيات المهام
  Map<String, dynamic> getTaskStatistics() {
    final tasks = getTasks();
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final activeTasks = totalTasks - completedTasks;
    final overdueTasks = getOverdueTasks().length;
    final dueTodayTasks = getDueTodayTasks().length;
    final highPriorityTasks = getHighPriorityTasks().length;
    
    return {
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'activeTasks': activeTasks,
      'overdueTasks': overdueTasks,
      'dueTodayTasks': dueTodayTasks,
      'highPriorityTasks': highPriorityTasks,
      'completionRate': totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0,
    };
  }
  
  /// مسح جميع المهام المكتملة
  Future<void> clearCompletedTasks() async {
    try {
      final tasks = getTasks();
      final activeTasks = tasks.where((task) => !task.isCompleted).toList();
      await saveTasks(activeTasks);
    } catch (e) {
      throw Exception('فشل في مسح المهام المكتملة: $e');
    }
  }
  
  /// تصدير المهام
  String exportTasks() {
    final tasks = getTasks();
    return json.encode(tasks.map((task) => task.toJson()).toList());
  }
  
  /// استيراد المهام
  Future<void> importTasks(String tasksJson) async {
    try {
      final List<dynamic> decoded = json.decode(tasksJson);
      final tasks = decoded.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
      await saveTasks(tasks);
    } catch (e) {
      throw Exception('فشل في استيراد المهام: $e');
    }
  }
} 
