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
///
/// Undo/redo is supported for structural operations (add, insert, remove, move,
/// clear). Text edits within a block are not tracked individually — each
/// [updateBlock] call replaces the block in place without creating a history
/// entry, keeping the history lean during typing.
class EditorController extends ChangeNotifier {
  final List<BlockEntity> _blocks;
  final SerializeDocument _serializer;

  // --- Undo / redo history ---
  final List<List<BlockEntity>> _history = [];
  int _historyIndex = -1;
  static const int _maxHistorySize = 50;

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
        _serializer = serializer {
    _saveSnapshot(); // record the initial state as snapshot 0
  }

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  /// Whether there is a previous state to restore.
  bool get canUndo => _historyIndex > 0;

  /// Whether there is a forward state to restore after an undo.
  bool get canRedo => _historyIndex < _history.length - 1;

  /// Saves the current block list as a history snapshot.
  ///
  /// Any snapshots ahead of [_historyIndex] (from a prior undo) are discarded.
  void _saveSnapshot() {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(List<BlockEntity>.from(_blocks));
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
    _historyIndex = _history.length - 1;
  }

  /// Restores the previous snapshot, if any.
  void undo() {
    if (!canUndo) return;
    _historyIndex--;
    _blocks
      ..clear()
      ..addAll(_history[_historyIndex]);
    notifyListeners();
  }

  /// Restores the next snapshot after an undo, if any.
  void redo() {
    if (!canRedo) return;
    _historyIndex++;
    _blocks
      ..clear()
      ..addAll(_history[_historyIndex]);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Block mutations
  // ---------------------------------------------------------------------------

  /// Unmodifiable view of the current block list.
  List<BlockEntity> get blocks => List.unmodifiable(_blocks);

  int get blockCount => _blocks.length;

  void addBlock(BlockEntity block) {
    _blocks.add(block);
    _saveSnapshot();
    notifyListeners();
  }

  void insertBlock(int index, BlockEntity block) {
    _blocks.insert(index, block);
    _saveSnapshot();
    notifyListeners();
  }

  /// Replaces the block at [index] in place.
  ///
  /// Does NOT create a history snapshot — use this for live text updates.
  /// Structural changes (add, remove, move) are the undo boundaries.
  void updateBlock(int index, BlockEntity updated) {
    assert(index >= 0 && index < _blocks.length);
    _blocks[index] = updated;
    notifyListeners();
  }

  void removeBlock(int index) {
    assert(index >= 0 && index < _blocks.length);
    _blocks.removeAt(index);
    _saveSnapshot();
    notifyListeners();
  }

  void moveBlock(int fromIndex, int toIndex) {
    assert(fromIndex >= 0 && fromIndex < _blocks.length);
    assert(toIndex >= 0 && toIndex < _blocks.length);
    final block = _blocks.removeAt(fromIndex);
    _blocks.insert(toIndex, block);
    _saveSnapshot();
    notifyListeners();
  }

  void clear() {
    _blocks.clear();
    _saveSnapshot();
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
