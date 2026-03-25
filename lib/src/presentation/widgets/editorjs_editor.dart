import 'package:flutter/material.dart';

import '../config/editor_config.dart';
import '../controller/editor_controller.dart';
import 'editorjs_toolbar.dart';

/// Interactive editor for EditorJS content.
///
/// Requires an [EditorController] which holds the document state and exposes
/// [EditorController.getContent] to export the result as EditorJS JSON.
///
/// Example:
/// ```dart
/// final controller = EditorController(serializer: serializeDocument);
///
/// EditorJSEditor(controller: controller)
///
/// // On save:
/// final json = controller.getContent();
/// ```
class EditorJSEditor extends StatefulWidget {
  final EditorController controller;
  final EditorConfig config;

  EditorJSEditor({
    super.key,
    required this.controller,
    EditorConfig? config,
  }) : config = config ?? EditorConfig();

  @override
  State<EditorJSEditor> createState() => _EditorJSEditorState();
}

class _EditorJSEditorState extends State<EditorJSEditor> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(EditorJSEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  void _onControllerChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blocks = widget.controller.blocks;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              final block = blocks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: widget.config.rendererRegistry.buildEditor(
                      block,
                      (updated) =>
                          widget.controller.updateBlock(index, updated),
                    ) ??
                    _UnknownBlockWidget(type: block.type),
              );
            },
          ),
        ),
        EditorJSToolbar(
          controller: widget.controller,
          rendererRegistry: widget.config.rendererRegistry,
        ),
      ],
    );
  }
}

class _UnknownBlockWidget extends StatelessWidget {
  final String type;

  const _UnknownBlockWidget({required this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '[Unsupported block: $type]',
        style: TextStyle(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
          fontSize: 12,
        ),
      ),
    );
  }
}
