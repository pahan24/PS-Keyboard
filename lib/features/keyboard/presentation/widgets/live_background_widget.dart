import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/keyboard_theme.dart';

class LiveBackgroundWidget extends StatefulWidget {
  final LiveBackgroundType type;
  final bool isRgbAnimated;
  final double rgbSpeed;

  const LiveBackgroundWidget({
    super.key,
    required this.type,
    this.isRgbAnimated = false,
    this.rgbSpeed = 1.0,
  });

  @override
  State<LiveBackgroundWidget> createState() => _LiveBackgroundWidgetState();
}

class _LiveBackgroundWidgetState extends State<LiveBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (2000 / widget.rgbSpeed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == LiveBackgroundType.none && !widget.isRgbAnimated) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: LiveBackgroundPainter(
            progress: _controller.value,
            type: widget.type,
            isRgbAnimated: widget.isRgbAnimated,
          ),
        );
      },
    );
  }
}

class LiveBackgroundPainter extends CustomPainter {
  final double progress;
  final LiveBackgroundType type;
  final bool isRgbAnimated;

  LiveBackgroundPainter({
    required this.progress,
    required this.type,
    required this.isRgbAnimated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (isRgbAnimated) {
      _paintRgbWave(canvas, size);
    }

    switch (type) {
      case LiveBackgroundType.matrix:
        _paintMatrixRain(canvas, size);
        break;
      case LiveBackgroundType.galaxy:
        _paintGalaxyStars(canvas, size);
        break;
      case LiveBackgroundType.neonPulse:
        _paintNeonPulse(canvas, size);
        break;
      case LiveBackgroundType.particles:
        _paintParticles(canvas, size);
        break;
      default:
        break;
    }
  }

  void _paintRgbWave(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final hue = (progress * 360) % 360;
    final gradient = LinearGradient(
      colors: [
        HSVColor.fromAHSV(0.3, hue, 0.9, 1.0).toColor(),
        HSVColor.fromAHSV(0.3, (hue + 120) % 360, 0.9, 1.0).toColor(),
        HSVColor.fromAHSV(0.3, (hue + 240) % 360, 0.9, 1.0).toColor(),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _paintMatrixRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF66).withOpacity(0.4)
      ..strokeWidth = 1.5;

    final random = Random(42);
    const columns = 25;
    final colWidth = size.width / columns;

    for (int i = 0; i < columns; i++) {
      final speed = random.nextDouble() * 0.8 + 0.2;
      final yPos = ((progress * speed * 2) + (i / columns)) % 1.0 * size.height;
      canvas.drawLine(
        Offset(i * colWidth, yPos),
        Offset(i * colWidth, yPos + 15),
        paint,
      );
    }
  }

  void _paintGalaxyStars(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.6);
    final random = Random(100);

    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = (sin((progress * 2 * pi) + i) + 1) * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _paintNeonPulse(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (sin(progress * 2 * pi) + 1) * 80 + 40;

    final paint = Paint()
      ..color = const Color(0xFFFF007F).withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(center, radius, paint);
  }

  void _paintParticles(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF64FFDA).withOpacity(0.35);
    final random = Random(7);

    for (int i = 0; i < 20; i++) {
      final speed = random.nextDouble() * 0.5 + 0.1;
      final x = (random.nextDouble() * size.width + sin(progress * 2 * pi + i) * 10) % size.width;
      final y = (size.height - (progress * speed * size.height + i * 20) % size.height);
      canvas.drawCircle(Offset(x, y), 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LiveBackgroundPainter oldDelegate) => true;
}
