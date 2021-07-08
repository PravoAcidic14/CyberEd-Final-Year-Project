import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PDFViewContainer extends StatefulWidget {
  final file;
  PDFViewContainer(this.file);
  @override
  createState() => _PDFViewContainerState(this.file);
}

class _PDFViewContainerState extends State<PDFViewContainer> {
  
  var file;
  _PDFViewContainerState(this.file);


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final name = basename(file.path);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
