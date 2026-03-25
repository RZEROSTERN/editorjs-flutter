import 'package:flutter/material.dart';

import '../../domain/entities/blocks/delimiter_block.dart';
import '../../domain/entities/blocks/header_block.dart';
import '../../domain/entities/blocks/image_block.dart';
import '../../domain/entities/blocks/list_block.dart';
import '../../domain/entities/blocks/paragraph_block.dart';
import '../controller/editor_controller.dart';
import '../registry/block_renderer_registry.dart';

/// Toolbar for [EditorJSEditor].
///
/// Communicates exclusively via [EditorController] — holds no reference to
/// any parent widget. Each action appends a new [BlockEntity] to the controller.
class EditorJSToolbar extends StatelessWidget {
  final EditorController controller;
  final BlockRendererRegistry rendererRegistry;

  const EditorJSToolbar({
    super.key,
    required this.controller,
    required this.rendererRegistry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ToolbarButton(
                label: 'T',
                tooltip: 'Paragraph',
                onTap: () => controller.addBlock(const ParagraphBlock(html: '')),
              ),
              for (int level = 1; level <= 6; level++)
                _ToolbarButton(
                  label: 'H$level',
                  tooltip: 'Heading $level',
                  onTap: () =>
                      controller.addBlock(HeaderBlock(text: '', level: level)),
                ),
              _ToolbarButton(
                icon: Icons.format_list_bulleted,
                tooltip: 'Unordered list',
                onTap: () => controller.addBlock(
                  const ListBlock(style: ListStyle.unordered, items: ['']),
                ),
              ),
              _ToolbarButton(
                icon: Icons.format_list_numbered,
                tooltip: 'Ordered list',
                onTap: () => controller.addBlock(
                  const ListBlock(style: ListStyle.ordered, items: ['']),
                ),
              ),
              _ToolbarButton(
                icon: Icons.horizontal_rule,
                tooltip: 'Delimiter',
                onTap: () => controller.addBlock(const DelimiterBlock()),
              ),
              _ToolbarButton(
                icon: Icons.image_outlined,
                tooltip: 'Image',
                onTap: () => controller.addBlock(const ImageBlock(url: '')),
              ),
              _ToolbarButton(
                icon: Icons.link,
                tooltip: 'Hyperlink',
                onTap: () => _showHyperlinkDialog(context),
              ),
              _ToolbarButton(
                icon: Icons.delete_outline,
                tooltip: 'Remove last block',
                onTap: controller.blockCount > 0
                    ? () => controller.removeBlock(controller.blockCount - 1)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHyperlinkDialog(BuildContext context) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add hyperlink'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Link title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(hintText: 'https://...'),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final url = urlController.text.trim();
              final title = titleController.text.trim();
              if (url.isNotEmpty) {
                // Insert as a paragraph with an anchor tag.
                controller.addBlock(ParagraphBlock(
                  html: '<a href="$url">${title.isNotEmpty ? title : url}</a>',
                ));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String tooltip;
  final VoidCallback? onTap;

  const _ToolbarButton({
    this.label,
    this.icon,
    required this.tooltip,
    required this.onTap,
  }) : assert(label != null || icon != null);

  @override
  Widget build(BuildContext context) {
    final child = icon != null
        ? Icon(icon, size: 20, color: Colors.black54)
        : Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          );

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: child,
        ),
      ),
    );
  }
}
