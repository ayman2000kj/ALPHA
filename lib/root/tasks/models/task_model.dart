/// نموذج بيانات المهمة
class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TaskPriority priority;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<String> tags;
  final int estimatedPomodoros;
  final int actualPomodoros;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
    this.completedAt,
    this.tags = const [],
    this.estimatedPomodoros = 1,
    this.actualPomodoros = 0,
  });

  /// تحويل النموذج إلى Map للحفظ
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'priority': priority.index,
    'dueDate': dueDate.millisecondsSinceEpoch,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'completedAt': completedAt?.millisecondsSinceEpoch,
    'tags': tags,
    'estimatedPomodoros': estimatedPomodoros,
    'actualPomodoros': actualPomodoros,
  };

  /// إنشاء نموذج من Map
  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isCompleted: json['isCompleted'],
    priority: TaskPriority.values[json['priority']],
    dueDate: DateTime.fromMillisecondsSinceEpoch(json['dueDate']),
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    completedAt: json['completedAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'])
        : null,
    tags: List<String>.from(json['tags'] ?? []),
    estimatedPomodoros: json['estimatedPomodoros'] ?? 1,
    actualPomodoros: json['actualPomodoros'] ?? 0,
  );

  /// نسخ النموذج مع تحديث قيم معينة
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
    List<String>? tags,
    int? estimatedPomodoros,
    int? actualPomodoros,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      actualPomodoros: actualPomodoros ?? this.actualPomodoros,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isCompleted == isCompleted &&
        other.priority == priority &&
        other.dueDate == dueDate &&
        other.createdAt == createdAt &&
        other.completedAt == completedAt &&
        other.tags == tags &&
        other.estimatedPomodoros == estimatedPomodoros &&
        other.actualPomodoros == actualPomodoros;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isCompleted.hashCode ^
        priority.hashCode ^
        dueDate.hashCode ^
        createdAt.hashCode ^
        completedAt.hashCode ^
        tags.hashCode ^
        estimatedPomodoros.hashCode ^
        actualPomodoros.hashCode;
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, isCompleted: $isCompleted, priority: $priority, dueDate: $dueDate, createdAt: $createdAt, completedAt: $completedAt, tags: $tags, estimatedPomodoros: $estimatedPomodoros, actualPomodoros: $actualPomodoros)';
  }
}

/// أولويات المهام
enum TaskPriority {
  high,    // عالية
  medium,  // متوسطة
  low,     // منخفضة
}

/// امتدادات مفيدة لـ TaskPriority
extension TaskPriorityExtension on TaskPriority {
  /// الحصول على اسم الأولوية
  String get name {
    switch (this) {
      case TaskPriority.high:
        return 'عالية';
      case TaskPriority.medium:
        return 'متوسطة';
      case TaskPriority.low:
        return 'منخفضة';
    }
  }

  /// الحصول على لون الأولوية
  int get color {
    switch (this) {
      case TaskPriority.high:
        return 0xFFE53E3E; // أحمر
      case TaskPriority.medium:
        return 0xFFFF8C00; // برتقالي
      case TaskPriority.low:
        return 0xFF38A169; // أخضر
    }
  }

  /// الحصول على أيقونة الأولوية
  String get icon {
    switch (this) {
      case TaskPriority.high:
        return 'priority_high';
      case TaskPriority.medium:
        return 'remove';
      case TaskPriority.low:
        return 'priority_low';
    }
  }
} 
