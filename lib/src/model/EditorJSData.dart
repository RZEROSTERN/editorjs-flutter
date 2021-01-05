import 'package:editorjs_flutter/src/model/EditorJSBlock.dart';

class EditorJSData {
  final int time;
  final String version;
  final List<EditorJSBlock> blocks;

  EditorJSData({
    this.time, this.version, this.blocks
  });

  factory EditorJSData.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['blocks'] as List;
    
    List<EditorJSBlock> blocksList = list.map((i) => EditorJSBlock.fromJson(i)).toList();

    return EditorJSData(
      time: parsedJson['time'],
      version: parsedJson['version'],
      blocks: blocksList
    );
  }

  Map<String, dynamic> toJson() => {
    'time' : time,
    'version' : version,
    'blocks': blocks
  };
}
