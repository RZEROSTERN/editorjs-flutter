import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/src/data/mappers/header_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/paragraph_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/list_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/delimiter_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/image_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/quote_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/code_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/checklist_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/table_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/warning_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/embed_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/link_tool_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/attaches_mapper.dart';
import 'package:editorjs_flutter/src/data/mappers/raw_mapper.dart';
import 'package:editorjs_flutter/editorjs_flutter.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------
  group('HeaderMapper', () {
    const mapper = HeaderMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({'text': 'Hello', 'level': 2});
      expect(block.text, 'Hello');
      expect(block.level, 2);
    });

    test('missing fields – empty map returns safe defaults', () {
      final block = mapper.fromJson({});
      expect(block.text, '');
      expect(block.level, 1);
    });

    test('wrong type for level (String) – does not throw, uses default', () {
      final block = mapper.fromJson({'text': 'Title', 'level': 'two'});
      expect(block.level, 1);
    });
  });

  // ---------------------------------------------------------------------------
  // Paragraph
  // ---------------------------------------------------------------------------
  group('ParagraphMapper', () {
    const mapper = ParagraphMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({'text': '<p>Hello</p>'});
      expect(block.html, '<p>Hello</p>');
    });

    test('missing fields – empty map returns safe defaults', () {
      final block = mapper.fromJson({});
      expect(block.html, '');
    });

    test('null text field – does not throw, uses empty default', () {
      final block = mapper.fromJson({'text': null});
      expect(block.html, '');
    });
  });

  // ---------------------------------------------------------------------------
  // List (flat)
  // ---------------------------------------------------------------------------
  group('ListMapper (flat)', () {
    const mapper = ListMapper();

    test('happy path – ordered list with string items', () {
      final block = mapper.fromJson({
        'style': 'ordered',
        'items': ['Item 1', 'Item 2'],
      });
      expect(block.style, ListStyle.ordered);
      expect(block.items.length, 2);
      expect(block.items.first.content, 'Item 1');
    });

    test('missing fields – empty map returns unordered empty list', () {
      final block = mapper.fromJson({});
      expect(block.style, ListStyle.unordered);
      expect(block.items, isEmpty);
    });

    test('unknown string for style – defaults to unordered', () {
      final block = mapper.fromJson({'style': 'diagonal', 'items': []});
      expect(block.style, ListStyle.unordered);
    });
  });

  // ---------------------------------------------------------------------------
  // List (nested)
  // ---------------------------------------------------------------------------
  group('ListMapper (nested)', () {
    const mapper = ListMapper();

    test('happy path – nested items with content and sub-items', () {
      final block = mapper.fromJson({
        'style': 'unordered',
        'items': [
          {
            'content': 'Parent',
            'items': [
              {'content': 'Child', 'items': []},
            ],
          },
        ],
      });
      expect(block.items.first.content, 'Parent');
      expect(block.items.first.items.first.content, 'Child');
    });

    test('nested item with missing content – defaults to empty string', () {
      final block = mapper.fromJson({
        'style': 'unordered',
        'items': [
          {'items': []},
        ],
      });
      expect(block.items.first.content, '');
    });
  });

  // ---------------------------------------------------------------------------
  // Delimiter
  // ---------------------------------------------------------------------------
  group('DelimiterMapper', () {
    const mapper = DelimiterMapper();

    test('happy path – produces DelimiterBlock regardless of data', () {
      final block = mapper.fromJson({});
      expect(block, isA<DelimiterBlock>());
    });

    test('does not throw with unexpected data', () {
      expect(() => mapper.fromJson({'unexpected': 'data'}), returnsNormally);
    });
  });

  // ---------------------------------------------------------------------------
  // Image
  // ---------------------------------------------------------------------------
  group('ImageMapper', () {
    const mapper = ImageMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({
        'file': {'url': 'https://example.com/img.png'},
        'caption': 'My image',
        'withBorder': true,
        'stretched': false,
        'withBackground': true,
      });
      expect(block.url, 'https://example.com/img.png');
      expect(block.caption, 'My image');
      expect(block.withBorder, isTrue);
      expect(block.withBackground, isTrue);
    });

    test('missing fields – empty map returns safe defaults', () {
      final block = mapper.fromJson({});
      expect(block.url, '');
      expect(block.withBorder, isFalse);
      expect(block.stretched, isFalse);
      expect(block.withBackground, isFalse);
    });

    test('file is not a Map – does not throw', () {
      final block = mapper.fromJson({'file': 'not-a-map'});
      expect(block.url, '');
    });

    test('bool fields are wrong type (String) – does not throw, uses false', () {
      final block = mapper.fromJson({
        'withBorder': 'yes',
        'stretched': 'no',
        'withBackground': 'true',
      });
      expect(block.withBorder, isFalse);
      expect(block.stretched, isFalse);
      expect(block.withBackground, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Quote
  // ---------------------------------------------------------------------------
  group('QuoteMapper', () {
    const mapper = QuoteMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({
        'text': 'A quote',
        'caption': 'Author',
        'alignment': 'center',
      });
      expect(block.text, 'A quote');
      expect(block.caption, 'Author');
      expect(block.alignment, QuoteAlignment.center);
    });

    test('missing fields – empty map returns safe defaults', () {
      final block = mapper.fromJson({});
      expect(block.text, '');
      expect(block.alignment, QuoteAlignment.left);
    });

    test('unknown alignment string – defaults to left', () {
      final block = mapper.fromJson({'text': 'Q', 'alignment': 'diagonal'});
      expect(block.alignment, QuoteAlignment.left);
    });
  });

  // ---------------------------------------------------------------------------
  // Code
  // ---------------------------------------------------------------------------
  group('CodeMapper', () {
    const mapper = CodeMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({'code': 'print("hello")'});
      expect(block.code, 'print("hello")');
    });

    test('missing fields – empty map returns empty code', () {
      final block = mapper.fromJson({});
      expect(block.code, '');
    });

    test('null code field – does not throw, uses empty default', () {
      final block = mapper.fromJson({'code': null});
      expect(block.code, '');
    });
  });

  // ---------------------------------------------------------------------------
  // Checklist
  // ---------------------------------------------------------------------------
  group('ChecklistMapper', () {
    const mapper = ChecklistMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({
        'items': [
          {'text': 'Do this', 'checked': true},
          {'text': 'Do that', 'checked': false},
        ],
      });
      expect(block.items.length, 2);
      expect(block.items.first.checked, isTrue);
      expect(block.items.last.checked, isFalse);
    });

    test('missing fields – empty map returns empty items list', () {
      final block = mapper.fromJson({});
      expect(block.items, isEmpty);
    });

    test('checked is wrong type (String) – does not throw, uses false', () {
      final block = mapper.fromJson({
        'items': [
          {'text': 'Task', 'checked': 'yes'},
        ],
      });
      expect(block.items.first.checked, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Table
  // ---------------------------------------------------------------------------
  group('TableMapper', () {
    const mapper = TableMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({
        'withHeadings': true,
        'content': [
          ['A', 'B'],
          ['1', '2'],
        ],
      });
      expect(block.withHeadings, isTrue);
      expect(block.content.length, 2);
      expect(block.content.first, ['A', 'B']);
    });

    test('missing fields – empty map returns safe defaults', () {
      final block = mapper.fromJson({});
      expect(block.withHeadings, isFalse);
      expect(block.content, isEmpty);
    });

    test('withHeadings is wrong type (String) – does not throw, uses false', () {
      final block = mapper.fromJson({'withHeadings': 'yes'});
      expect(block.withHeadings, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // Warning
  // ---------------------------------------------------------------------------
  group('WarningMapper', () {
    const mapper = WarningMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({
        'title': 'Danger',
        'message': 'Be careful',
      });
      expect(block.title, 'Danger');
      expect(block.message, 'Be careful');
    });

    test('missing fields – empty map returns empty strings', () {
      final block = mapper.fromJson({});
      expect(block.title, '');
      expect(block.message, '');
    });

    test('null values – does not throw, uses defaults', () {
      final block = mapper.fromJson({'title': null, 'message': null});
      expect(block.title, '');
      expect(block.message, '');
    });
  });

  // ---------------------------------------------------------------------------
  // Embed
  // ---------------------------------------------------------------------------
  group('EmbedMapper', () {
    const mapper = EmbedMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({
        'service': 'youtube',
        'source': 'https://youtube.com/watch?v=abc',
        'embed': 'https://www.youtube.com/embed/abc',
        'width': 580,
        'height': 320,
        'caption': 'A video',
      });
      expect(block.service, 'youtube');
      expect(block.width, 580);
      expect(block.height, 320);
    });

    test('missing fields – empty map returns safe defaults', () {
      final block = mapper.fromJson({});
      expect(block.service, '');
      expect(block.width, isNull);
      expect(block.height, isNull);
    });

    test('width/height as double (num) – converts to int', () {
      final block = mapper.fromJson({
        'service': 's',
        'source': '',
        'embed': '',
        'width': 580.0,
        'height': 320.5,
      });
      expect(block.width, 580);
      expect(block.height, 320);
    });

    test('width/height as wrong type – does not throw, returns null', () {
      final block = mapper.fromJson({'width': 'wide', 'height': 'tall'});
      expect(block.width, isNull);
      expect(block.height, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // LinkTool
  // ---------------------------------------------------------------------------
  group('LinkToolMapper', () {
    const mapper = LinkToolMapper();

    test('happy path – full valid data with meta', () {
      final block = mapper.fromJson({
        'link': 'https://example.com',
        'meta': {
          'title': 'Example',
          'description': 'A site',
          'image': {'url': 'https://example.com/img.png'},
        },
      });
      expect(block.link, 'https://example.com');
      expect(block.meta?.title, 'Example');
      expect(block.meta?.imageUrl, 'https://example.com/img.png');
    });

    test('missing fields – empty map returns empty link and null meta', () {
      final block = mapper.fromJson({});
      expect(block.link, '');
      expect(block.meta, isNull);
    });

    test('meta image is not a Map – does not throw', () {
      final block = mapper.fromJson({
        'link': 'https://example.com',
        'meta': {
          'title': 'Example',
          'image': 'not-a-map',
        },
      });
      expect(block.meta?.imageUrl, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Attaches
  // ---------------------------------------------------------------------------
  group('AttachesMapper', () {
    const mapper = AttachesMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({
        'file': {
          'url': 'https://example.com/file.pdf',
          'name': 'file.pdf',
          'extension': 'pdf',
          'size': 1024,
        },
        'title': 'My Document',
      });
      expect(block.url, 'https://example.com/file.pdf');
      expect(block.name, 'file.pdf');
      expect(block.size, 1024);
      expect(block.title, 'My Document');
    });

    test('missing fields – empty map returns safe defaults', () {
      final block = mapper.fromJson({});
      expect(block.url, '');
      expect(block.size, isNull);
    });

    test('file is not a Map – does not throw', () {
      final block = mapper.fromJson({'file': 'not-a-map'});
      expect(block.url, '');
    });

    test('size as double (num) – converts to int', () {
      final block = mapper.fromJson({
        'file': {'url': 'https://example.com/f.zip', 'size': 2048.0},
      });
      expect(block.size, 2048);
    });

    test('size as wrong type – does not throw, returns null', () {
      final block = mapper.fromJson({
        'file': {'url': 'https://example.com/f.zip', 'size': 'big'},
      });
      expect(block.size, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Raw
  // ---------------------------------------------------------------------------
  group('RawMapper', () {
    const mapper = RawMapper();

    test('happy path – full valid data', () {
      final block = mapper.fromJson({'html': '<div>Raw HTML</div>'});
      expect(block.html, '<div>Raw HTML</div>');
    });

    test('missing fields – empty map returns empty string', () {
      final block = mapper.fromJson({});
      expect(block.html, '');
    });

    test('null html field – does not throw, uses empty default', () {
      final block = mapper.fromJson({'html': null});
      expect(block.html, '');
    });
  });
}
