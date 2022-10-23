import 'package:editorjs_flutter/editorjs_flutter.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class CreateNoteLayout extends StatefulWidget {
  @override
  CreateNoteLayoutState createState() => CreateNoteLayoutState();
}

class CreateNoteLayoutState extends State<CreateNoteLayout> {
  EditorJSEditor editorJSEditor;

  @override
  void initState() {
    super.initState();
    setState(() {
      editorJSEditor = EditorJSEditor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Note")
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            (editorJSEditor != null) ? editorJSEditor : Text("Please wait")
          ],
        )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
