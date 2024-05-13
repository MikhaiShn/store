import 'package:image_picker/image_picker.dart';
import 'dart:io';
export '../globals.dart';
File? photo;
//Метод для создании контейнера при нажатии которого будет доступ к галерее
Future<void> pickImageFromGallery(void Function(void Function()) setStateCallback) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    setStateCallback(() {
      photo = File(image.path);
    });
  }
}