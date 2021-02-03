import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditorJSToolbar extends StatefulWidget {
  EditorJSToolbar({
    Key key,
  }) : super(key: key);

  @override
  EditorJSToolbarState createState() => EditorJSToolbarState();
}

class EditorJSToolbarState extends State<EditorJSToolbar> {
  int headerSize = 1;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }
  
  void changeHeader() {
    setState(() {
      if(headerSize > 5) {
        headerSize = 1;
      } else {
        headerSize++;
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void openBottom(context) {
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera), title: Text("Cámara"),
                onTap: () => getImageFromCamera(),
              ),
              ListTile(
                leading: Icon(Icons.image), title: Text("Galería"),
                onTap: () => getImageFromGallery(),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          GestureDetector(
            onTap: () {
              print("Adds new paragraph");
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("T", style: TextStyle(color: Colors.black38, fontSize: 20.0, fontWeight: FontWeight.bold),)
            ),
          ),
          GestureDetector(
            onTap: () => changeHeader(),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("H" + headerSize.toString(), style: TextStyle(color: Colors.black38, fontSize: 20.0, fontWeight: FontWeight.bold),)
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.format_quote, color: Colors.black38,),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.list, color: Colors.black38,),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.link, color: Colors.black38,),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.horizontal_rule, color: Colors.black38,),
          ),
          GestureDetector(
            onTap: () => openBottom(context),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.image, color: Colors.black38,),
            ),
          )
        ],
      ),
    );
  }
}