import '../entities/block_document.dart';

abstract interface class DocumentRepository {
  /// Parses an EditorJS JSON string into a [BlockDocument].
  BlockDocument parse(String jsonString);

  /// Serializes a [BlockDocument] back into an EditorJS JSON string.
  String serialize(BlockDocument document);
}
