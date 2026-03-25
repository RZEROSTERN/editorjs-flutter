import 'package:flutter/widgets.dart';

import '../../domain/entities/block_entity.dart';
import '../../domain/entities/style_config.dart';

/// Base class for all block renderer widgets.
///
/// Subclass this for each block type. Renderers are stateless — they receive
/// an immutable [BlockEntity] and produce a widget subtree.
abstract class BlockRenderer<T extends BlockEntity> extends StatelessWidget {
  final T block;
  final StyleConfig? styleConfig;

  const BlockRenderer({
    super.key,
    required this.block,
    this.styleConfig,
  });
}
