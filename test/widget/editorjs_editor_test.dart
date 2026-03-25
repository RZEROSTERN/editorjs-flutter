import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/editorjs_flutter.dart';

void main() {
  testWidgets('EditorJSEditor renders empty editor without throwing',
      (tester) async {
    final controller = EditorController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EditorJSEditor), findsOneWidget);
  });

  testWidgets('EditorJSEditor renders blocks from controller', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        HeaderBlock(text: 'My Title', level: 1),
        ParagraphBlock(html: 'Some text'),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('My Title'), findsOneWidget);
  });

  testWidgets('EditorController.fromJson pre-populates blocks', (tester) async {
    const json =
        '{"blocks":[{"type":"header","data":{"text":"From JSON","level":2}}]}';
    final controller = EditorController.fromJson(json);
    expect(controller.blockCount, 1);
    expect(controller.blocks.first, isA<HeaderBlock>());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('From JSON'), findsOneWidget);
  });

  testWidgets('move up / move down controls are present', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        HeaderBlock(text: 'Block 1', level: 1),
        HeaderBlock(text: 'Block 2', level: 1),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Move-down icon should appear (first block can go down)
    expect(find.byIcon(Icons.arrow_downward), findsWidgets);
  });

  testWidgets('EditorJSEditor renders checklist block', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        ChecklistBlock(
          items: [
            ChecklistItem(text: 'Check me', checked: false),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Check me'), findsOneWidget);
  });

  testWidgets('EditorJSEditor renders code block', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        CodeBlock(code: 'void main() {}'),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('void main() {}'), findsOneWidget);
  });

  testWidgets('EditorJSEditor renders warning block', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        WarningBlock(title: 'Alert', message: 'Watch out'),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Alert'), findsOneWidget);
    expect(find.text('Watch out'), findsOneWidget);
  });

  testWidgets('EditorJSEditor renders quote block', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        QuoteBlock(text: 'A famous quote', alignment: QuoteAlignment.left),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EditorJSEditor), findsOneWidget);
  });

  testWidgets('EditorJSEditor renders table block', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        TableBlock(
          content: [
            ['Col1', 'Col2'],
            ['Val1', 'Val2'],
          ],
          withHeadings: true,
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Col1'), findsOneWidget);
  });

  testWidgets('EditorJSEditor renders list block', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        ListBlock(
          style: ListStyle.unordered,
          items: [
            ListItem(content: 'List item'),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(EditorJSEditor), findsOneWidget);
  });

  testWidgets('EditorJSEditor renders delimiter block', (tester) async {
    final controller = EditorController(
      initialBlocks: const [
        DelimiterBlock(),
      ],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditorJSEditor(controller: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Divider), findsOneWidget);
  });
}
