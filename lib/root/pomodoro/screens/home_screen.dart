import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

// استيراد الملفات المنفصلة
import '../models/pomodoro_settings.dart';
import '../services/pomodoro_timer_service.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/stats_dialog.dart';
import '../../tasks/models/task_model.dart';
import '../../tasks/viewmodels/task_viewmodel.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enhanced Pomodoro Timer',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
        primaryColor: const Color(0xFFFF2D2D),
      ),
      home: const PomodoroScreen(),
    );
  }
}

// الشاشة الرئيسية
class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {
  // خدمة المؤقت
  final PomodoroTimerService _timerService = PomodoroTimerService();

  // Controllers للرسوم المتحركة المتقدمة
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _breathingController;
  late AnimationController _rippleController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  late AnimationController _taskGlowController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _taskGlowAnimation;

  // قائمة الجسيمات
  List<Particle> _particles = [];

  // متغيرات المهام
  TaskModel? _selectedTask;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _generateParticles();
  }

  void _setupAnimations() {
    // النبضة المحسنة
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // الدوران البطيء
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    // التنفس
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    // التموج
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    // الجسيمات
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_particleController);

    // التوهج
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // توهج المهمة
    _taskGlowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _taskGlowAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taskGlowController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    _breathingController.repeat(reverse: true);
    _rippleController.repeat();
    _particleController.repeat();
    _glowController.repeat(reverse: true);
    _taskGlowController.repeat(reverse: true);
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle());
    }
  }

  void _onTimerTick() {
    setState(() {});
  }

  void _onTimerComplete() {
    setState(() {});
  }

  // دالة عرض اختيار المهمة
  void _showTaskSelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer<TaskViewModel>(
        builder: (context, taskViewModel, child) {
          final availableTasks = taskViewModel.tasks
              .where((task) =>
                  !task.isCompleted &&
                  task.actualPomodoros < task.estimatedPomodoros)
              .toList();

          return AlertDialog(
            backgroundColor: const Color(0xFF1A1A2E),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'اختر مهمة للعمل عليها',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: availableTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 60,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد مهام متاحة',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أضف مهام جديدة من شاشة المهام',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: availableTasks.length,
                      itemBuilder: (context, index) {
                        final task = availableTasks[index];
                        final isSelected = _selectedTask?.id == task.id;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedTask = task;
                                });
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF4ECDC4)
                                          .withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF4ECDC4)
                                            .withValues(alpha: 0.5)
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.task_alt,
                                      color: isSelected
                                          ? const Color(0xFF4ECDC4)
                                          : Colors.white.withValues(alpha: 0.7),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.title,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? const Color(0xFF4ECDC4)
                                                  : Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (task.description.isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              task.description,
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                          const SizedBox(height: 4),
                                          Text(
                                            '${task.actualPomodoros}/${task.estimatedPomodoros} جلسات',
                                            style: TextStyle(
                                              color: const Color(0xFF4ECDC4),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: const Color(0xFF4ECDC4),
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'إلغاء',
                  style: TextStyle(color: const Color(0xFF4ECDC4)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showTaskSelectorDialog(context),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _selectedTask != null ? Icons.task_alt : Icons.add_task,
                key: ValueKey(_selectedTask != null),
                color: _selectedTask != null
                    ? const Color(0xFFFF2D2D)
                    : Colors.white.withValues(alpha: 0.8),
                size: 28,
              ),
            ),
            tooltip: _selectedTask != null ? 'تغيير المهمة' : 'اختيار مهمة',
          ),
          IconButton(
            onPressed: _showStatsDialog,
            icon: Icon(
              Icons.analytics_outlined,
              color: Colors.white.withValues(alpha: 0.8),
              size: 28,
            ),
          ),
          IconButton(
            onPressed: _showSettingsDialog,
            icon: Icon(
              Icons.tune,
              color: Colors.white.withValues(alpha: 0.8),
              size: 28,
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
        child: Stack(
          children: [
            // خلفية الجسيمات
            if (_timerService.settings.haloEffect) _buildParticleBackground(),

            // المحتوى الرئيسي
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // مؤشر الوضع المحسن
                    _buildEnhancedModeIndicator(),

                    const SizedBox(height: 40),

                    // المؤقت الرئيسي المحسن
                    Expanded(
                      child: Center(
                        child: _buildEnhancedTimerContainer(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // لوحة الإحصائيات المحسنة
                    if (_timerService.settings.showStats)
                      _buildEnhancedStatsPanel(),
                    if (_timerService.settings.showStats)
                      const SizedBox(height: 20),

                    // أزرار التحكم المحسنة
                    _buildEnhancedControlButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildEnhancedFAB(),
    );
  }

  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          painter: ParticlePainter(
            particles: _particles,
            animation: _particleAnimation.value,
            isActive: _timerService.isRunning,
          ),
        );
      },
    );
  }

  Widget _buildEnhancedModeIndicator() {
    String modeText;
    Color modeColor;
    IconData modeIcon;

    switch (_timerService.currentMode) {
      case TimerMode.work:
        modeText = 'FOCUS TIME';
        modeColor = const Color(0xFFFF2D2D);
        modeIcon = Icons.work_outline;
        break;
      case TimerMode.shortBreak:
        modeText = 'SHORT BREAK';
        modeColor = const Color(0xFF00FFFF);
        modeIcon = Icons.coffee_outlined;
        break;
      case TimerMode.longBreak:
        modeText = 'LONG BREAK';
        modeColor = const Color(0xFF00FF88);
        modeIcon = Icons.spa_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: modeColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: modeColor.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                modeIcon,
                color: modeColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _timerService.currentMode == TimerMode.work &&
                        _selectedTask != null
                    ? AnimatedBuilder(
                        animation: _taskGlowAnimation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: modeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: modeColor.withValues(
                                    alpha: 0.4 * _taskGlowAnimation.value),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: modeColor.withValues(
                                      alpha: 0.3 * _taskGlowAnimation.value),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  color: modeColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    _selectedTask!.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: modeColor,
                                      letterSpacing: 1,
                                      shadows: [
                                        Shadow(
                                          color: modeColor.withValues(
                                              alpha: 0.5 *
                                                  _taskGlowAnimation.value),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : _timerService.currentMode == TimerMode.work
                        ? GestureDetector(
                            onTap: () => _showTaskSelectorDialog(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: modeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: modeColor.withValues(alpha: 0.3),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_task,
                                    color: modeColor.withValues(alpha: 0.7),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'اختر مهمة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: modeColor.withValues(alpha: 0.7),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Text(
                            modeText,
                            key: ValueKey(_timerService.currentMode),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: modeColor,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: modeColor.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                key: ValueKey(
                    '${_timerService.currentMode}_${_selectedTask?.id ?? "no_task"}'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: modeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Cycle ${_timerService.currentCycle}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedTimerContainer() {
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _timerService.isRunning ? _breathingAnimation.value : 1.0,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(175),
              border: Border.all(
                color: _getCurrentModeColor().withValues(alpha: 0.6),
                width: 2,
              ),
              boxShadow: [
                // الظل الخارجي
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
                // التوهج الملون
                BoxShadow(
                  color: _getCurrentModeColor().withValues(alpha: 0.4),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // الهالة المتوهجة المحسنة
                if (_timerService.settings.haloEffect)
                  _buildEnhancedGlowingHalo(),

                // التموج
                if (_timerService.isRunning) _buildRippleEffect(),

                // حلقة التقدم المحسنة
                _buildEnhancedProgressRing(),

                // عرض الوقت المحسن
                _buildEnhancedTimeDisplay(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedGlowingHalo() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Container(
              width: 380 + (30 * _glowAnimation.value),
              height: 380 + (30 * _glowAnimation.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _getCurrentModeColor()
                        .withValues(alpha: 0.6 * _glowAnimation.value),
                    _getCurrentModeColor()
                        .withValues(alpha: 0.3 * _glowAnimation.value),
                    _getCurrentModeColor()
                        .withValues(alpha: 0.1 * _glowAnimation.value),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 0.4, 0.7, 1.0],
                ),
              ),
              transform: Matrix4.rotationZ(_rotationAnimation.value),
            );
          },
        );
      },
    );
  }

  Widget _buildRippleEffect() {
    return AnimatedBuilder(
      animation: _rippleAnimation,
      builder: (context, child) {
        return Container(
          width: 350 + (100 * _rippleAnimation.value),
          height: 350 + (100 * _rippleAnimation.value),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getCurrentModeColor()
                  .withValues(alpha: 0.3 * (1 - _rippleAnimation.value)),
              width: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedProgressRing() {
    return CustomPaint(
      size: const Size(320, 320),
      painter: EnhancedProgressRingPainter(
        progress: _timerService.progress,
        isActive: _timerService.isRunning,
        mode: _timerService.currentMode,
        glowIntensity: 0.8,
      ),
    );
  }

  Widget _buildEnhancedTimeDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // الوقت الرئيسي
        Stack(
          children: [
            // التوهج الخلفي
            Text(
              _timerService.formattedTime,
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w200,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4
                  ..color = _getCurrentModeColor().withValues(alpha: 0.3),
              ),
            ),
            // النص الرئيسي
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _timerService.formattedTime,
                key: ValueKey(_timerService.formattedTime),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: _getCurrentModeColor().withValues(alpha: 0.8),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // شريط التقدم الصغير
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _timerService.progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getCurrentModeColor(),
                    _getCurrentModeColor().withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: _getCurrentModeColor().withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedStatsPanel() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getCurrentModeColor().withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEnhancedStatItem(
            'Completed',
            _timerService.completedPomodoros.toString(),
            Icons.check_circle_outline,
            const Color(0xFF4ECDC4),
          ),
          _buildEnhancedStatItem(
            'Focus',
            _timerService.formatDuration(_timerService.totalFocusTime),
            Icons.access_time,
            const Color(0xFFFFE66D),
          ),
          _buildEnhancedStatItem(
            'Cycle',
            _timerService.currentCycle.toString(),
            Icons.repeat,
            const Color(0xFFFF8E53),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [
              Shadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 5,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // زر إعادة التعيين
        _buildEnhancedControlButton(
          onPressed: () {
            _timerService.resetTimer();
            setState(() {});
          },
          icon: Icons.refresh,
          label: 'RESET',
          color: const Color(0xFF4ECDC4),
        ),

        const SizedBox(width: 20),

        // زر التشغيل/الإيقاف الرئيسي
        _buildEnhancedControlButton(
          onPressed: () {
            if (_timerService.isRunning) {
              _timerService.pauseTimer();
            } else {
              _timerService.startTimer(_onTimerTick, _onTimerComplete);
            }
            setState(() {});
          },
          icon: _timerService.isRunning ? Icons.pause : Icons.play_arrow,
          label: _timerService.isRunning ? 'PAUSE' : 'START',
          color: const Color(0xFFFF2D2D),
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildEnhancedControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isPrimary ? 180 : 140,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: color.withValues(alpha: 0.6),
            width: isPrimary ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: isPrimary ? 25 : 20,
              spreadRadius: isPrimary ? 5 : 3,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: isPrimary ? 32 : 26,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: isPrimary ? 16 : 14,
                shadows: [
                  Shadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedFAB() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2D2D).withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _timerService.skipSession(_onTimerComplete),
        backgroundColor: Colors.black,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF2D2D).withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.skip_next,
            color: Color(0xFFFF2D2D),
            size: 28,
          ),
        ),
      ),
    );
  }

  Color _getCurrentModeColor() {
    switch (_timerService.currentMode) {
      case TimerMode.work:
        return const Color(0xFFFF2D2D);
      case TimerMode.shortBreak:
        return const Color(0xFF00FFFF);
      case TimerMode.longBreak:
        return const Color(0xFF00FF88);
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(
        settings: _timerService.settings,
        onSettingsChanged: (newSettings) {
          _timerService.updateSettings(newSettings);
          setState(() {});
        },
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatsDialog(
        completedPomodoros: _timerService.completedPomodoros,
        totalFocusTime: _timerService.totalFocusTime,
        currentCycle: _timerService.currentCycle,
        onResetStats: () {
          _timerService.resetStats();
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    _timerService.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _breathingController.dispose();
    _rippleController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _taskGlowController.dispose();
    super.dispose();
  }
}

// فئة الجسيمات
class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;
  Color color;

  Particle()
      : x = math.Random().nextDouble(),
        y = math.Random().nextDouble(),
        vx = (math.Random().nextDouble() - 0.5) * 0.002,
        vy = (math.Random().nextDouble() - 0.5) * 0.002,
        size = math.Random().nextDouble() * 3 + 1,
        opacity = math.Random().nextDouble() * 0.8 + 0.2,
        color = Color.fromRGBO(
          math.Random().nextInt(255),
          math.Random().nextInt(255),
          255,
          1,
        );

  void update() {
    x += vx;
    y += vy;

    if (x < 0 || x > 1) vx *= -1;
    if (y < 0 || y > 1) vy *= -1;

    x = x.clamp(0.0, 1.0);
    y = y.clamp(0.0, 1.0);
  }
}

// رسام الجسيمات
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final bool isActive;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive) return;

    for (var particle in particles) {
      particle.update();

      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity * 0.3)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// رسام حلقة التقدم المحسن
class EnhancedProgressRingPainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final TimerMode mode;
  final double glowIntensity;

  EnhancedProgressRingPainter({
    required this.progress,
    required this.isActive,
    required this.mode,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 15;

    // لون الوضع الحالي
    Color modeColor;
    switch (mode) {
      case TimerMode.work:
        modeColor = const Color(0xFFFF2D2D);
        break;
      case TimerMode.shortBreak:
        modeColor = const Color(0xFF00FFFF);
        break;
      case TimerMode.longBreak:
        modeColor = const Color(0xFF00FF88);
        break;
    }

    // رسم الحلقة الخلفية
    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم حلقة التقدم المتوهجة
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          modeColor,
          modeColor.withValues(alpha: 0.6),
          modeColor,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // إضافة تأثير التوهج
    final glowPaint = Paint()
      ..color = modeColor.withValues(alpha: 0.3 * glowIntensity)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final sweepAngle = 2 * math.pi * progress;
    final startAngle = -math.pi / 2;

    // رسم التوهج أولاً
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    // ثم رسم الحلقة الرئيسية
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // رسم نقاط في نهاية الحلقة
    if (progress > 0) {
      final endAngle = startAngle + sweepAngle;
      final endPoint = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );

      final dotPaint = Paint()
        ..color = modeColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(endPoint, 6, dotPaint);

      // نقطة متوهجة
      final glowDotPaint = Paint()
        ..color = modeColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(endPoint, 8, glowDotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
