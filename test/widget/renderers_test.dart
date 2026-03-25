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
}
