import 'dart:math';

import 'package:flutter/material.dart';

class CircularPercentageWidget extends StatelessWidget {
  final List<double> percentages;
  final List<Color> colors;
  final String text;

  const CircularPercentageWidget(
      {super.key, required this.percentages, required this.colors, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 150, // Adjust the size as needed
            height: 150,
            child: CustomPaint(
              painter: CircularPercentagePainter(
                percentages: percentages,
                colors: colors,
              ),
            ),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CircularPercentagePainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;

  CircularPercentagePainter({required this.percentages, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final double totalPercentage = percentages.fold(0, (a, b) => a + b);
    final double radius = size.width / 2;
    const double strokeWidth = 25.0;
    double currentAngle = -pi / 2;

    for (int i = 0; i < percentages.length; i++) {
      final double sweepAngle = 2 * pi * (percentages[i] / totalPercentage);
      final Paint paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(radius, radius), radius: radius - strokeWidth / 2),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );

      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
