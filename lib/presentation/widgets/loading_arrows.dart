import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

class LoadingArrows extends StatefulWidget {
  static const String routeName = '/LoadingBall';
  double? size;
  Color? color;
  LoadingArrows({this.size, this.color});

  @override
  State<LoadingArrows> createState() => LoadingArrowsState();
}

class LoadingArrowsState extends State<LoadingArrows>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.forward();
    _controller.addListener(() {
      setState(() {
        if (_controller.status == AnimationStatus.completed) {
          _controller.repeat();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: Icon(
          FontAwesome.arrows_cw,
          size: widget.size,
          color: widget.color ?? Colors.black,
        ));
  }
}
