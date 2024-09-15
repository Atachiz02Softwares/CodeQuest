import 'package:flutter/material.dart';

import '../utilities/colours.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      backgroundColor: Colours.primary,
      color: Colours.secondary,
    );
  }
}
