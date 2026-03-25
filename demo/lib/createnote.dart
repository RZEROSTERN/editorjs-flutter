import 'package:editorjs_flutter/editorjs_flutter.dart';
import 'package:flutter/material.dart';

class CreateNoteLayout extends StatefulWidget {
  const CreateNoteLayout({super.key});

  @override
  CreateNoteLayoutState createState() => CreateNoteLayoutState();
}

class CreateNoteLayoutState extends State<CreateNoteLayout> {
  late final EditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EditorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final json = _controller.getContent();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('EditorJS JSON output'),
        content: SingleChildScrollView(child: SelectableText(json)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Note'),
        actions: [
          IconButton(
            onPressed: _onSave,
            icon: const Icon(Icons.save_outlined),
            tooltip: 'Export JSON',
          ),
        ],
      ),
      body: EditorJSEditor(controller: _controller),
    );
  }
}
