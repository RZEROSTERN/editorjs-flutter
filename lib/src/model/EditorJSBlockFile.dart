class EditorJSBlockFile {
  final String? url;

  EditorJSBlockFile({this.url});

  factory EditorJSBlockFile.fromJson(Map<String, dynamic> parsedJson) {
    return EditorJSBlockFile(url: parsedJson['url']);
  }
}
