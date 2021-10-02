class EditorJSCSSTag {
  final String? tag;
  final String? backgroundColor;
  final String? color;
  final double? padding;

  EditorJSCSSTag({this.tag, this.backgroundColor, this.color, this.padding});

  factory EditorJSCSSTag.fromJson(Map<String, dynamic> parsedJson) {
    return EditorJSCSSTag(
      tag: parsedJson['tag'],
      backgroundColor: parsedJson['backgroundColor'],
      color: parsedJson['color'],
      padding: parsedJson['padding'],
    );
  }
}
