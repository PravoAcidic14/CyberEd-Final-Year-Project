import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  File file;
  final _imagePicker = ImagePicker();

  Future openCamera() async {
    try {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.camera);

      file = File(pickedFile.path);
      return file;
    } catch (e) {
      return Future.error('An Error Has Occured. Please Try Again');
    }
  }

  Future<File> openGallery() async {
    try {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.gallery);
      file = File(pickedFile.path);

      return file;
    } catch (e) {
      return Future.error('An Error Has Occured. Please Try Again');
    }
  }
}
