import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widgets/custom_text.dart';

class StudyScreen extends StatelessWidget {
  final String fileUrl, bookName;

  const StudyScreen({super.key, required this.fileUrl, required this.bookName});

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
        title: CustomText(
          text: bookName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
      body: SfPdfViewer.network(fileUrl),
    );
  }
}
