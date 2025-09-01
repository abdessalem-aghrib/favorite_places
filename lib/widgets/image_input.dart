import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function(File) onImagePicked;

  const ImageInput({required this.onImagePicked, super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedPicture;

  takePicture() async {
    var imagePicker = ImagePicker();
    var pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage is XFile) {
      setState(() {
        selectedPicture = File(pickedImage.path);
      });

      widget.onImagePicked(File(pickedImage.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: Icon(Icons.camera),
      label: Text('Take Picture'),
      onPressed: takePicture,
    );

    if (selectedPicture != null) {
      content = GestureDetector(
        onTap: takePicture,
        child: Image.file(
          selectedPicture!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      child: content,
    );
  }
}
