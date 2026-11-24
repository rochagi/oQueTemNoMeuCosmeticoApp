import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';

class ImageService {
  final ImagePicker _picker;
  final ImageCropper _cropper;

  ImageService({ImagePicker? picker, ImageCropper? cropper})
      : _picker = picker ?? ImagePicker(),
        _cropper = cropper ?? ImageCropper();

  /// Captures or selects an image, then prompts user to crop the ingredients area.
  /// Returns the local path of the cropped image or null if cancelled.
  Future<String?> pickAndCropImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 90,
    );

    if (pickedFile == null) return null;

    final croppedFile = await _cropper.cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar Ingredientes',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Recortar Ingredientes',
          aspectRatioLockEnabled: false,
        ),
      ],
    );

    return croppedFile?.path ?? pickedFile.path;
  }
}
