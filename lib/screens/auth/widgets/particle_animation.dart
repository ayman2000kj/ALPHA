import 'package:flutter/material.dart';
import 'dart:math' as math;

// فئة الجسيمة المتحركة
class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

// رسام الجسيمات
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(26)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      particle.y += particle.speed * 0.01;
      if (particle.y > 1.2) {
        particle.y = -0.2;
        particle.x = math.Random().nextDouble();
      }

      final dx = particle.x * size.width;
      final dy = particle.y * size.height;

      paint.color = Colors.white.withAlpha((particle.opacity * 0.3 * 255).round());
      canvas.drawCircle(
        Offset(dx, dy),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleAnimation extends StatefulWidget {
  const ParticleAnimation({super.key});

  @override
  State<ParticleAnimation> createState() => _ParticleAnimationState();
}

class _ParticleAnimationState extends State<ParticleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _initializeParticles();
  }

  void _initializeParticles() {
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _generateParticles();
  }

  void _generateParticles() {
    particles = List.generate(20, (index) {
      return Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 4 + 2,
        speed: math.Random().nextDouble() * 0.5 + 0.1,
        opacity: math.Random().nextDouble() * 0.5 + 0.2,
      );
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _particleController.value),
          size: Size.infinite,
        );
      },
    );
  }
} 
