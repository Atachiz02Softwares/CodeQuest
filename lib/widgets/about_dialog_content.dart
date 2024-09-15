import 'package:flutter/material.dart';

import 'widgets.dart';

class AboutDialogContent extends StatelessWidget {
  const AboutDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const FrostedGlassContainer(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: 'About CodeQuest',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CustomText(
              text:
                  'Code Quest is a cross-platform educational quiz app designed '
                  'to help users learn various programming languages. \n\n'
                  'Developed and Powered by Atachiz02 Softwares.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            CustomText(
              text: 'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
