import 'package:flutter/material.dart';

import 'widgets.dart';

class AboutDialogContent extends StatelessWidget {
  final String title, content, buttonText;
  final VoidCallback? onTap;

  const AboutDialogContent({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedGlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomText(
              text: content,
              style: const TextStyle(fontSize: 16),
            ),
            TextButton.icon(
              onPressed: onTap,
              label: CustomText(
                text: buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
