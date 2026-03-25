import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/header_block.dart';
import '../base_block_editor.dart';

class HeaderEditor extends BlockEditor<HeaderBlock> {
  const HeaderEditor({
    super.key,
    required super.block,
    required super.onChanged,
  });

  @override
  State<HeaderEditor> createState() => _HeaderEditorState();
}

class _HeaderEditorState extends State<HeaderEditor> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.block.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    widget.onChanged(HeaderBlock(text: value, level: widget.block.level));
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = switch (widget.block.level) {
      1 => 32.0,
      2 => 24.0,
      3 => 20.0,
      4 => 16.0,
      5 => 14.0,
      _ => 12.0,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: _textController,
        onChanged: _onTextChanged,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: widget.block.level <= 3 ? FontWeight.bold : FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Heading ${widget.block.level}',
          border: InputBorder.none,
        ),
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
