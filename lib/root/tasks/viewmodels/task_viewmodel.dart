import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

/// ViewModel لإدارة حالة المهام
class TaskViewModel extends ChangeNotifier {
  final TaskService _taskService;
  final Uuid _uuid = const Uuid();
  
  List<TaskModel> _tasks = [];
  List<TaskModel> _filteredTasks = [];
  bool _isLoading = true;
  TaskFilter _filter = TaskFilter.all;
  TaskSort _sort = TaskSort.dueDate;
  bool _sortAscending = true;
  String? _errorMessage;
  
  TaskViewModel(this._taskService) {
    _loadTasks();
  }
  
  // Getters
  List<TaskModel> get tasks => List.unmodifiable(_filteredTasks);
  List<TaskModel> get allTasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  TaskFilter get filter => _filter;
  TaskSort get sort => _sort;
  bool get sortAscending => _sortAscending;
  String? get errorMessage => _errorMessage;
  
  // Methods
  Future<void> _loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _tasks = await _taskService.getTasks();
      _applyFilterAndSort();
    } catch (e) {
      _errorMessage = 'فشل في تحميل المهام: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// إضافة مهمة جديدة
  Future<void> addTask({
    required String title,
    String description = '',
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    List<String> tags = const [],
    int estimatedPomodoros = 1,
  }) async {
    try {
      final newTask = TaskModel(
        id: _uuid.v4(),
        title: title,
        description: description,
        isCompleted: false,
        priority: priority,
        dueDate: dueDate ?? DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
        tags: tags,
        estimatedPomodoros: estimatedPomodoros,
      );
      
      await _taskService.addTask(newTask);
      _tasks.add(newTask);
      _applyFilterAndSort();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل في إضافة المهمة: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// تحديث مهمة موجودة
  Future<void> updateTask(TaskModel updatedTask) async {
    try {
      await _taskService.updateTask(updatedTask);
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        _applyFilterAndSort();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'فشل في تحديث المهمة: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// حذف مهمة
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      _applyFilterAndSort();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل في حذف المهمة: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// تبديل حالة إكمال المهمة
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      await _taskService.toggleTaskCompletion(taskId);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(
          isCompleted: !_tasks[index].isCompleted,
          completedAt: _tasks[index].isCompleted ? null : DateTime.now(),
        );
        _applyFilterAndSort();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'فشل في تبديل حالة المهمة: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// تحديث عدد جلسات البومودورو
  Future<void> updatePomodoroCount(String taskId, int newCount) async {
    try {
      await _taskService.updatePomodoroCount(taskId, newCount);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(actualPomodoros: newCount);
        _applyFilterAndSort();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'فشل في تحديث عدد جلسات البومودورو: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// تعيين الفلتر
  void setFilter(TaskFilter filter) {
    _filter = filter;
    _applyFilterAndSort();
    notifyListeners();
  }
  
  /// تعيين الترتيب
  void setSort(TaskSort sort, {bool? ascending}) {
    _sort = sort;
    if (ascending != null) {
      _sortAscending = ascending;
    } else {
      // تبديل الترتيب إذا كان نفس النوع
      _sortAscending = _sort == sort ? !_sortAscending : true;
    }
    _applyFilterAndSort();
    notifyListeners();
  }
  
  /// تطبيق الفلتر والترتيب
  void _applyFilterAndSort() {
    // تطبيق الفلتر
    switch (_filter) {
      case TaskFilter.all:
        _filteredTasks = List.from(_tasks);
        break;
      case TaskFilter.active:
        _filteredTasks = _tasks.where((task) => !task.isCompleted).toList();
        break;
      case TaskFilter.completed:
        _filteredTasks = _tasks.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.highPriority:
        _filteredTasks = _tasks.where((task) => task.priority == TaskPriority.high).toList();
        break;
      case TaskFilter.dueToday:
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        _filteredTasks = _tasks.where((task) => 
          task.dueDate.isAfter(today) && task.dueDate.isBefore(tomorrow)).toList();
        break;
      case TaskFilter.overdue:
        _filteredTasks = _tasks.where((task) => 
          task.dueDate.isBefore(DateTime.now()) && !task.isCompleted).toList();
        break;
    }
    
    // تطبيق الترتيب
    switch (_sort) {
      case TaskSort.dueDate:
        _filteredTasks.sort((a, b) => _sortAscending 
          ? a.dueDate.compareTo(b.dueDate)
          : b.dueDate.compareTo(a.dueDate));
        break;
      case TaskSort.priority:
        _filteredTasks.sort((a, b) => _sortAscending 
          ? a.priority.index.compareTo(b.priority.index)
          : b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSort.creationDate:
        _filteredTasks.sort((a, b) => _sortAscending 
          ? a.createdAt.compareTo(b.createdAt)
          : b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSort.title:
        _filteredTasks.sort((a, b) => _sortAscending 
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));
        break;
    }
  }
  
  /// الحصول على المهام المناسبة للبومودورو
  List<TaskModel> getTasksForPomodoro() {
    return _tasks.where((task) => 
      !task.isCompleted && task.actualPomodoros < task.estimatedPomodoros).toList();
  }
  
  /// الحصول على إحصائيات المهام
  Map<String, dynamic> getTaskStatistics() {
    return _taskService.getTaskStatistics();
  }
  
  /// مسح جميع المهام المكتملة
  Future<void> clearCompletedTasks() async {
    try {
      await _taskService.clearCompletedTasks();
      _tasks = _tasks.where((task) => !task.isCompleted).toList();
      _applyFilterAndSort();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'فشل في مسح المهام المكتملة: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// تصدير المهام
  String exportTasks() {
    return _taskService.exportTasks();
  }
  
  /// استيراد المهام
  Future<void> importTasks(String tasksJson) async {
    try {
      await _taskService.importTasks(tasksJson);
      await _loadTasks();
    } catch (e) {
      _errorMessage = 'فشل في استيراد المهام: $e';
      notifyListeners();
      rethrow;
    }
  }
  
  /// مسح رسالة الخطأ
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// إعادة تحميل المهام
  Future<void> refreshTasks() async {
    await _loadTasks();
  }
}

/// أنواع الفلاتر
enum TaskFilter {
  all,           // جميع المهام
  active,        // المهام النشطة
  completed,     // المهام المكتملة
  highPriority,  // أولوية عالية
  dueToday,      // المستحقة اليوم
  overdue,       // المهام المتأخرة
}

/// أنواع الترتيب
enum TaskSort {
  dueDate,       // تاريخ الاستحقاق
  priority,      // الأولوية
  creationDate,  // تاريخ الإنشاء
  title,         // العنوان
} 
