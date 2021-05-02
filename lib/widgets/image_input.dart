import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

enum PictureMethods { Gallery, Camera }

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _selectedImage;

  final picker = ImagePicker();
  PickedFile _pickedFile;

  Future<void> _takePicture() async {
    final value = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text('Choose a method'),
        actions: [
          TextButton(
            child: Text('Gallery'),
            onPressed: () {
              Navigator.of(ctx).pop(PictureMethods.Gallery);
            },
          ),
          TextButton(
            child: Text('Camera'),
            onPressed: () {
              Navigator.of(ctx).pop(PictureMethods.Camera);
            },
          ),
        ],
      ),
    );

    if (value == null) return;

    if (value == PictureMethods.Gallery) {
      _pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
    } else {
      _pickedFile = await picker.getImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
    }

    if (_pickedFile == null) return;

    final imageFile = File(_pickedFile.path);
    setState(() {
      _selectedImage = imageFile;
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);

    // Copy and set a file name
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _selectedImage != null
              ? Image.file(
                  _selectedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take a picture'),
            onPressed: () {
              _takePicture();
            },
          ),
        ),
      ],
    );
  }
}
