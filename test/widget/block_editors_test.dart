import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/editorjs_flutter.dart';
import 'package:editorjs_flutter/src/presentation/blocks/paragraph/paragraph_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/list/list_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/checklist/checklist_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/table/table_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/image/image_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/header/header_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/quote/quote_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/warning/warning_editor.dart';
import 'package:editorjs_flutter/src/presentation/blocks/code/code_editor.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: SizedBox(width: 400, child: child),
      ),
    );

void main() {
  // ---------------------------------------------------------------------------
  // ParagraphEditor
  // ---------------------------------------------------------------------------
  group('ParagraphEditor', () {
    testWidgets('renders without throwing', (tester) async {
      const block = ParagraphBlock(html: 'Hello');
      await tester.pumpWidget(_wrap(
        ParagraphEditor(
          block: block,
          onChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ParagraphEditor), findsOneWidget);
    });

    testWidgets('shows existing text in text field', (tester) async {
      const block = ParagraphBlock(html: 'My paragraph text');
      await tester.pumpWidget(_wrap(
        ParagraphEditor(
          block: block,
          onChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('My paragraph text'), findsOneWidget);
    });

    testWidgets('typing in field calls onChanged', (tester) async {
      ParagraphBlock? updatedBlock;
      const block = ParagraphBlock(html: '');
      await tester.pumpWidget(_wrap(
        ParagraphEditor(
          block: block,
          onChanged: (b) => updatedBlock = b,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'New text');
      await tester.pumpAndSettle();
      expect(updatedBlock?.html, 'New text');
    });

    testWidgets('format bar appears when field is focused', (tester) async {
      const block = ParagraphBlock(html: 'Some text');
      await tester.pumpWidget(_wrap(
        ParagraphEditor(
          block: block,
          onChanged: (_) {},
        ),
      ));
      await tester.pumpAndSettle();

      // Tap the text field to focus it
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      // Format bar buttons should appear
      expect(find.text('B'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ListEditor
  // ---------------------------------------------------------------------------
  group('ListEditor', () {
    testWidgets('renders unordered list without throwing', (tester) async {
      const block = ListBlock(
        style: ListStyle.unordered,
        items: [
          ListItem(content: 'Item 1'),
          ListItem(content: 'Item 2'),
        ],
      );
      await tester.pumpWidget(_wrap(
        ListEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('renders ordered list without throwing', (tester) async {
      const block = ListBlock(
        style: ListStyle.ordered,
        items: [
          ListItem(content: 'First'),
        ],
      );
      await tester.pumpWidget(_wrap(
        ListEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.text('First'), findsOneWidget);
    });

    testWidgets('Add item button adds a new item', (tester) async {
      ListBlock? updatedBlock;
      const block = ListBlock(
        style: ListStyle.unordered,
        items: [ListItem(content: 'Item 1')],
      );
      await tester.pumpWidget(_wrap(
        ListEditor(
          block: block,
          onChanged: (b) => updatedBlock = b,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add item'));
      await tester.pumpAndSettle();
      expect(updatedBlock?.items.length, 2);
    });
  });

  // ---------------------------------------------------------------------------
  // ChecklistEditor
  // ---------------------------------------------------------------------------
  group('ChecklistEditor', () {
    testWidgets('renders without throwing', (tester) async {
      const block = ChecklistBlock(
        items: [
          ChecklistItem(text: 'Task one', checked: false),
          ChecklistItem(text: 'Task two', checked: true),
        ],
      );
      await tester.pumpWidget(_wrap(
        ChecklistEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Task one'), findsOneWidget);
    });

    testWidgets('toggling checkbox calls onChanged', (tester) async {
      ChecklistBlock? updatedBlock;
      const block = ChecklistBlock(
        items: [ChecklistItem(text: 'Do something', checked: false)],
      );
      await tester.pumpWidget(_wrap(
        ChecklistEditor(
          block: block,
          onChanged: (b) => updatedBlock = b,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(updatedBlock?.items.first.checked, true);
    });

    testWidgets('Add item button works', (tester) async {
      ChecklistBlock? updatedBlock;
      const block = ChecklistBlock(
        items: [ChecklistItem(text: 'First', checked: false)],
      );
      await tester.pumpWidget(_wrap(
        ChecklistEditor(
          block: block,
          onChanged: (b) => updatedBlock = b,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add item'));
      await tester.pumpAndSettle();
      expect(updatedBlock?.items.length, 2);
    });
  });

  // ---------------------------------------------------------------------------
  // TableEditor
  // ---------------------------------------------------------------------------
  group('TableEditor', () {
    testWidgets('renders without throwing', (tester) async {
      const block = TableBlock(
        content: [
          ['A', 'B'],
          ['C', 'D'],
        ],
      );
      await tester.pumpWidget(_wrap(
        TableEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TableEditor), findsOneWidget);
    });

    testWidgets('Add Row button adds a row', (tester) async {
      TableBlock? updatedBlock;
      const block = TableBlock(
        content: [
          ['A', 'B'],
        ],
      );
      await tester.pumpWidget(_wrap(
        TableEditor(
          block: block,
          onChanged: (b) => updatedBlock = b,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Row'));
      await tester.pumpAndSettle();
      expect(updatedBlock?.content.length, 2);
    });

    testWidgets('Add Column button adds a column', (tester) async {
      TableBlock? updatedBlock;
      const block = TableBlock(
        content: [
          ['A'],
        ],
      );
      await tester.pumpWidget(_wrap(
        TableEditor(
          block: block,
          onChanged: (b) => updatedBlock = b,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Column'));
      await tester.pumpAndSettle();
      expect(updatedBlock?.content.first.length, 2);
    });

    testWidgets('withHeadings checkbox toggles', (tester) async {
      TableBlock? updatedBlock;
      const block = TableBlock(
        content: [
          ['A', 'B'],
          ['C', 'D'],
        ],
        withHeadings: false,
      );
      await tester.pumpWidget(_wrap(
        TableEditor(
          block: block,
          onChanged: (b) => updatedBlock = b,
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(updatedBlock?.withHeadings, true);
    });

    testWidgets('empty table content initializes correctly', (tester) async {
      const block = TableBlock(content: []);
      await tester.pumpWidget(_wrap(
        TableEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(TableEditor), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ImageEditor
  // ---------------------------------------------------------------------------
  group('ImageEditor', () {
    testWidgets('renders without URL without throwing', (tester) async {
      const block = ImageBlock(url: '');
      await tester.pumpWidget(_wrap(
        ImageEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ImageEditor), findsOneWidget);
    });

    testWidgets('renders with URL without throwing', (tester) async {
      const block = ImageBlock(url: 'https://example.com/img.png');
      await tester.pumpWidget(_wrap(
        ImageEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ImageEditor), findsOneWidget);
    });

    testWidgets('camera and gallery buttons are present', (tester) async {
      const block = ImageBlock(url: '');
      await tester.pumpWidget(_wrap(
        ImageEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Camera'), findsOneWidget);
      expect(find.text('Gallery'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // HeaderEditor
  // ---------------------------------------------------------------------------
  group('HeaderEditor', () {
    testWidgets('renders without throwing', (tester) async {
      const block = HeaderBlock(text: 'Title', level: 1);
      await tester.pumpWidget(_wrap(
        HeaderEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(HeaderEditor), findsOneWidget);
    });

    testWidgets('shows existing text', (tester) async {
      const block = HeaderBlock(text: 'My Heading', level: 2);
      await tester.pumpWidget(_wrap(
        HeaderEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.text('My Heading'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // QuoteEditor
  // ---------------------------------------------------------------------------
  group('QuoteEditor', () {
    testWidgets('renders without throwing', (tester) async {
      const block = QuoteBlock(text: 'A quote', alignment: QuoteAlignment.left);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: QuoteEditor(block: block, onChanged: (_) {}),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(QuoteEditor), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // WarningEditor
  // ---------------------------------------------------------------------------
  group('WarningEditor', () {
    testWidgets('renders without throwing', (tester) async {
      const block = WarningBlock(title: 'Note', message: 'Watch out');
      await tester.pumpWidget(_wrap(
        WarningEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Note'), findsOneWidget);
      expect(find.text('Watch out'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // CodeEditor
  // ---------------------------------------------------------------------------
  group('CodeEditor', () {
    testWidgets('renders without throwing', (tester) async {
      const block = CodeBlock(code: 'print("hello")');
      await tester.pumpWidget(_wrap(
        CodeEditor(block: block, onChanged: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.text('print("hello")'), findsOneWidget);
    });
  });
}
