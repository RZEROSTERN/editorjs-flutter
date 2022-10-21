import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:editorjs_flutter/src/widgets/editor.dart';
import 'package:editorjs_flutter/src/widgets/components/textcomponent.dart';
import 'package:url_launcher/url_launcher.dart';

class EditorJSToolbar extends StatefulWidget {
  final EditorJSEditorState? parent;

  EditorJSToolbar({Key? key, this.parent}) : super(key: key);

  @override
  EditorJSToolbarState createState() => EditorJSToolbarState(parent);
}

class EditorJSToolbarState extends State<EditorJSToolbar> {
  double fontSize = 0;
  FontWeight fontWeight = FontWeight.w400;
  final picker = ImagePicker();
  // EditorJSEditorState? parent;

  EditorJSToolbarState(parent);

  void changeHeader(size) {
    setState(
      () {
        switch (size){
          case 1:{
            fontSize = 32;
            fontWeight = FontWeight.bold;
          }
          break;
          case 2:{
            fontSize = 24;
            fontWeight = FontWeight.bold;
          }
          break;
          case 3:{
            fontSize = 20;
            fontWeight = FontWeight.w600;
          }
          break;
          case 4:{
            fontSize = 16;
            fontWeight = FontWeight.w500;
          }
          break;
          case 5:{
            fontSize = 14;
            fontWeight = FontWeight.w400;
          }
          break;
          case 6:{
            fontSize = 12;
            fontWeight = FontWeight.w400;
          }
          break;
          default: {}
          break;
        }
        addText();
      },
    );
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(
      () {
        if (pickedFile != null) {
          sendImageToEditor(pickedFile);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(
      () {
        if (pickedFile != null) {
          sendImageToEditor(pickedFile);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  void sendImageToEditor(pickedFile) {
    widget.parent!.setState(
      () {
        widget.parent!.items.add(
          Row(
            children: [
              Image.file(
                File(pickedFile.path),
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width - 20,
              )
            ],
          ),
        );
      },
    );
  }

  void addText() {
    widget.parent!.setState(
      () {
        widget.parent!.items.add(
          Row(children: <Widget>[TextComponent.addText(size: fontSize, weight: fontWeight)]),
        );
      },
    );
  }

  void openBottom(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () => getImageFromCamera(),
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () => getImageFromGallery(),
              ),
            ],
          ),
        );
      },
    );
  }

  void removeLast() {
    widget.parent!.setState(() {
      widget.parent!.items.removeLast();
    });
  }

  void addLine() {
    widget.parent!.setState(() {
      widget.parent!.items.add(Row(
        children: [Expanded(child: Divider(color: Colors.grey))],
      ));
    });
  }

  void addHyperlink(context) {
    var title = TextEditingController();
    var url = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text("Add Link"),
          children: [
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.00, bottom: 20.0),
              child: TextField(
                decoration: const InputDecoration(hintText: "Title"),
                controller: title,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.00, bottom: 20.0),
              child: TextField(
                decoration: const InputDecoration(hintText: "URL"),
                controller: url,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.00),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text(
                  "Add Link",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  widget.parent!.setState(
                    () {
                      widget.parent!.items.add(
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: title.text,
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => launch(url.text),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void addListBlock() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => addText(),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "T",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              GestureDetector(
                onTap: () => changeHeader(1),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "H1",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              GestureDetector(
                onTap: () => changeHeader(2),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "H2",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              GestureDetector(
                onTap: () => changeHeader(3),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "H3",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              GestureDetector(
                onTap: () => changeHeader(4),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "H4",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              GestureDetector(
                onTap: () => changeHeader(5),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "H5",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              GestureDetector(
                onTap: () => changeHeader(6),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "H6",
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.format_quote,
                  color: Colors.black38,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.list,
                  color: Colors.black38,
                ),
              ),
              GestureDetector(
                onTap: () => addHyperlink(context),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.link,
                    color: Colors.black38,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => addLine(),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.horizontal_rule,
                    color: Colors.black38,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => openBottom(context),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.image,
                    color: Colors.black38,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => removeLast(),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.black38,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
