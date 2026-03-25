import '../../data/registry/block_type_registry.dart';
import '../../domain/entities/style_config.dart';
import '../registry/block_renderer_registry.dart';

/// Configuration object shared by [EditorJSView] and [EditorJSEditor].
///
/// Provides optional customization of block registries and styling.
/// Defaults cover all built-in block types out of the box.
class EditorConfig {
  final BlockTypeRegistry typeRegistry;
  final BlockRendererRegistry rendererRegistry;
  final StyleConfig? styleConfig;

  EditorConfig({
    BlockTypeRegistry? typeRegistry,
    BlockRendererRegistry? rendererRegistry,
    this.styleConfig,
  })  : typeRegistry = typeRegistry ?? BlockTypeRegistry(),
        rendererRegistry = rendererRegistry ?? BlockRendererRegistry();
}
