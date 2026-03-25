import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/list_block.dart';
import '../base_block_editor.dart';

class ListEditor extends BlockEditor<ListBlock> {
  const ListEditor({
    super.key,
    required super.block,
    required super.onChanged,
  });

  @override
  State<ListEditor> createState() => _ListEditorState();
}

class _ListEditorState extends State<ListEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.block.items
        .map((item) => TextEditingController(text: item))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(ListBlock(
      style: widget.block.style,
      items: _controllers.map((c) => c.text).toList(),
    ));
  }

  void _addItem() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    _notifyChanged();
  }

  void _removeItem(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _controllers.length; i++)
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  widget.block.style == ListStyle.ordered
                      ? '${i + 1}.'
                      : '\u2022',
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controllers[i],
                  onChanged: (_) => _notifyChanged(),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 18),
                onPressed: _controllers.length > 1 ? () => _removeItem(i) : null,
              ),
            ],
          ),
        TextButton.icon(
          onPressed: _addItem,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add item'),
        ),
      ],
    );
  }
}
