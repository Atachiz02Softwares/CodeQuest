import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const CustomText({
    super.key,
    required this.text,
    this.style = const TextStyle(),
    this.align,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        fontSize: style.fontSize,
        fontWeight: style.fontWeight,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
