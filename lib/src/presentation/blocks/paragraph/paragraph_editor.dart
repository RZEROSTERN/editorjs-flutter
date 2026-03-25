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

  @override
  void initState() {
    super.initState();
    // Strip basic HTML tags for plain-text editing; viewer renders HTML.
    _textController = TextEditingController(text: _stripHtml(widget.block.html));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    widget.onChanged(ParagraphBlock(html: value));
  }

  String _stripHtml(String html) =>
      html.replaceAll(RegExp(r'<[^>]*>'), '');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: _textController,
        onChanged: _onTextChanged,
        decoration: const InputDecoration(
          hintText: 'Write something...',
          border: InputBorder.none,
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
