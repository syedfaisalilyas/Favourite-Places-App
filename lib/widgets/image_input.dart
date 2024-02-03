import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onpickimage});

  final void Function(File image) onpickimage;
  @override
  State<ImageInput> createState() {
    return _InputImageState();
  }
}

class _InputImageState extends State<ImageInput> {
  File? _selectedimage;
  void _takePicture() async {
    final imagepicker = ImagePicker();
    final pickedimage = await imagepicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedimage == null) {
      return;
    }
    setState(() {
      _selectedimage = File(pickedimage.path);
    });

    widget.onpickimage(_selectedimage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: () {
        _takePicture();
      },
      icon: const Icon(Icons.camera),
      label: const Text(
        'Take a picture',
      ),
    );

    if (_selectedimage != null) {
      content = GestureDetector(
          onTap: _takePicture,
          child: Image.file(
            _selectedimage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ));
    }
    return Container(
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        width: double.infinity,
        child: content);
  }
}
