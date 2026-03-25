import 'package:flutter/material.dart';

import '../../data/datasources/json_document_source.dart';
import '../../domain/usecases/parse_document.dart';
import '../config/editor_config.dart';

/// Read-only viewer for EditorJS JSON content.
///
/// Parses [jsonData] and renders each block using the registered renderers.
/// Unknown block types are silently skipped.
///
/// Example:
/// ```dart
/// EditorJSView(jsonData: myJsonString)
/// ```
class EditorJSView extends StatelessWidget {
  final String jsonData;
  final EditorConfig config;

  EditorJSView({
    super.key,
    required this.jsonData,
    EditorConfig? config,
  }) : config = config ?? EditorConfig();

  @override
  Widget build(BuildContext context) {
    final source = JsonDocumentSource(registry: this.config.typeRegistry);
    final document = ParseDocument(source)(jsonData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final block in document.blocks) ...[
          this.config.rendererRegistry.buildRenderer(
                block,
                this.config.styleConfig,
              ) ??
              const SizedBox.shrink(),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
