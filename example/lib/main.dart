import 'package:flutter/material.dart';
import 'package:editorjs_flutter/editorjs_flutter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EditorJS Flutter Example',
      home: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int _selectedIndex = 0;

  static const _sampleJson = '''
  {
    "time": 1000,
    "version": "2.19.0",
    "blocks": [
      {
        "id": "1",
        "type": "header",
        "data": {"text": "Welcome to EditorJS Flutter", "level": 1}
      },
      {
        "id": "2",
        "type": "paragraph",
        "data": {"text": "This is a <b>viewer</b> tab showing <i>EditorJS</i> content rendered as Flutter widgets."}
      },
      {
        "id": "3",
        "type": "delimiter",
        "data": {}
      },
      {
        "id": "4",
        "type": "quote",
        "data": {"text": "Build beautiful editors with Flutter.", "caption": "EditorJS Flutter", "alignment": "left"}
      },
      {
        "id": "5",
        "type": "code",
        "data": {"code": "final controller = EditorController();\\nfinal json = controller.getContent();"}
      }
    ]
  }
  ''';

  late final EditorController _editorController;

  @override
  void initState() {
    super.initState();
    _editorController = EditorController(
      initialBlocks: const [
        HeaderBlock(text: 'My Document', level: 2),
        ParagraphBlock(html: 'Start editing here...'),
      ],
    );
  }

  @override
  void dispose() {
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditorJS Flutter Example'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            children: [
              _TabButton(
                label: 'Viewer',
                selected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _TabButton(
                label: 'Editor',
                selected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: EditorJSView(jsonData: _sampleJson),
            )
          : EditorJSEditor(controller: _editorController),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                final json = _editorController.getContent();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      json,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    duration: const Duration(seconds: 4),
                  ),
                );
              },
              child: const Icon(Icons.save),
            )
          : null,
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
