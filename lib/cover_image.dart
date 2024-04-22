import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation/magazine.dart';

class CoverImage extends StatelessWidget {
  final Magazine magazine;

  const CoverImage({super.key, required this.magazine});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(magazine.assetImage),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 40,
                offset: Offset(-20, 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
