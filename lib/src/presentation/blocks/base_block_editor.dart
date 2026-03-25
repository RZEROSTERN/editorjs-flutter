import 'package:flutter/widgets.dart';

import '../../domain/entities/block_entity.dart';

/// Base class for all block editor widgets.
///
/// Subclass this for each block type. Editors receive an immutable [BlockEntity]
/// and push updates upward via [onChanged] — they never mutate state directly.
abstract class BlockEditor<T extends BlockEntity> extends StatefulWidget {
  final T block;

  /// Called whenever the user changes the block's content.
  /// Pass the updated entity — the [EditorController] handles persistence.
  final ValueChanged<T> onChanged;

  const BlockEditor({
    super.key,
    required this.block,
    required this.onChanged,
  });
}
