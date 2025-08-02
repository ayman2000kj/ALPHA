import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/task_card.dart';
import '../../pomodoro/index.dart';

/// الشاشة الرئيسية المحسنة لقائمة المهام
class TasksScreenV2 extends StatefulWidget {
  const TasksScreenV2({Key? key}) : super(key: key);

  @override
  State<TasksScreenV2> createState() => _TasksScreenV2State();
}

class _TasksScreenV2State extends State<TasksScreenV2>
    with TickerProviderStateMixin {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _taskFocusNode = FocusNode();

  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 1));
  List<String> _selectedTags = [];
  int _estimatedPomodoros = 1;

  // Controllers للرسوم المتحركة
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // النبضة
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // التوهج
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _taskController.dispose();
    _descriptionController.dispose();
    _taskFocusNode.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'قائمة المهام',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.8),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              // زر الإحصائيات
              IconButton(
                onPressed: () => _showStatisticsDialog(context, taskViewModel),
                icon: Icon(
                  Icons.bar_chart,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 28,
                ),
                tooltip: 'الإحصائيات',
              ),
              // قائمة الفلاتر
              PopupMenuButton<TaskFilter>(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 28,
                ),
                onSelected: (filter) {
                  taskViewModel.setFilter(filter);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: TaskFilter.all,
                    child: Text('جميع المهام'),
                  ),
                  const PopupMenuItem(
                    value: TaskFilter.active,
                    child: Text('المهام النشطة'),
                  ),
                  const PopupMenuItem(
                    value: TaskFilter.completed,
                    child: Text('المهام المكتملة'),
                  ),
                  const PopupMenuItem(
                    value: TaskFilter.highPriority,
                    child: Text('أولوية عالية'),
                  ),
                  const PopupMenuItem(
                    value: TaskFilter.dueToday,
                    child: Text('المستحقة اليوم'),
                  ),
                  const PopupMenuItem(
                    value: TaskFilter.overdue,
                    child: Text('المهام المتأخرة'),
                  ),
                ],
              ),
              // قائمة الترتيب
              PopupMenuButton<TaskSort>(
                icon: Icon(
                  Icons.sort,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 28,
                ),
                onSelected: (sort) {
                  taskViewModel.setSort(sort);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: TaskSort.dueDate,
                    child: Text('حسب تاريخ الاستحقاق'),
                  ),
                  const PopupMenuItem(
                    value: TaskSort.priority,
                    child: Text('حسب الأولوية'),
                  ),
                  const PopupMenuItem(
                    value: TaskSort.creationDate,
                    child: Text('حسب تاريخ الإنشاء'),
                  ),
                  const PopupMenuItem(
                    value: TaskSort.title,
                    child: Text('حسب العنوان'),
                  ),
                ],
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFF0A0A0A),
                  Color(0xFF000000),
                  Color(0xFF000000),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // إضافة مهمة جديدة مع التصميم المحسن
                  _buildEnhancedAddTaskSection(),

                  // شريط الفلاتر المحسن
                  _buildEnhancedFilterSection(),

                  // قائمة المهام
                  _buildTasksList(taskViewModel),
                ],
              ),
            ),
          ),
          floatingActionButton: _buildEnhancedFAB(),
        );
      },
    );
  }

  Widget _buildEnhancedAddTaskSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4ECDC4).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  focusNode: _taskFocusNode,
                  decoration: InputDecoration(
                    hintText: 'أضف مهمة جديدة...',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.montserrat(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  onSubmitted: (_) => _addTask(context,
                      Provider.of<TaskViewModel>(context, listen: false)),
                ),
              ),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: IconButton(
                      onPressed: () => _addTask(context,
                          Provider.of<TaskViewModel>(context, listen: false)),
                      icon: Icon(
                        Icons.add_circle,
                        color: const Color(0xFF4ECDC4),
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          // تفاصيل المهمة (تظهر عند التركيز على حقل الإدخال)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: _taskFocusNode.hasFocus
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        _buildEnhancedInputField(
                          controller: _descriptionController,
                          hintText: 'الوصف (اختياري)...',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildEnhancedDropdown(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildEnhancedDatePicker(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildEnhancedPomodoroSelector(),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedInputField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: GoogleFonts.montserrat(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        style: GoogleFonts.montserrat(
          color: Colors.white,
        ),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildEnhancedDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonFormField<TaskPriority>(
        value: _selectedPriority,
        decoration: const InputDecoration(
          labelText: 'الأولوية',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        dropdownColor: const Color(0xFF1A1A2E),
        style: GoogleFonts.montserrat(color: Colors.white),
        items: const [
          DropdownMenuItem(
            value: TaskPriority.high,
            child: Text('عالية'),
          ),
          DropdownMenuItem(
            value: TaskPriority.medium,
            child: Text('متوسطة'),
          ),
          DropdownMenuItem(
            value: TaskPriority.low,
            child: Text('منخفضة'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedPriority = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildEnhancedDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _selectedDueDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('yyyy/MM/dd').format(_selectedDueDate),
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Color(0xFF4ECDC4)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedPomodoroSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            'عدد جلسات البومودورو المقدرة:',
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_estimatedPomodoros > 1) {
                    setState(() {
                      _estimatedPomodoros--;
                    });
                  }
                },
                icon: const Icon(Icons.remove, color: Color(0xFF4ECDC4)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_estimatedPomodoros',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF4ECDC4),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _estimatedPomodoros++;
                  });
                },
                icon: const Icon(Icons.add, color: Color(0xFF4ECDC4)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFilterSection() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildEnhancedFilterChip('الكل', TaskFilter.all),
          const SizedBox(width: 8),
          _buildEnhancedFilterChip('نشطة', TaskFilter.active),
          const SizedBox(width: 8),
          _buildEnhancedFilterChip('مكتملة', TaskFilter.completed),
          const SizedBox(width: 8),
          _buildEnhancedFilterChip('عالية الأولوية', TaskFilter.highPriority),
          const SizedBox(width: 8),
          _buildEnhancedFilterChip('المستحقة اليوم', TaskFilter.dueToday),
        ],
      ),
    );
  }

  Widget _buildEnhancedFilterChip(String label, TaskFilter filter) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, child) {
        final isSelected = taskViewModel.filter == filter;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: FilterChip(
            label: Text(
              label,
              style: GoogleFonts.montserrat(
                color:
                    isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) taskViewModel.setFilter(filter);
            },
            backgroundColor: Colors.black.withValues(alpha: 0.7),
            selectedColor: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
            checkmarkColor: const Color(0xFF4ECDC4),
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF4ECDC4).withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.3),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTasksList(TaskViewModel taskViewModel) {
    if (taskViewModel.isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF4ECDC4),
          ),
        ),
      );
    } else if (taskViewModel.tasks.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.task_alt,
                      size: 60,
                      color: const Color(0xFF4ECDC4).withValues(alpha: 0.8),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد مهام',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'أضف مهمة جديدة للبدء',
                style: GoogleFonts.montserrat(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: taskViewModel.tasks.length,
          itemBuilder: (context, index) {
            final task = taskViewModel.tasks[index];
            return TaskCard(
              task: task,
              onToggle: () => taskViewModel.toggleTaskCompletion(task.id),
              onDelete: () => _confirmDeleteTask(context, taskViewModel, task),
              onEdit: () => _editTask(context, taskViewModel, task),
              onStartPomodoro: () => _startPomodoroForTask(context, task),
              onDuplicate: () => _duplicateTask(context, taskViewModel, task),
            );
          },
        ),
      );
    }
  }

  Widget _buildEnhancedFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        backgroundColor: Colors.black,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.add,
            color: Color(0xFF4ECDC4),
            size: 28,
          ),
        ),
      ),
    );
  }

  void _addTask(BuildContext context, TaskViewModel taskViewModel) {
    if (_taskController.text.trim().isNotEmpty) {
      taskViewModel.addTask(
        title: _taskController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        tags: _selectedTags,
        estimatedPomodoros: _estimatedPomodoros,
      );

      _taskController.clear();
      _descriptionController.clear();
      _taskFocusNode.unfocus();

      setState(() {
        _selectedPriority = TaskPriority.medium;
        _selectedDueDate = DateTime.now().add(const Duration(days: 1));
        _selectedTags.clear();
        _estimatedPomodoros = 1;
      });
    }
  }

  void _confirmDeleteTask(
      BuildContext context, TaskViewModel taskViewModel, TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          'حذف المهمة',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف مهمة "${task.title}"؟',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ),
          TextButton(
            onPressed: () {
              taskViewModel.deleteTask(task.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _editTask(
      BuildContext context, TaskViewModel taskViewModel, TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    ).then((updatedTask) {
      if (updatedTask != null && updatedTask is TaskModel) {
        taskViewModel.updateTask(updatedTask);
      }
    });
  }

  void _duplicateTask(
      BuildContext context, TaskViewModel taskViewModel, TaskModel task) {
    final duplicatedTask = task.copyWith(
      id: '', // سيتم إنشاء ID جديد
      title: '${task.title} (نسخة)',
      isCompleted: false,
      createdAt: DateTime.now(),
      actualPomodoros: 0,
    );

    taskViewModel.addTask(
      title: duplicatedTask.title,
      description: duplicatedTask.description,
      priority: duplicatedTask.priority,
      dueDate: duplicatedTask.dueDate,
      tags: duplicatedTask.tags,
      estimatedPomodoros: duplicatedTask.estimatedPomodoros,
    );
  }

  void _startPomodoroForTask(BuildContext context, TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PomodoroScreen(),
      ),
    );
  }

  void _showStatisticsDialog(
      BuildContext context, TaskViewModel taskViewModel) {
    final stats = taskViewModel.getTaskStatistics();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'إحصائيات المهام',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatisticRow('إجمالي المهام', '${stats['totalTasks']}'),
              _buildStatisticRow(
                  'المهام المكتملة', '${stats['completedTasks']}'),
              _buildStatisticRow('المهام النشطة', '${stats['activeTasks']}'),
              _buildStatisticRow('المهام المتأخرة', '${stats['overdueTasks']}'),
              _buildStatisticRow('المستحقة اليوم', '${stats['dueTodayTasks']}'),
              _buildStatisticRow(
                  'عالية الأولوية', '${stats['highPriorityTasks']}'),
              const Divider(height: 20, color: Color(0xFF4ECDC4)),
              _buildStatisticRow('نسبة الإنجاز',
                  '${stats['completionRate'].toStringAsFixed(1)}%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: TextStyle(color: const Color(0xFF4ECDC4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: const Color(0xFF4ECDC4),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// شاشة إضافة مهمة مفصلة
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  List<String> _tags = [];
  int _estimatedPomodoros = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'إضافة مهمة جديدة',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              'حفظ',
              style: TextStyle(
                color: const Color(0xFF4ECDC4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF000000),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildEnhancedFormField(
                controller: _titleController,
                label: 'عنوان المهمة',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال عنوان المهمة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildEnhancedFormField(
                controller: _descriptionController,
                label: 'الوصف (اختياري)',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildEnhancedPriorityDropdown(),
              const SizedBox(height: 16),
              _buildEnhancedDatePicker(),
              const SizedBox(height: 16),
              _buildEnhancedPomodoroSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: GoogleFonts.montserrat(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        style: GoogleFonts.montserrat(color: Colors.white),
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildEnhancedPriorityDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonFormField<TaskPriority>(
        value: _priority,
        decoration: const InputDecoration(
          labelText: 'الأولوية',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        dropdownColor: const Color(0xFF1A1A2E),
        style: GoogleFonts.montserrat(color: Colors.white),
        items: const [
          DropdownMenuItem(
            value: TaskPriority.high,
            child: Text('عالية'),
          ),
          DropdownMenuItem(
            value: TaskPriority.medium,
            child: Text('متوسطة'),
          ),
          DropdownMenuItem(
            value: TaskPriority.low,
            child: Text('منخفضة'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _priority = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildEnhancedDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _dueDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('yyyy/MM/dd').format(_dueDate),
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Color(0xFF4ECDC4)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedPomodoroSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'عدد جلسات البومودورو المقدرة:',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_estimatedPomodoros > 1) {
                    setState(() {
                      _estimatedPomodoros--;
                    });
                  }
                },
                icon: const Icon(Icons.remove, color: Color(0xFF4ECDC4)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_estimatedPomodoros',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF4ECDC4),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _estimatedPomodoros++;
                  });
                },
                icon: const Icon(Icons.add, color: Color(0xFF4ECDC4)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

      taskViewModel.addTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        tags: _tags,
        estimatedPomodoros: _estimatedPomodoros,
      );

      Navigator.pop(context);
    }
  }
}

// شاشة تعديل المهام
class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late TaskPriority _priority;
  late DateTime _dueDate;
  late List<String> _tags;
  late int _estimatedPomodoros;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    _priority = widget.task.priority;
    _dueDate = widget.task.dueDate;
    _tags = List.from(widget.task.tags);
    _estimatedPomodoros = widget.task.estimatedPomodoros;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'تعديل المهمة',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              'حفظ',
              style: TextStyle(
                color: const Color(0xFF4ECDC4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF000000),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildEnhancedFormField(
                controller: _titleController,
                label: 'عنوان المهمة',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال عنوان المهمة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildEnhancedFormField(
                controller: _descriptionController,
                label: 'الوصف (اختياري)',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildEnhancedPriorityDropdown(),
              const SizedBox(height: 16),
              _buildEnhancedDatePicker(),
              const SizedBox(height: 16),
              _buildEnhancedPomodoroSelector(),
              if (widget.task.actualPomodoros > 0) ...[
                const SizedBox(height: 16),
                _buildCompletedPomodorosDisplay(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedFormField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: GoogleFonts.montserrat(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        style: GoogleFonts.montserrat(color: Colors.white),
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildEnhancedPriorityDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonFormField<TaskPriority>(
        value: _priority,
        decoration: const InputDecoration(
          labelText: 'الأولوية',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        dropdownColor: const Color(0xFF1A1A2E),
        style: GoogleFonts.montserrat(color: Colors.white),
        items: const [
          DropdownMenuItem(
            value: TaskPriority.high,
            child: Text('عالية'),
          ),
          DropdownMenuItem(
            value: TaskPriority.medium,
            child: Text('متوسطة'),
          ),
          DropdownMenuItem(
            value: TaskPriority.low,
            child: Text('منخفضة'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _priority = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildEnhancedDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _dueDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('yyyy/MM/dd').format(_dueDate),
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Color(0xFF4ECDC4)),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedPomodoroSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'عدد جلسات البومودورو المقدرة:',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_estimatedPomodoros > 1) {
                    setState(() {
                      _estimatedPomodoros--;
                    });
                  }
                },
                icon: const Icon(Icons.remove, color: Color(0xFF4ECDC4)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_estimatedPomodoros',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF4ECDC4),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _estimatedPomodoros++;
                  });
                },
                icon: const Icon(Icons.add, color: Color(0xFF4ECDC4)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedPomodorosDisplay() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'عدد جلسات البومودورو المنجزة: ${widget.task.actualPomodoros}',
            style: GoogleFonts.montserrat(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

      final updatedTask = widget.task.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        tags: _tags,
        estimatedPomodoros: _estimatedPomodoros,
      );

      taskViewModel.updateTask(updatedTask);

      Navigator.pop(context, updatedTask);
    }
  }
}
