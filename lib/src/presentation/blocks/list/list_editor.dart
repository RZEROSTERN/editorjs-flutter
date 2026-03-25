import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/list_block.dart';
import '../base_block_editor.dart';

class ListEditor extends BlockEditor<ListBlock> {
  const ListEditor({super.key, required super.block, required super.onChanged});

  @override
  State<ListEditor> createState() => _ListEditorState();
}

class _ListEditorState extends State<ListEditor> {
  late List<TextEditingController> _controllers;
  late List<ListItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.block.items);
    _controllers =
        _items.map((i) => TextEditingController(text: i.content)).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ListEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.block != widget.block) {
      final newItems = widget.block.items;
      setState(() {
        final updated = <TextEditingController>[];
        for (var i = 0; i < newItems.length; i++) {
          if (i < _controllers.length) {
            // Only update text when the content actually differs to avoid
            // resetting the cursor during normal typing round-trips.
            if (_controllers[i].text != newItems[i].content) {
              _controllers[i].text = newItems[i].content;
            }
            updated.add(_controllers[i]);
          } else {
            updated.add(TextEditingController(text: newItems[i].content));
          }
        }
        // Dispose extra controllers only after building the updated list so
        // that an unexpected error cannot leave _controllers in a partial state.
        for (var i = newItems.length; i < _controllers.length; i++) {
          _controllers[i].dispose();
        }
        _controllers = updated;
        _items = List.from(newItems);
      });
    }
  }

  void _notify() {
    widget.onChanged(ListBlock(
      style: widget.block.style,
      items: List.unmodifiable(_items),
    ));
  }

  void _addItem() {
    setState(() {
      _items.add(const ListItem(content: ''));
      _controllers.add(TextEditingController());
    });
    _notify();
  }

  void _removeItem(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
      _items.removeAt(index);
    });
    _notify();
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
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controllers[i],
                  onChanged: (v) {
                    _items[i] = _items[i].copyWith(content: v);
                    _notify();
                  },
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
