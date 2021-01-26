import 'package:flutter/material.dart';
import 'package:editorjs_flutter/src/widgets/toolbar.dart';

class EditorJSEditor extends StatefulWidget {
  const EditorJSEditor({Key key}) : super(key: key);

  @override
  EditorJSEditorState createState() => EditorJSEditorState();
}

class EditorJSEditorState extends State<EditorJSEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditorJSToolbar()
      ],
    );
  }
}