import 'dart:ui';

import 'package:flutter/material.dart';

import '../utilities/colours.dart';

class FrostedGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;

  const FrostedGlassContainer({super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colours.grey.withOpacity(0.1)
                : Colours.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colours.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
