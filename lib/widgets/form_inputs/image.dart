import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'pick the image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                  child: Text('use Camera'),
                ),
                FlatButton(
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                  child: Text('use galery'),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final buttonAccent = Theme.of(context).accentColor;
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(color: buttonAccent),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.camera_alt),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    'Add Image',
                    style: TextStyle(color: buttonAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        _imageFile == null
            ? Text('pick an image')
            : Image.file(
                _imageFile,
                fit: BoxFit.cover,
                height: 300,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
              ),
      ],
    );
  }
}
