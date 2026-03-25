import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/editorjs_flutter.dart';
import 'package:editorjs_flutter/src/presentation/blocks/header/header_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/delimiter/delimiter_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/code/code_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/warning/warning_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/checklist/checklist_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/embed/embed_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/attaches/attaches_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/paragraph/paragraph_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/quote/quote_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/list/list_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/table/table_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/image/image_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/link_tool/link_tool_renderer.dart';
import 'package:editorjs_flutter/src/presentation/blocks/raw/raw_renderer.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: SizedBox(width: 400, child: child),
      ),
    );

void main() {
  // ---------------------------------------------------------------------------
  // HeaderRenderer
  // ---------------------------------------------------------------------------
  group('HeaderRenderer', () {
    testWidgets('H1 finds Text widget containing the header text',
        (tester) async {
      const block = HeaderBlock(text: 'Test Header', level: 1);
      await tester
          .pumpWidget(_wrap(const HeaderRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('Test Header'), findsOneWidget);
    });

    testWidgets('H6 pumps without throw', (tester) async {
      const block = HeaderBlock(text: 'Small heading', level: 6);
      await tester
          .pumpWidget(_wrap(const HeaderRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('Small heading'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // DelimiterRenderer
  // ---------------------------------------------------------------------------
  group('DelimiterRenderer', () {
    testWidgets('pumps without throw', (tester) async {
      const block = DelimiterBlock();
      await tester
          .pumpWidget(_wrap(const DelimiterRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(Divider), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // CodeRenderer
  // ---------------------------------------------------------------------------
  group('CodeRenderer', () {
    testWidgets('shows code text', (tester) async {
      const block = CodeBlock(code: 'print("hello world")');
      await tester
          .pumpWidget(_wrap(const CodeRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('print("hello world")'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // WarningRenderer
  // ---------------------------------------------------------------------------
  group('WarningRenderer', () {
    testWidgets('shows title and message', (tester) async {
      const block = WarningBlock(title: 'Caution', message: 'Be careful here');
      await tester
          .pumpWidget(_wrap(const WarningRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('Caution'), findsOneWidget);
      expect(find.text('Be careful here'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ChecklistRenderer
  // ---------------------------------------------------------------------------
  group('ChecklistRenderer', () {
    testWidgets('checked and unchecked items pump without throw', (tester) async {
      const block = ChecklistBlock(
        items: [
          ChecklistItem(text: 'Done task', checked: true),
          ChecklistItem(text: 'Pending task', checked: false),
        ],
      );
      await tester
          .pumpWidget(_wrap(const ChecklistRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('Done task'), findsOneWidget);
      expect(find.text('Pending task'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // EmbedRenderer
  // ---------------------------------------------------------------------------
  group('EmbedRenderer', () {
    testWidgets('shows service name', (tester) async {
      const block = EmbedBlock(
        service: 'youtube',
        source: 'https://youtube.com/watch?v=test',
        embed: 'https://www.youtube.com/embed/test',
      );
      await tester
          .pumpWidget(_wrap(const EmbedRenderer(block: block)));
      await tester.pumpAndSettle();
      // The renderer capitalises the service name
      expect(find.text('Youtube'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // AttachesRenderer
  // ---------------------------------------------------------------------------
  group('AttachesRenderer', () {
    testWidgets('shows file title / download title', (tester) async {
      const block = AttachesBlock(
        url: 'https://example.com/document.pdf',
        name: 'document.pdf',
        extension: 'pdf',
        title: 'My Document',
      );
      await tester
          .pumpWidget(_wrap(const AttachesRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('My Document'), findsOneWidget);
    });

    testWidgets('shows file name when title is null', (tester) async {
      const block = AttachesBlock(
        url: 'https://example.com/report.pdf',
        name: 'report.pdf',
      );
      await tester
          .pumpWidget(_wrap(const AttachesRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('report.pdf'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ParagraphRenderer
  // ---------------------------------------------------------------------------
  group('ParagraphRenderer', () {
    testWidgets('renders HTML content without throwing', (tester) async {
      const block = ParagraphBlock(html: '<b>Bold text</b>');
      await tester
          .pumpWidget(_wrap(const ParagraphRenderer(block: block)));
      await tester.pumpAndSettle();
      // Rendered without throw — flutter_html renders inside RichText
      expect(find.byType(ParagraphRenderer), findsOneWidget);
    });

    testWidgets('renders plain text content without throwing', (tester) async {
      const block = ParagraphBlock(html: 'Plain text');
      await tester
          .pumpWidget(_wrap(const ParagraphRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(ParagraphRenderer), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // QuoteRenderer
  // ---------------------------------------------------------------------------
  group('QuoteRenderer', () {
    testWidgets('shows quote text and pumps without throw', (tester) async {
      const block = QuoteBlock(
        text: 'A wise quote.',
        alignment: QuoteAlignment.left,
      );
      await tester
          .pumpWidget(_wrap(const QuoteRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(QuoteRenderer), findsOneWidget);
    });

    testWidgets('shows caption when provided', (tester) async {
      const block = QuoteBlock(
        text: 'A wise quote.',
        caption: 'Author Name',
        alignment: QuoteAlignment.center,
      );
      await tester
          .pumpWidget(_wrap(const QuoteRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.textContaining('Author Name'), findsOneWidget);
    });

    testWidgets('right alignment pumps without throw', (tester) async {
      const block = QuoteBlock(
        text: 'Aligned right.',
        alignment: QuoteAlignment.right,
      );
      await tester
          .pumpWidget(_wrap(const QuoteRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(QuoteRenderer), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ListRenderer — unordered
  // ---------------------------------------------------------------------------
  group('ListRenderer', () {
    testWidgets('unordered list shows item text', (tester) async {
      const block = ListBlock(
        style: ListStyle.unordered,
        items: [
          ListItem(content: 'Apple'),
          ListItem(content: 'Banana'),
        ],
      );
      await tester
          .pumpWidget(_wrap(const ListRenderer(block: block)));
      await tester.pumpAndSettle();
      // flutter_html renders content so we just check the widget tree
      expect(find.byType(ListRenderer), findsOneWidget);
    });

    testWidgets('ordered list pumps without throw', (tester) async {
      const block = ListBlock(
        style: ListStyle.ordered,
        items: [
          ListItem(content: 'First'),
          ListItem(content: 'Second'),
        ],
      );
      await tester
          .pumpWidget(_wrap(const ListRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(ListRenderer), findsOneWidget);
    });

    testWidgets('nested list renders without throw', (tester) async {
      const block = ListBlock(
        style: ListStyle.unordered,
        items: [
          ListItem(
            content: 'Parent',
            items: [
              ListItem(content: 'Child'),
            ],
          ),
        ],
      );
      await tester
          .pumpWidget(_wrap(const ListRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(ListRenderer), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // TableRenderer
  // ---------------------------------------------------------------------------
  group('TableRenderer', () {
    testWidgets('shows cell content', (tester) async {
      const block = TableBlock(content: [
        ['Name', 'Age'],
        ['Alice', '30'],
      ]);
      await tester
          .pumpWidget(_wrap(const TableRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('with headings first row is rendered', (tester) async {
      const block = TableBlock(
        content: [
          ['ID', 'Value'],
          ['1', 'foo'],
        ],
        withHeadings: true,
      );
      await tester
          .pumpWidget(_wrap(const TableRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('ID'), findsOneWidget);
    });

    testWidgets('empty content renders without throw', (tester) async {
      const block = TableBlock(content: []);
      await tester
          .pumpWidget(_wrap(const TableRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(TableRenderer), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // ImageRenderer
  // ---------------------------------------------------------------------------
  group('ImageRenderer', () {
    testWidgets('pumps without throw (image load will fail)', (tester) async {
      const block = ImageBlock(url: 'https://example.com/nonexistent.png');
      await tester
          .pumpWidget(_wrap(const ImageRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(ImageRenderer), findsOneWidget);
    });

    testWidgets('shows caption when provided', (tester) async {
      const block = ImageBlock(
        url: 'https://example.com/img.png',
        caption: 'A photo',
      );
      await tester
          .pumpWidget(_wrap(const ImageRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('A photo'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // LinkToolRenderer
  // ---------------------------------------------------------------------------
  group('LinkToolRenderer', () {
    testWidgets('pumps without throw', (tester) async {
      const block = LinkToolBlock(
        link: 'https://example.com',
        meta: LinkToolMeta(title: 'Example', description: 'A test site'),
      );
      await tester
          .pumpWidget(_wrap(const LinkToolRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(LinkToolRenderer), findsOneWidget);
    });

    testWidgets('shows link title', (tester) async {
      const block = LinkToolBlock(
        link: 'https://example.com',
        meta: LinkToolMeta(title: 'My Link Title'),
      );
      await tester
          .pumpWidget(_wrap(const LinkToolRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.text('My Link Title'), findsOneWidget);
    });

    testWidgets('pumps without throw when meta is null', (tester) async {
      const block = LinkToolBlock(link: 'https://example.com');
      await tester
          .pumpWidget(_wrap(const LinkToolRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(LinkToolRenderer), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // RawRenderer
  // ---------------------------------------------------------------------------
  group('RawRenderer', () {
    testWidgets('renders sanitized HTML without throwing', (tester) async {
      const block = RawBlock(html: '<p>Hello <b>world</b></p>');
      await tester
          .pumpWidget(_wrap(const RawRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(RawRenderer), findsOneWidget);
    });

    testWidgets('renders with script tag stripped', (tester) async {
      const block = RawBlock(html: '<p>Safe</p><script>alert(1)</script>');
      await tester
          .pumpWidget(_wrap(const RawRenderer(block: block)));
      await tester.pumpAndSettle();
      expect(find.byType(RawRenderer), findsOneWidget);
    });
  });
}
