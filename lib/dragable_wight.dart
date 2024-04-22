import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SlideDirection { left, right }

class DragableWight extends StatefulWidget {
  final Widget child;
  final ValueChanged<SlideDirection>? onSlideOut;

  const DragableWight({super.key, required this.child, this.onSlideOut});

  @override
  State<StatefulWidget> createState() {
    return _DragableWightState();
  }
}

class _DragableWightState extends State<DragableWight>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Size screenSize;
  final _widgetKey = GlobalKey();
  Offset startOffset = Offset.zero;
  Offset panOffset = Offset.zero;
  double angle = 0;
  Size size = Size.zero;
  bool itWasMadeSlide = false;
  double startDx = 0;
  double rightDx = 0;
  double leftDx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      getChildSize();
    });
    animationController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(restoreAnimationListener);
  }

  Offset get currentPosition {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset(size.width, 0)) ?? Offset.zero;
  }

  Offset get LeftcurrentPosition {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset(0, 0)) ?? Offset.zero;
  }

  double get outSizeLimit => size.width * 0.65;

  double get currentAngle {
    // var moveDx = currentPosition.dx - startDx;
    // var leftMoveDx = rightDx - LeftcurrentPosition.dx - size.width;
    // if (moveDx > 0 && moveDx < rightDx) {
    //   return 0;
    // }
    // if (moveDx < 0 && LeftcurrentPosition.dx - size.width > 0) {
    //   return 0;
    // }
    // print('是否${currentPosition.dx + size.width > screenSize.width}');
    // print('尺寸${size.width}');
    // print('屏幕${screenSize.width}');
    // print('过没${currentPosition.dx > screenSize.width}');
    print(currentPosition.dx);
    return currentPosition.dx < 0
        ? (pi * 0.2) * currentPosition.dx / size.width
        : (pi * 0.2) *
            (currentPosition.dx + size.width - screenSize.width) /
            size.width;
  }

  void getChildSize() {
    size =
        (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ??
            Size.zero;
  }

  void restoreAnimationListener() {
    if (animationController.isCompleted) {
      animationController.reset();
      panOffset = Offset.zero;
      itWasMadeSlide = false;
      angle = 0;
      setState(() {});
    }
  }

  void onPanDown(DragDownDetails details) {
    startDx = currentPosition.dx;
    rightDx = screenSize.width - currentPosition.dx - size.width;
    leftDx = currentPosition.dx;
    startOffset = details.globalPosition;
    if (!animationController.isAnimating) {
      setState(() {
        print('开始${details.globalPosition}');
        startOffset = details.globalPosition;
      });
    }
  }

  void onPanEnd(DragEndDetails details) {
    if (animationController.isAnimating) {
      return;
    }
    final velocityX = details.velocity.pixelsPerSecond.dx;
    final positionX = currentPosition.dx;

    if (positionX < outSizeLimit) {
      print('左边');
      itWasMadeSlide = widget.onSlideOut != null;
      widget.onSlideOut?.call(SlideDirection.left);
    }
    if (positionX - (screenSize.width) > outSizeLimit) {
      print('组偶便');
      itWasMadeSlide = widget.onSlideOut != null;
      widget.onSlideOut?.call(SlideDirection.right);
    }
    animationController.forward();
  }

  void onPanUpdate(DragUpdateDetails details) {
    print(details.globalPosition);
    if (!animationController.isAnimating) {
      setState(() {
        panOffset = details.globalPosition - startOffset;
        angle = currentAngle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(key: _widgetKey, child: widget.child);
    return GestureDetector(
      onPanDown: onPanDown,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            final value = 1 - animationController.value;
            return Transform.translate(
              offset: panOffset * value,
              child: Transform.rotate(
                angle: angle * (itWasMadeSlide ? 1 : value),
                child: child,
              ),
            );
          }),
    );
  }
}
