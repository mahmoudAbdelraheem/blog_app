import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final XFile? selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      return File(selectedImage.path);
    }
    return null;
  } catch (e) {
    //! returning null if the user don't select an image
    //! or don't give the app the requird permition
    return null;
  }
}
