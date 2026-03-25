import '../../domain/entities/block_entity.dart';

/// Contract for deserializing a specific EditorJS block type.
/// Implement this to add support for a new block type.
abstract interface class BlockMapper<T extends BlockEntity> {
  /// The EditorJS type string this mapper handles (e.g. 'header').
  String get supportedType;

  /// Deserializes the raw EditorJS `data` map into a typed [BlockEntity].
  T fromJson(Map<String, dynamic> data);
}
