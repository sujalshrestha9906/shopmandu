import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final mode = StateNotifierProvider<ModeProvider, AutovalidateMode>(
    (ref) => ModeProvider(AutovalidateMode.disabled));

class ModeProvider extends StateNotifier<AutovalidateMode> {
  ModeProvider(super.state);

  void change() {
    state = AutovalidateMode.onUserInteraction;
  }
}

final imageProvider =
    StateNotifierProvider<ImageProvider, XFile?>((ref) => ImageProvider(null));

class ImageProvider extends StateNotifier<XFile?> {
  ImageProvider(super.state);

  void imagePick(bool isCamera) async {
    final ImagePicker _picker = ImagePicker();
    if (isCamera) {
      state = await _picker.pickImage(source: ImageSource.camera);
    } else {
      state = await _picker.pickImage(source: ImageSource.gallery);
    }
  }
}
