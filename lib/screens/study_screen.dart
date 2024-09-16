import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widgets/custom_text.dart';

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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: filePath.split('/').last,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SfPdfViewer.file((File(filePath))),
    );
  }
}
