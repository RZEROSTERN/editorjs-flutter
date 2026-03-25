import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/editorjs_flutter.dart';

void main() {
  const sampleJson = '''
  {
    "time": 1000,
    "version": "2.19.0",
    "blocks": [
      {"id": "1", "type": "header", "data": {"text": "Hello World", "level": 1}},
      {"id": "2", "type": "paragraph", "data": {"text": "A paragraph."}},
      {"id": "3", "type": "delimiter", "data": {}},
      {"id": "4", "type": "code", "data": {"code": "print('hi')"}},
      {"id": "5", "type": "warning", "data": {"title": "Note", "message": "Be careful"}}
    ]
  }
  ''';

  testWidgets('EditorJSView renders known blocks without throwing',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSView(jsonData: sampleJson),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hello World'), findsOneWidget);
    expect(find.text("print('hi')"), findsOneWidget);
  });

  testWidgets('EditorJSView handles invalid JSON without throwing',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSView(jsonData: 'not json'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Should render empty content, not crash
    expect(find.byType(EditorJSView), findsOneWidget);
  });

  testWidgets('EditorJSView drops unknown block types silently', (tester) async {
    const json = '{"blocks":[{"type":"unknown_xyz","data":{}}]}';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSView(jsonData: json),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EditorJSView), findsOneWidget);
  });

  testWidgets('EditorJSView renders warning block', (tester) async {
    const json = '''
    {
      "blocks": [
        {"type": "warning", "data": {"title": "Note", "message": "Be careful"}}
      ]
    }
    ''';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: EditorJSView(jsonData: json)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Note'), findsOneWidget);
    expect(find.text('Be careful'), findsOneWidget);
  });

  testWidgets('EditorJSView renders checklist block', (tester) async {
    const json = '''
    {
      "blocks": [
        {"type": "checklist", "data": {
          "items": [
            {"text": "Task one", "checked": false},
            {"text": "Task two", "checked": true}
          ]
        }}
      ]
    }
    ''';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: EditorJSView(jsonData: json)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Task one'), findsOneWidget);
  });

  testWidgets('EditorJSView renders table block', (tester) async {
    const json = '''
    {
      "blocks": [
        {"type": "table", "data": {
          "withHeadings": true,
          "content": [["Name", "Value"], ["Foo", "Bar"]]
        }}
      ]
    }
    ''';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: EditorJSView(jsonData: json)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Foo'), findsOneWidget);
  });

  testWidgets('EditorJSView renders quote block', (tester) async {
    const json = '''
    {
      "blocks": [
        {"type": "quote", "data": {
          "text": "A great quote",
          "caption": "Famous Person",
          "alignment": "left"
        }}
      ]
    }
    ''';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: EditorJSView(jsonData: json)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Famous Person'), findsOneWidget);
  });

  testWidgets('EditorJSView renders embed block', (tester) async {
    const json = '''
    {
      "blocks": [
        {"type": "embed", "data": {
          "service": "youtube",
          "source": "https://youtube.com/watch?v=test",
          "embed": "https://www.youtube.com/embed/test"
        }}
      ]
    }
    ''';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: EditorJSView(jsonData: json)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Youtube'), findsOneWidget);
  });

  testWidgets('EditorJSView renders attaches block', (tester) async {
    const json = '''
    {
      "blocks": [
        {"type": "attaches", "data": {
          "file": {"url": "https://example.com/doc.pdf", "name": "doc.pdf"},
          "title": "My Document"
        }}
      ]
    }
    ''';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: EditorJSView(jsonData: json)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('My Document'), findsOneWidget);
  });

  testWidgets('EditorJSView renders list block', (tester) async {
    const json = '''
    {
      "blocks": [
        {"type": "list", "data": {
          "style": "unordered",
          "items": [
            {"content": "Item one", "items": []},
            {"content": "Item two", "items": []}
          ]
        }}
      ]
    }
    ''';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: EditorJSView(jsonData: json)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EditorJSView), findsOneWidget);
  });
}
