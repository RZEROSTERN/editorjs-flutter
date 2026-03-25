import 'package:flutter/widgets.dart';

import '../../domain/entities/block_entity.dart';
import '../../domain/entities/blocks/delimiter_block.dart';
import '../../domain/entities/blocks/header_block.dart';
import '../../domain/entities/blocks/image_block.dart';
import '../../domain/entities/blocks/list_block.dart';
import '../../domain/entities/blocks/paragraph_block.dart';
import '../../domain/entities/style_config.dart';
import '../blocks/delimiter/delimiter_editor.dart';
import '../blocks/delimiter/delimiter_renderer.dart';
import '../blocks/header/header_editor.dart';
import '../blocks/header/header_renderer.dart';
import '../blocks/image/image_editor.dart';
import '../blocks/image/image_renderer.dart';
import '../blocks/list/list_editor.dart';
import '../blocks/list/list_renderer.dart';
import '../blocks/paragraph/paragraph_editor.dart';
import '../blocks/paragraph/paragraph_renderer.dart';

typedef BlockRendererBuilder = Widget Function(
  BlockEntity block,
  StyleConfig? styleConfig,
);

typedef BlockEditorBuilder = Widget Function(
  BlockEntity block,
  ValueChanged<BlockEntity> onChanged,
);

/// Maps EditorJS block type strings to their renderer and editor widget builders.
///
/// Built-in block types are pre-registered. Call [registerRenderer] and
/// [registerEditor] to add custom blocks without modifying core package files.
class BlockRendererRegistry {
  final Map<String, BlockRendererBuilder> _renderers = {};
  final Map<String, BlockEditorBuilder> _editors = {};

  BlockRendererRegistry() {
    registerRenderer(
      'header',
      (b, s) => HeaderRenderer(block: b as HeaderBlock, styleConfig: s),
    );
    registerRenderer(
      'paragraph',
      (b, s) => ParagraphRenderer(block: b as ParagraphBlock, styleConfig: s),
    );
    registerRenderer(
      'list',
      (b, s) => ListRenderer(block: b as ListBlock, styleConfig: s),
    );
    registerRenderer(
      'delimiter',
      (b, s) => DelimiterRenderer(block: b as DelimiterBlock, styleConfig: s),
    );
    registerRenderer(
      'image',
      (b, s) => ImageRenderer(block: b as ImageBlock, styleConfig: s),
    );

    registerEditor(
      'header',
      (b, cb) => HeaderEditor(
        block: b as HeaderBlock,
        onChanged: (updated) => cb(updated),
      ),
    );
    registerEditor(
      'paragraph',
      (b, cb) => ParagraphEditor(
        block: b as ParagraphBlock,
        onChanged: (updated) => cb(updated),
      ),
    );
    registerEditor(
      'list',
      (b, cb) => ListEditor(
        block: b as ListBlock,
        onChanged: (updated) => cb(updated),
      ),
    );
    registerEditor(
      'delimiter',
      (b, cb) => DelimiterEditor(
        block: b as DelimiterBlock,
        onChanged: (updated) => cb(updated),
      ),
    );
    registerEditor(
      'image',
      (b, cb) => ImageEditor(
        block: b as ImageBlock,
        onChanged: (updated) => cb(updated),
      ),
    );
  }

  void registerRenderer(String type, BlockRendererBuilder builder) {
    _renderers[type] = builder;
  }

  void registerEditor(String type, BlockEditorBuilder builder) {
    _editors[type] = builder;
  }

  /// Returns the renderer widget, or `null` for unregistered types.
  Widget? buildRenderer(BlockEntity block, StyleConfig? styleConfig) {
    return _renderers[block.type]?.call(block, styleConfig);
  }

  /// Returns the editor widget, or `null` for unregistered types.
  Widget? buildEditor(BlockEntity block, ValueChanged<BlockEntity> onChanged) {
    return _editors[block.type]?.call(block, onChanged);
  }

  bool supportsRendering(String type) => _renderers.containsKey(type);
  bool supportsEditing(String type) => _editors.containsKey(type);
}
