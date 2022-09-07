import 'package:flutter/material.dart';
import 'dart:math' as math;

class TransformWidget extends StatelessWidget {
  const TransformWidget(
      {required this.radius,
      required this.angle,
      required this.child,
      Key? key})
      : super(key: key);

  final double radius;
  final double angle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);

    return Transform(
      transform: Matrix4.translationValues(x, y, 0.0),
      child: child,
    );
  }
}
