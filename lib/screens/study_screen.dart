import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StudyScreen extends StatelessWidget {
  final String filePath;

  const StudyScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 30,
        ),
      ),
        title: const Icon(Icons.book_rounded, size: 30),
      ),
      body: SfPdfViewer.file((File(filePath))),
    );
  }
}
