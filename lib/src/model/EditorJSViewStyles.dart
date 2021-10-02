import 'package:editorjs_flutter/src/model/EditorJSCSSTag.dart';

class EditorJSViewStyles {
  final List<EditorJSCSSTag>? cssTags;
  final String? defaultFont;

  EditorJSViewStyles({this.cssTags, this.defaultFont});

  factory EditorJSViewStyles.fromJson(Map<String, dynamic> parsedJson) {
    var listTags = parsedJson['cssTags'] as List;

    List<EditorJSCSSTag> tagsList =
        listTags.map((i) => EditorJSCSSTag.fromJson(i)).toList();

    return EditorJSViewStyles(
        cssTags: tagsList, defaultFont: parsedJson['defaultFont']);
  }
}
