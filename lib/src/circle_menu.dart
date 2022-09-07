import 'package:circle_menu_animation/src/transform_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math' as math;

import 'circle_menu_controller.dart';

class CircleMenuAnimation extends StatefulWidget {
  const CircleMenuAnimation(
      {required this.circleMenuController,
      required this.childrens,
      this.itemSize = 100,
      this.rotateDuration = const Duration(milliseconds: 1000),
      this.radiusAnimDuration = const Duration(milliseconds: 1000),
      this.radius = 115,
      this.itemColor = Colors.grey,
      Key? key})
      : super(key: key);

  final CircleMenuController circleMenuController;
  final List<Widget> childrens;

  final double itemSize;
  final Duration rotateDuration;
  final Duration radiusAnimDuration;
  final double radius;
  final Color itemColor;

  @override
  State<StatefulWidget> createState() => _CircleMenuAnimationState();
}

class _CircleMenuAnimationState extends State<CircleMenuAnimation>
    with TickerProviderStateMixin {
  double angleDelta = -90.0;

  late AnimationController _controller;
  late Animation<double> _animation;
  late Tween<double> _tween;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;
  late Tween<double> _radiusTween;

  @override
  void initState() {
    super.initState();

    _tween = Tween(begin: 0.0, end: 1.0);
    _radiusTween = Tween(begin: widget.radius, end: 0.0);

    _controller =
        AnimationController(vsync: this, duration: widget.rotateDuration);
    _radiusController = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: widget.rotateDuration.inMilliseconds ~/ 2));

    _animation = _tween.animate(_controller);
    _radiusAnimation = _radiusTween.animate(_radiusController);

    widget.circleMenuController.forward = _onTap;
  }

  @override
  void dispose() {
    _controller.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: widget.childrens
            .mapIndexed((index, element) =>
                _renderAnimatedItem(index: index, child: element))
            .toList());
  }

  Widget _renderAnimatedItem({required int index, required Widget child}) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final delta = angleDelta + _animation.value * 90;

          final coef = 360 / widget.childrens.length * index;

          return AnimatedBuilder(
              animation: _radiusAnimation,
              builder: (context, child) {
                return TransformWidget(
                    radius: _radiusAnimation.value,
                    angle: (coef + delta) * math.pi / 180.0,
                    child: Container(
                      width: widget.itemSize,
                      height: widget.itemSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: widget.itemColor),
                      child: child,
                    ));
              });
        });
  }

  void _onTap() {
    if (_controller.isCompleted) {
      final end = _tween.end ?? 0;
      _tween.begin = _tween.end;
      _tween.end = end + 1;
      _controller.reset();
    }

    _controller.forward();
    _radiusController.forward().then((value) => _radiusController.reverse());
  }
}
