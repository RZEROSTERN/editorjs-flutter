import '../block_entity.dart';

class ParagraphBlock extends BlockEntity {
  /// HTML string as produced by EditorJS (may contain <b>, <i>, <a>, <mark>, etc.).
  final String html;

  const ParagraphBlock({required this.html});

  @override
  String get type => 'paragraph';

  @override
  Map<String, dynamic> toJson() => {'text': html};
}
