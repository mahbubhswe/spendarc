import 'dart:math';

import 'package:flutter/material.dart';

class ArcMeter extends StatelessWidget {
  final double income;
  final double expense;
  final double width;
  final double height;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;
  final Color valueColor;
  final Color labelColor;
  final String label;

  const ArcMeter({
    super.key,
    required this.income,
    required this.expense,
    this.width = 180,
    this.height = 120,
    this.strokeWidth = 14,
    this.trackColor = const Color(0xFFD9D9D9),
    this.progressColor = Colors.redAccent,
    this.valueColor = const Color(0xFF111827),
    this.labelColor = const Color(0xFF6B7280),
    this.label = 'Spent',
  });

  @override
  Widget build(BuildContext context) {
    final total = income + expense;

    final expensePercent =
        total == 0
            ? 0.0
            : expense / total;

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: expensePercent,
      ),
      duration: const Duration(
        milliseconds: 900,
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return CustomPaint(
          size: Size(width, height),
          painter: ArcMeterPainter(
            percent: value,
            strokeWidth: strokeWidth,
            trackColor: trackColor,
            progressColor: progressColor,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(value * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: width * 0.135,
                        fontWeight: FontWeight.bold,
                        color: valueColor,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: width * 0.07,
                        color: labelColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArcMeterPainter
    extends CustomPainter {

  final double percent;
  final double strokeWidth;
  final Color trackColor;
  final Color progressColor;

  ArcMeterPainter({
    required this.percent,
    required this.strokeWidth,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height,
    );

    final radius =
        size.width / 2 - strokeWidth;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final backgroundPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = pi;
    const sweepAngle = pi;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant ArcMeterPainter oldDelegate,
  ) {
    return oldDelegate.percent != percent ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
