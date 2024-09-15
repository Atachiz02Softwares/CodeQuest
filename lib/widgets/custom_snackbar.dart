import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomSnackBar {
  static void showSnackBar(BuildContext context, String text,
      {bool? isSuccess}) {
    Color backgroundColor;
    if (isSuccess == null) {
      backgroundColor = Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white;
    } else {
      backgroundColor = isSuccess ? Colors.green : Colors.red;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: CustomText(
          text: text,
          style: TextStyle(
            color: isSuccess == null
                ? (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
