import 'package:flutter/foundation.dart';

import '../../data/datasources/json_document_source.dart';
import '../../data/registry/block_type_registry.dart';
import '../../domain/entities/block_document.dart';
import '../../domain/entities/block_entity.dart';
import '../../domain/usecases/serialize_document.dart';

/// Manages editor state as a list of [BlockEntity] objects.
///
/// Widgets observe changes via [ChangeNotifier]. Call [getContent] to export
/// the current document as an EditorJS-compliant JSON string.
class EditorController extends ChangeNotifier {
  final List<BlockEntity> _blocks;
  final SerializeDocument _serializer;

  /// Creates a controller wired to the default EditorJS JSON serializer.
  /// Pass [typeRegistry] to support custom block types.
  factory EditorController({
    List<BlockEntity>? initialBlocks,
    BlockTypeRegistry? typeRegistry,
  }) {
    final registry = typeRegistry ?? BlockTypeRegistry();
    final serializer = SerializeDocument(JsonDocumentSource(registry: registry));
    return EditorController._internal(
      initialBlocks: initialBlocks,
      serializer: serializer,
    );
  }

  EditorController._internal({
    List<BlockEntity>? initialBlocks,
    required SerializeDocument serializer,
  })  : _blocks = List<BlockEntity>.from(initialBlocks ?? []),
        _serializer = serializer;

  /// Unmodifiable view of the current block list.
  List<BlockEntity> get blocks => List.unmodifiable(_blocks);

  int get blockCount => _blocks.length;

  void addBlock(BlockEntity block) {
    _blocks.add(block);
    notifyListeners();
  }

  void insertBlock(int index, BlockEntity block) {
    _blocks.insert(index, block);
    notifyListeners();
  }

  void updateBlock(int index, BlockEntity updated) {
    assert(index >= 0 && index < _blocks.length);
    _blocks[index] = updated;
    notifyListeners();
  }

  void removeBlock(int index) {
    assert(index >= 0 && index < _blocks.length);
    _blocks.removeAt(index);
    notifyListeners();
  }

  void moveBlock(int fromIndex, int toIndex) {
    assert(fromIndex >= 0 && fromIndex < _blocks.length);
    assert(toIndex >= 0 && toIndex < _blocks.length);
    final block = _blocks.removeAt(fromIndex);
    _blocks.insert(toIndex, block);
    notifyListeners();
  }

  void clear() {
    _blocks.clear();
    notifyListeners();
  }

  /// Exports the current document as an EditorJS-compliant JSON string.
  String getContent() {
    final document = BlockDocument(
      time: DateTime.now().millisecondsSinceEpoch,
      version: '2.19.0',
      blocks: _blocks,
    );
    return _serializer(document);
  }
}
