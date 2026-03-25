import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/paragraph_block.dart';
import '../base_block_editor.dart';

class ParagraphEditor extends BlockEditor<ParagraphBlock> {
  const ParagraphEditor({
    super.key,
    required super.block,
    required super.onChanged,
  });

  @override
  State<ParagraphEditor> createState() => _ParagraphEditorState();
}

class _ParagraphEditorState extends State<ParagraphEditor> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  bool _showFormatBar = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.block.html);
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _showFormatBar = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    widget.onChanged(ParagraphBlock(html: value));
  }

  void _applyFormat(String openTag, String closeTag) {
    final sel = _textController.selection;
    if (!sel.isValid) return;
    final text = _textController.text;
    final String newText;
    final int newCursor;

    if (sel.isCollapsed) {
      // No selection — insert tags with cursor between them
      newText = text.replaceRange(sel.start, sel.end, '$openTag$closeTag');
      newCursor = sel.start + openTag.length;
    } else {
      final selected = text.substring(sel.start, sel.end);
      newText = text.replaceRange(sel.start, sel.end, '$openTag$selected$closeTag');
      newCursor = sel.start + openTag.length + selected.length + closeTag.length;
    }

    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
    );
    _onTextChanged(newText);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showFormatBar)
            _InlineFormatBar(onFormat: _applyFormat),
          TextField(
            controller: _textController,
            focusNode: _focusNode,
            onChanged: _onTextChanged,
            decoration: const InputDecoration(
              hintText: 'Write something...',
              border: InputBorder.none,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }
}

class _InlineFormatBar extends StatelessWidget {
  final void Function(String openTag, String closeTag) onFormat;

  const _InlineFormatBar({required this.onFormat});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FormatButton(
            label: 'B',
            bold: true,
            tooltip: 'Bold',
            onTap: () => onFormat('<b>', '</b>'),
          ),
          _FormatButton(
            label: 'I',
            italic: true,
            tooltip: 'Italic',
            onTap: () => onFormat('<i>', '</i>'),
          ),
          _FormatButton(
            label: 'U',
            underline: true,
            tooltip: 'Underline',
            onTap: () => onFormat('<u>', '</u>'),
          ),
          _FormatButton(
            label: 'S',
            strikethrough: true,
            tooltip: 'Strikethrough',
            onTap: () => onFormat('<s>', '</s>'),
          ),
          _FormatButton(
            label: '</>',
            monospace: true,
            tooltip: 'Inline code',
            onTap: () => onFormat('<code>', '</code>'),
          ),
          _FormatButton(
            label: 'mark',
            highlight: true,
            tooltip: 'Highlight',
            onTap: () => onFormat('<mark>', '</mark>'),
          ),
        ],
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String label;
  final String tooltip;
  final VoidCallback onTap;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strikethrough;
  final bool monospace;
  final bool highlight;

  const _FormatButton({
    required this.label,
    required this.tooltip,
    required this.onTap,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strikethrough = false,
    this.monospace = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(right: 2),
          decoration: highlight
              ? BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              decoration: underline
                  ? TextDecoration.underline
                  : strikethrough
                      ? TextDecoration.lineThrough
                      : null,
              fontFamily: monospace ? 'monospace' : null,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
