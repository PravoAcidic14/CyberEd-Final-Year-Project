import 'dart:io';

import 'package:file_picker/file_picker.dart';

class AppFilePicker {
  File file;

  Future pickPDFFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (result != null) {
      file = File(result.files.single.path);
      return file;
    }
  }
}
