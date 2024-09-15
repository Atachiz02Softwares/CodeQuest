import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'widgets.dart';

class GlassButton extends StatelessWidget {
  final WidgetRef widgetRef;
  final String assetPath;
  final String buttonText;
  final VoidCallback onTap;

  const GlassButton({
    super.key,
    required this.widgetRef,
    required this.assetPath,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: FrostedGlassContainer(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SvgPicture.asset(
                assetPath,
                width: screenSize.width * 0.1,
                height: screenSize.width * 0.1,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomText(
                  text: buttonText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
