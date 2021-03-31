import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:editorjs_flutter/src/widgets/editor.dart';
import 'package:editorjs_flutter/src/widgets/components/textcomponent.dart';
import 'package:url_launcher/url_launcher.dart';

class EditorJSToolbar extends StatefulWidget {
  final EditorJSEditorState parent;

  EditorJSToolbar({
    Key key,
    this.parent
  }) : super(key: key);

  @override
  EditorJSToolbarState createState() => EditorJSToolbarState(this.parent);
}

class EditorJSToolbarState extends State<EditorJSToolbar> {
  int headerSize = 1;
  final picker = ImagePicker();
  EditorJSEditorState parent;

  EditorJSToolbarState(this.parent);

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
        sendImageToEditor(pickedFile);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        sendImageToEditor(pickedFile);
      } else {
        print('No image selected.');
      }
    });
  }

  void sendImageToEditor(pickedFile) {
    this.parent.setState(() {
      this.parent.items.add(Row(children: [
        Image.file(
          File(pickedFile.path),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width - 20,
        )
      ],)
      );
    });
  }

  void addText() {
    this.parent.setState(() {
      this.parent.items.add(Row(children: [TextComponent.addText()],));
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
                leading: Icon(Icons.camera), title: Text("Camera"),
                onTap: () => getImageFromCamera(),
              ),
              ListTile(
                leading: Icon(Icons.image), title: Text("Gallery"),
                onTap: () => getImageFromGallery(),
              ),
            ],
          ),
        );
      }
    );
  }

  void addLine() {
    this.parent.setState(() {
      this.parent.items.add(
        Row(children: [
          Expanded(child: Divider(color: Colors.grey))
        ],)
      );
    });
  }

  void addHyperlink(context) {
    var title = TextEditingController();
    var url = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Add Link"),
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.00, bottom: 20.0),
              child: TextField(
                decoration: new InputDecoration(hintText: "Title"),
                controller: title,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.00, bottom: 20.0),
              child: TextField(
                decoration: new InputDecoration(hintText: "URL"),
                controller: url,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.00),
              child: RaisedButton(
                color: Colors.blue,
                child: Text("Add Link", style: TextStyle(color: Colors.white),),
                onPressed: (){
                  this.parent.setState(() {
                    this.parent.items.add(
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: title.text,
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(url.text);
                                  }
                              ),
                            ])
                          )
                        ],
                      )
                    );
                  });
                  Navigator.pop(context);
                },
              )
            ),
          ],
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
            onTap: () => addText(),
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

          GestureDetector(
            onTap: () => addHyperlink(context),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.link, color: Colors.black38,),
            ),
          ),
          
          GestureDetector(
            onTap: () => addLine(),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.horizontal_rule, color: Colors.black38,),
            ),
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