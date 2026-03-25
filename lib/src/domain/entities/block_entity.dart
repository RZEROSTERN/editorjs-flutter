abstract class BlockEntity {
  const BlockEntity();

  /// The EditorJS block type string (e.g. 'header', 'paragraph').
  String get type;

  /// Serializes the block's data payload back to EditorJS JSON format.
  /// This produces the value of the `"data"` key — not the full block object.
  Map<String, dynamic> toJson();
}
