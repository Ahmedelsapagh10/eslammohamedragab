import 'package:flutter/material.dart';

import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import 'custom_image.dart';

class HexagonProfile extends StatefulWidget {
  final String imagePath;
  final double size;
  final int sides;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  const HexagonProfile({
    super.key,
    required this.imagePath,
    this.size = 200,
    this.sides = 6,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  @override
  State<HexagonProfile> createState() => _HexagonProfileState();
}

class _HexagonProfileState extends State<HexagonProfile>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Shadow
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                // Polygon Image
                ClipPath(
                  clipper: PolygonClipper(sides: widget.sides),
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    color: AppColors.surface,
                    child: CustomImage(
                      image: widget.imagePath,
                      fit: widget.fit,
                      alignment: widget.alignment,
                    ),
                  ),
                ),
                // Polygon Border
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: PolygonBorderPainter(
                    color: isHovered ? AppColors.accent : AppColors.secondary,
                    width: 2.0, // Thinner border
                    sides: widget.sides,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PolygonClipper extends CustomClipper<Path> {
  final int sides;

  PolygonClipper({required this.sides});

  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final halfWidth = width / 2;
    final halfHeight = height / 2;
    final angle = (math.pi * 2) / sides;

    path.moveTo(
      halfWidth + halfWidth * math.cos(0),
      halfHeight + halfHeight * math.sin(0),
    );

    for (int i = 1; i <= sides; i++) {
      path.lineTo(
        halfWidth + halfWidth * math.cos(angle * i),
        halfHeight + halfHeight * math.sin(angle * i),
      );
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant PolygonClipper oldClipper) =>
      sides != oldClipper.sides;
}

class PolygonBorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final int sides;

  PolygonBorderPainter({
    required this.color,
    required this.width,
    required this.sides,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final angle = (math.pi * 2) / sides;

    path.moveTo(
      center.dx + radius * math.cos(0),
      center.dy + radius * math.sin(0),
    );

    for (int i = 1; i <= sides; i++) {
      path.lineTo(
        center.dx + radius * math.cos(angle * i),
        center.dy + radius * math.sin(angle * i),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PolygonBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      width != oldDelegate.width ||
      sides != oldDelegate.sides;
}
