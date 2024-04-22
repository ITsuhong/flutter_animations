import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation/dragable_slider.dart';
import 'package:flutter_animation/magazine.dart';

import 'cover_image.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 1],
          colors: [
            Color(0xff9876cc),
            Color(0xff80c7a9),
          ],
        ),
      ),
      child: Scaffold(
        appBar: _AppBar(),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: DragableSlider(
              itemCount: Magazine.fakeMagazinesValues.length,
              itemBuilder: (context, index) => CoverImage(
                magazine: Magazine.fakeMagazinesValues[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSize {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      clipBehavior: Clip.none,
      title: Image.asset(
        'assets/img/vice/vice-logo.png',
        height: 30,
        color: Colors.white,
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => this;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
