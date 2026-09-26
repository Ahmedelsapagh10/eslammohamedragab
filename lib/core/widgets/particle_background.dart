import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int numberOfParticles;
  final Color particleColor;
  final Color lineColor;

  const ParticleBackground({
    super.key,
    required this.child,
    this.numberOfParticles = 50,
    this.particleColor = AppColors.accent,
    this.lineColor = AppColors.accent,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  Offset? mousePosition;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (particles.isEmpty) {
      final size = MediaQuery.of(context).size;
      _initializeParticles(size);
    }
  }

  void _initializeParticles(Size size) {
    particles = List.generate(
      widget.numberOfParticles,
      (index) => Particle(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 2,
          (_random.nextDouble() - 0.5) * 2,
        ),
        size: _random.nextDouble() * 3 + 1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          mousePosition = event.localPosition;
        });
      },
      onExit: (event) {
        setState(() {
          mousePosition = null;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    particles: particles,
                    mousePosition: mousePosition,
                    particleColor: widget.particleColor,
                    lineColor: widget.lineColor,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  final double size;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
  });

  void update(Size size) {
    position += velocity;

    if (position.dx < 0 || position.dx > size.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > size.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? mousePosition;
  final Color particleColor;
  final Color lineColor;

  ParticlePainter({
    required this.particles,
    this.mousePosition,
    required this.particleColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = particleColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = lineColor.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    for (var particle in particles) {
      particle.update(size);
      canvas.drawCircle(particle.position, particle.size, particlePaint);

      // Connect to other particles
      for (var other in particles) {
        final distance = (particle.position - other.position).distance;
        if (distance < 100) {
          linePaint.color = lineColor.withValues(alpha: 1 - (distance / 100));
          canvas.drawLine(particle.position, other.position, linePaint);
        }
      }

      // Connect to mouse
      if (mousePosition != null) {
        final distance = (particle.position - mousePosition!).distance;
        if (distance < 150) {
          linePaint.color = lineColor.withValues(alpha: 1 - (distance / 150));
          canvas.drawLine(particle.position, mousePosition!, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
