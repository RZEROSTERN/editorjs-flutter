import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/editorjs_flutter.dart';

void main() {
  // ---------------------------------------------------------------------------
  // HeaderBlock
  // ---------------------------------------------------------------------------
  group('HeaderBlock', () {
    test('type getter returns "header"', () {
      const block = HeaderBlock(text: 'Hi', level: 2);
      expect(block.type, 'header');
    });

    test('toJson returns correct map', () {
      const block = HeaderBlock(text: 'Hi', level: 2);
      final json = block.toJson();
      expect(json['text'], 'Hi');
      expect(json['level'], 2);
    });
  });

  // ---------------------------------------------------------------------------
  // ParagraphBlock
  // ---------------------------------------------------------------------------
  group('ParagraphBlock', () {
    test('type getter returns "paragraph"', () {
      const block = ParagraphBlock(html: '<b>x</b>');
      expect(block.type, 'paragraph');
    });

    test('toJson contains text key', () {
      const block = ParagraphBlock(html: '<b>x</b>');
      final json = block.toJson();
      expect(json['text'], '<b>x</b>');
    });
  });

  // ---------------------------------------------------------------------------
  // ListBlock
  // ---------------------------------------------------------------------------
  group('ListBlock', () {
    test('type getter returns "list"', () {
      const block = ListBlock(
        style: ListStyle.ordered,
        items: [ListItem(content: 'a')],
      );
      expect(block.type, 'list');
    });

    test('toJson ordered style', () {
      const block = ListBlock(
        style: ListStyle.ordered,
        items: [ListItem(content: 'a')],
      );
      final json = block.toJson();
      expect(json['style'], 'ordered');
      final items = json['items'] as List<dynamic>;
      expect(items.length, 1);
      expect((items[0] as Map<String, dynamic>)['content'], 'a');
    });

    test('toJson unordered style', () {
      const block = ListBlock(
        style: ListStyle.unordered,
        items: [ListItem(content: 'b')],
      );
      final json = block.toJson();
      expect(json['style'], 'unordered');
    });

    test('ListItem toJson includes nested items', () {
      const item = ListItem(
        content: 'parent',
        items: [ListItem(content: 'child')],
      );
      final json = item.toJson();
      expect(json['content'], 'parent');
      final nested = json['items'] as List<dynamic>;
      expect(nested.length, 1);
      expect((nested[0] as Map<String, dynamic>)['content'], 'child');
    });

    test('ListItem copyWith works', () {
      const item = ListItem(content: 'original');
      final copy = item.copyWith(content: 'updated');
      expect(copy.content, 'updated');
      expect(copy.items, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // DelimiterBlock
  // ---------------------------------------------------------------------------
  group('DelimiterBlock', () {
    test('type getter returns "delimiter"', () {
      const block = DelimiterBlock();
      expect(block.type, 'delimiter');
    });

    test('toJson returns empty map', () {
      const block = DelimiterBlock();
      expect(block.toJson(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // ImageBlock
  // ---------------------------------------------------------------------------
  group('ImageBlock', () {
    test('type getter returns "image"', () {
      const block = ImageBlock(url: 'http://x.com/img.png');
      expect(block.type, 'image');
    });

    test('toJson contains file.url', () {
      const block = ImageBlock(url: 'http://x.com/img.png');
      final json = block.toJson();
      final file = json['file'] as Map<String, dynamic>;
      expect(file['url'], 'http://x.com/img.png');
    });

    test('toJson defaults for bool fields', () {
      const block = ImageBlock(url: 'http://x.com/img.png');
      final json = block.toJson();
      expect(json['withBorder'], false);
      expect(json['stretched'], false);
      expect(json['withBackground'], false);
    });

    test('toJson with all fields set', () {
      const block = ImageBlock(
        url: 'http://x.com/img.png',
        caption: 'Caption',
        withBorder: true,
        stretched: true,
        withBackground: true,
      );
      final json = block.toJson();
      expect(json['caption'], 'Caption');
      expect(json['withBorder'], true);
      expect(json['stretched'], true);
      expect(json['withBackground'], true);
    });
  });

  // ---------------------------------------------------------------------------
  // QuoteBlock
  // ---------------------------------------------------------------------------
  group('QuoteBlock', () {
    test('type getter returns "quote"', () {
      const block = QuoteBlock(text: 'q', alignment: QuoteAlignment.center);
      expect(block.type, 'quote');
    });

    test('toJson contains text and alignment', () {
      const block = QuoteBlock(text: 'q', alignment: QuoteAlignment.center);
      final json = block.toJson();
      expect(json['text'], 'q');
      expect(json['alignment'], 'center');
    });

    test('toJson with caption', () {
      const block = QuoteBlock(
        text: 'q',
        caption: 'Author',
        alignment: QuoteAlignment.left,
      );
      final json = block.toJson();
      expect(json['caption'], 'Author');
    });

    test('toJson caption defaults to empty string when null', () {
      const block = QuoteBlock(text: 'q', alignment: QuoteAlignment.right);
      final json = block.toJson();
      expect(json['caption'], '');
    });
  });

  // ---------------------------------------------------------------------------
  // CodeBlock
  // ---------------------------------------------------------------------------
  group('CodeBlock', () {
    test('type getter returns "code"', () {
      const block = CodeBlock(code: 'print(1)');
      expect(block.type, 'code');
    });

    test('toJson contains code field', () {
      const block = CodeBlock(code: 'print(1)');
      final json = block.toJson();
      expect(json['code'], 'print(1)');
    });
  });

  // ---------------------------------------------------------------------------
  // ChecklistBlock
  // ---------------------------------------------------------------------------
  group('ChecklistBlock', () {
    test('type getter returns "checklist"', () {
      const block = ChecklistBlock(
        items: [ChecklistItem(text: 'do', checked: true)],
      );
      expect(block.type, 'checklist');
    });

    test('toJson contains items list', () {
      const block = ChecklistBlock(
        items: [
          ChecklistItem(text: 'do', checked: true),
          ChecklistItem(text: 'don\'t', checked: false),
        ],
      );
      final json = block.toJson();
      final items = json['items'] as List<dynamic>;
      expect(items.length, 2);
      expect((items[0] as Map<String, dynamic>)['text'], 'do');
      expect((items[0] as Map<String, dynamic>)['checked'], true);
      expect((items[1] as Map<String, dynamic>)['checked'], false);
    });

    test('ChecklistItem copyWith works', () {
      const item = ChecklistItem(text: 'task', checked: false);
      final copy = item.copyWith(checked: true);
      expect(copy.checked, true);
      expect(copy.text, 'task');
    });
  });

  // ---------------------------------------------------------------------------
  // TableBlock
  // ---------------------------------------------------------------------------
  group('TableBlock', () {
    test('type getter returns "table"', () {
      const block = TableBlock(content: [
        ['a', 'b'],
        ['c', 'd'],
      ]);
      expect(block.type, 'table');
    });

    test('toJson with headings', () {
      const block = TableBlock(
        content: [
          ['a', 'b'],
          ['c', 'd'],
        ],
        withHeadings: true,
      );
      final json = block.toJson();
      expect(json['withHeadings'], true);
      final content = json['content'] as List<dynamic>;
      expect(content.length, 2);
    });

    test('toJson without headings defaults to false', () {
      const block = TableBlock(content: [
        ['x'],
      ]);
      final json = block.toJson();
      expect(json['withHeadings'], false);
    });
  });

  // ---------------------------------------------------------------------------
  // WarningBlock
  // ---------------------------------------------------------------------------
  group('WarningBlock', () {
    test('type getter returns "warning"', () {
      const block = WarningBlock(title: 'T', message: 'M');
      expect(block.type, 'warning');
    });

    test('toJson contains title and message', () {
      const block = WarningBlock(title: 'T', message: 'M');
      final json = block.toJson();
      expect(json['title'], 'T');
      expect(json['message'], 'M');
    });
  });

  // ---------------------------------------------------------------------------
  // EmbedBlock
  // ---------------------------------------------------------------------------
  group('EmbedBlock', () {
    test('type getter returns "embed"', () {
      const block = EmbedBlock(
        service: 'youtube',
        source: 'https://yt.be/x',
        embed: 'https://yt.be/embed/x',
      );
      expect(block.type, 'embed');
    });

    test('toJson contains service, source, embed', () {
      const block = EmbedBlock(
        service: 'youtube',
        source: 'https://yt.be/x',
        embed: 'https://yt.be/embed/x',
      );
      final json = block.toJson();
      expect(json['service'], 'youtube');
      expect(json['source'], 'https://yt.be/x');
      expect(json['embed'], 'https://yt.be/embed/x');
    });

    test('toJson optional width and height when set', () {
      const block = EmbedBlock(
        service: 'vimeo',
        source: 'https://vimeo.com/1',
        embed: 'https://player.vimeo.com/video/1',
        width: 640,
        height: 480,
        caption: 'Nice video',
      );
      final json = block.toJson();
      expect(json['width'], 640);
      expect(json['height'], 480);
      expect(json['caption'], 'Nice video');
    });

    test('toJson omits width/height when null', () {
      const block = EmbedBlock(
        service: 'youtube',
        source: 'https://yt.be/x',
        embed: 'https://yt.be/embed/x',
      );
      final json = block.toJson();
      expect(json.containsKey('width'), false);
      expect(json.containsKey('height'), false);
    });
  });

  // ---------------------------------------------------------------------------
  // LinkToolBlock
  // ---------------------------------------------------------------------------
  group('LinkToolBlock', () {
    test('type getter returns "linkTool"', () {
      const block = LinkToolBlock(link: 'https://x.com');
      expect(block.type, 'linkTool');
    });

    test('toJson contains link', () {
      const block = LinkToolBlock(
        link: 'https://x.com',
        meta: LinkToolMeta(title: 'X'),
      );
      final json = block.toJson();
      expect(json['link'], 'https://x.com');
      final meta = json['meta'] as Map<String, dynamic>;
      expect(meta['title'], 'X');
    });

    test('toJson omits meta when null', () {
      const block = LinkToolBlock(link: 'https://x.com');
      final json = block.toJson();
      expect(json.containsKey('meta'), false);
    });

    test('LinkToolMeta toJson with imageUrl', () {
      const meta = LinkToolMeta(
        title: 'Title',
        description: 'Desc',
        imageUrl: 'https://x.com/img.png',
      );
      final json = meta.toJson();
      expect(json['title'], 'Title');
      expect(json['description'], 'Desc');
      final image = json['image'] as Map<String, dynamic>;
      expect(image['url'], 'https://x.com/img.png');
    });
  });

  // ---------------------------------------------------------------------------
  // AttachesBlock
  // ---------------------------------------------------------------------------
  group('AttachesBlock', () {
    test('type getter returns "attaches"', () {
      const block = AttachesBlock(
        url: 'https://x.com/f.pdf',
        extension: 'pdf',
        size: 1024,
      );
      expect(block.type, 'attaches');
    });

    test('toJson contains file.url and extension and size', () {
      const block = AttachesBlock(
        url: 'https://x.com/f.pdf',
        extension: 'pdf',
        size: 1024,
      );
      final json = block.toJson();
      final file = json['file'] as Map<String, dynamic>;
      expect(file['url'], 'https://x.com/f.pdf');
      expect(file['extension'], 'pdf');
      expect(file['size'], 1024);
    });

    test('toJson title defaults to empty string when null', () {
      const block = AttachesBlock(url: 'https://x.com/f.pdf');
      final json = block.toJson();
      expect(json['title'], '');
    });
  });

  // ---------------------------------------------------------------------------
  // RawBlock
  // ---------------------------------------------------------------------------
  group('RawBlock', () {
    test('type getter returns "raw"', () {
      const block = RawBlock(html: '<p>raw</p>');
      expect(block.type, 'raw');
    });

    test('toJson contains html field', () {
      const block = RawBlock(html: '<p>raw</p>');
      final json = block.toJson();
      expect(json['html'], '<p>raw</p>');
    });
  });

  // ---------------------------------------------------------------------------
  // BlockDocument round-trip
  // ---------------------------------------------------------------------------
  group('BlockDocument', () {
    test('toJson round-trip', () {
      const doc = BlockDocument(
        time: 1000,
        version: '2.19.0',
        blocks: [
          HeaderBlock(text: 'Title', level: 1),
          ParagraphBlock(html: '<b>Body</b>'),
        ],
      );
      final json = doc.toJson();
      expect(json['time'], 1000);
      expect(json['version'], '2.19.0');
      final blocks = json['blocks'] as List<dynamic>;
      expect(blocks.length, 2);
      final first = blocks[0] as Map<String, dynamic>;
      expect(first['type'], 'header');
      expect((first['data'] as Map<String, dynamic>)['text'], 'Title');
    });

    test('toJson can be serialized to JSON string and back', () {
      const doc = BlockDocument(
        time: 500,
        version: '2.19.0',
        blocks: [DelimiterBlock()],
      );
      final jsonStr = jsonEncode(doc.toJson());
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['time'], 500);
      final blocks = decoded['blocks'] as List<dynamic>;
      expect(blocks.length, 1);
      expect((blocks[0] as Map<String, dynamic>)['type'], 'delimiter');
    });
  });
}
