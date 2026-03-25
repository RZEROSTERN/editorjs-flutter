import 'dart:convert';

import 'package:editorjs_flutter/editorjs_flutter.dart';
import 'package:flutter/material.dart';

import 'createnote.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EditorJS Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EditorJS Flutter Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _jsonData;
  EditorConfig? _config;

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('test_data/editorjsdatatest.json');
    final stylesJson = await DefaultAssetBundle.of(context)
        .loadString('test_data/editorjsstyles.json');

    final stylesMap = jsonDecode(stylesJson) as Map<String, dynamic>;
    final rawTags = stylesMap['cssTags'] as List<dynamic>? ?? [];

    final styleConfig = StyleConfig(
      defaultFont: stylesMap['defaultFont'] as String?,
      cssTags: rawTags
          .whereType<Map<String, dynamic>>()
          .map((t) => CssTagConfig(
                tag: t['tag'] as String,
                backgroundColor: t['backgroundColor'] as String?,
                color: t['color'] as String?,
                padding: (t['padding'] as num?)?.toDouble(),
              ))
          .toList(),
    );

    setState(() {
      _jsonData = data;
      _config = EditorConfig(styleConfig: styleConfig);
    });
  }

  void _showEditor() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const CreateNoteLayout(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _jsonData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(15),
              children: [
                EditorJSView(jsonData: _jsonData!, config: _config),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEditor,
        tooltip: 'Create content',
        child: const Icon(Icons.add),
      ),
    );
  }
}
