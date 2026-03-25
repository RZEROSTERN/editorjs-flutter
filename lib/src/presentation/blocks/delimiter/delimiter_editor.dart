import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/delimiter_block.dart';
import '../base_block_editor.dart';

class DelimiterEditor extends BlockEditor<DelimiterBlock> {
  const DelimiterEditor({
    super.key,
    required super.block,
    required super.onChanged,
  });

  @override
  State<DelimiterEditor> createState() => _DelimiterEditorState();
}

class _DelimiterEditorState extends State<DelimiterEditor> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: Colors.grey),
    );
  }
}
