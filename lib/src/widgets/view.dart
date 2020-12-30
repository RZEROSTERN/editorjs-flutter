import 'package:flutter/material.dart';

class EditorJSView extends StatefulWidget {
  final String editorJSData;
  
  const EditorJSView({Key key, this.editorJSData}) : super(key: key);

  @override
  EditorJSViewState createState() => EditorJSViewState();
}

@override
void initState() {
  
}

class EditorJSViewState extends State<EditorJSView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Text(widget.editorJSData),
      ],),
    );
  }
}