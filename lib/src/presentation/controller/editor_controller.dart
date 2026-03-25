import 'package:flutter/foundation.dart';

import '../../data/datasources/json_document_source.dart';
import '../../data/registry/block_type_registry.dart';
import '../../domain/entities/block_document.dart';
import '../../domain/entities/block_entity.dart';
import '../../domain/usecases/serialize_document.dart';

/// A paired snapshot of block data and their stable IDs, used by undo/redo.
class _EditorSnapshot {
  final List<BlockEntity> blocks;
  final List<String> ids;
  _EditorSnapshot({required this.blocks, required this.ids});
}

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
  final List<String> _blockIds;
  final SerializeDocument _serializer;
  int _idCounter = 0;

  // --- Undo / redo history ---
  final List<_EditorSnapshot> _history = [];
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
        _blockIds = [],
        _serializer = serializer {
    // Assign initial IDs
    for (var i = 0; i < _blocks.length; i++) {
      _blockIds.add(_nextId());
    }
    _saveSnapshot(); // record the initial state as snapshot 0
  }

  /// Generates a short ID that is unique within this controller's lifetime.
  ///
  /// IDs are intentionally scoped to a single [EditorController] instance —
  /// they are used only as Flutter [ValueKey]s within the same widget subtree
  /// and do not need to be globally unique or persistent across sessions.
  String _nextId() => 'b${_idCounter++}';

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  /// Whether there is a previous state to restore.
  bool get canUndo => _historyIndex > 0;

  /// Whether there is a forward state to restore after an undo.
  bool get canRedo => _historyIndex < _history.length - 1;

  /// Saves the current block list and IDs as a history snapshot.
  ///
  /// Any snapshots ahead of [_historyIndex] (from a prior undo) are discarded.
  /// The block list is stored as an unmodifiable copy so that mutable
  /// collections inside block entities (e.g. ListBlock.items) cannot
  /// retroactively corrupt an older snapshot.
  void _saveSnapshot() {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(_EditorSnapshot(
      blocks: List<BlockEntity>.unmodifiable(_blocks),
      ids: List<String>.unmodifiable(_blockIds),
    ));
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
    _historyIndex = _history.length - 1;
  }

  /// Restores the previous snapshot, if any.
  void undo() {
    if (!canUndo) return;
    _historyIndex--;
    final snapshot = _history[_historyIndex];
    _blocks
      ..clear()
      ..addAll(snapshot.blocks);
    _blockIds
      ..clear()
      ..addAll(snapshot.ids);
    notifyListeners();
  }

  /// Restores the next snapshot after an undo, if any.
  void redo() {
    if (!canRedo) return;
    _historyIndex++;
    final snapshot = _history[_historyIndex];
    _blocks
      ..clear()
      ..addAll(snapshot.blocks);
    _blockIds
      ..clear()
      ..addAll(snapshot.ids);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Block mutations
  // ---------------------------------------------------------------------------

  /// Unmodifiable view of the current block list.
  List<BlockEntity> get blocks => List.unmodifiable(_blocks);

  /// Unmodifiable view of stable per-block IDs, parallel to [blocks].
  ///
  /// These IDs are stable across [updateBlock] calls and are preserved by
  /// [undo]/[redo], making them suitable as Flutter widget keys to ensure
  /// State objects follow the correct block when the list is reordered.
  List<String> get blockIds => List.unmodifiable(_blockIds);

  int get blockCount => _blocks.length;

  void addBlock(BlockEntity block) {
    _blocks.add(block);
    _blockIds.add(_nextId());
    _saveSnapshot();
    notifyListeners();
  }

  void insertBlock(int index, BlockEntity block) {
    _blocks.insert(index, block);
    _blockIds.insert(index, _nextId());
    _saveSnapshot();
    notifyListeners();
  }

  /// Replaces the block at [index] in place.
  ///
  /// Does NOT create a history snapshot — use this for live text updates.
  /// Structural changes (add, remove, move) are the undo boundaries.
  /// The block's stable ID is preserved so that widget State objects bound
  /// via [blockIds] are not recreated on every keystroke.
  void updateBlock(int index, BlockEntity updated) {
    assert(index >= 0 && index < _blocks.length);
    _blocks[index] = updated;
    notifyListeners();
  }

  void removeBlock(int index) {
    assert(index >= 0 && index < _blocks.length);
    _blocks.removeAt(index);
    _blockIds.removeAt(index);
    _saveSnapshot();
    notifyListeners();
  }

  void moveBlock(int fromIndex, int toIndex) {
    assert(fromIndex >= 0 && fromIndex < _blocks.length);
    assert(toIndex >= 0 && toIndex < _blocks.length);
    final block = _blocks.removeAt(fromIndex);
    _blocks.insert(toIndex, block);
    final id = _blockIds.removeAt(fromIndex);
    _blockIds.insert(toIndex, id);
    _saveSnapshot();
    notifyListeners();
  }

  void clear() {
    _blocks.clear();
    _blockIds.clear();
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
