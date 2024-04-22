import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation/dragable_wight.dart';

import 'cover_image.dart';

class DragableSlider extends StatefulWidget {
  final Function(BuildContext context, int index) itemBuilder;
  final int itemCount;

  const DragableSlider(
      {super.key, required this.itemBuilder, required this.itemCount});

  @override
  State<StatefulWidget> createState() {
    return _DragableSliderState();
  }
}

class _DragableSliderState extends State<DragableSlider>
    with SingleTickerProviderStateMixin {
  late int index = 0;
  late AnimationController controller;
  SlideDirection slideDirection = SlideDirection.left;
  final double defaultAngle18Dgree = pi * 0.1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(animationListener);
  }

  void onSlideOut(SlideDirection direction) {
    slideDirection = direction;
    controller.forward();
  }

  void animationListener() {
    if (controller.isCompleted) {
      // Pretty soon you will get it
      // It helps us to make it infinite slide
      setState(() {
        if (widget.itemCount == ++index) {
          index = 0;
        }
      });
      controller.reset();
    }
  }

  Offset getOffset(int index) {
    return {
      0: Offset(lerpDouble(0, -70, controller.value)!, 30),
      1: Offset(lerpDouble(-70, 70, controller.value)!, 30),
      2: Offset(70, 30) * (1 - controller.value),
    }[index] ??
        Offset(
            MediaQuery.of(context).size.width *
                controller.value *
                (slideDirection == SlideDirection.left ? -1 : 1),
            -30);
  }

  double getAngle(int index) {
    return {
      0: lerpDouble(-0.3, -defaultAngle18Dgree, controller.value),
      1: lerpDouble(
          -defaultAngle18Dgree, defaultAngle18Dgree, controller.value),
      2: lerpDouble(defaultAngle18Dgree, 0, controller.value),
    }[index] ??
        0;
  }

  double getScale(int index) {
    return  {
      0: lerpDouble(0.6, 0.9, controller.value),
      1: lerpDouble(0.9, 0.95, controller.value),
      2: lerpDouble(0.95, 1, controller.value),
    }[index] ??
        1.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Stack(
            children: List.generate(4, (stackIndex) {
              final modIndex = (index + 3 - stackIndex) % widget.itemCount;
              return Transform.translate(
                offset: getOffset(stackIndex),
                child: Transform.scale(
                    scale: getScale(stackIndex),
                    child: Transform.rotate(
                      angle: getAngle(stackIndex),
                      child: DragableWight(
                          onSlideOut: onSlideOut,
                          child: widget.itemBuilder(context, modIndex)),
                    )),
              );
            }),
          );
        });
  }
}
