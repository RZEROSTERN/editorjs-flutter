import 'package:editorjs_flutter/src/model/EditorJSBlockData.dart';

class EditorJSBlock {
  final String type;
  final EditorJSBlockData data;

  EditorJSBlock({this.type, this.data});

  factory EditorJSBlock.fromJson(Map<String, dynamic> parsedJson) {
    return EditorJSBlock(
      data: EditorJSBlockData.fromJson(parsedJson['data']), 
      type: parsedJson['type']
    );
  }
}