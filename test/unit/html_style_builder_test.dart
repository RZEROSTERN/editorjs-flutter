import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/src/presentation/utils/html_style_builder.dart';
import 'package:editorjs_flutter/src/domain/entities/style_config.dart';

void main() {
  group('HtmlStyleBuilder', () {
    test('build(null) returns empty map', () {
      final result = HtmlStyleBuilder.build(null);
      expect(result, isEmpty);
    });

    test('build with defaultFont returns map with body key', () {
      const config = StyleConfig(cssTags: [], defaultFont: 'Roboto');
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('body'), true);
      expect(result['body']!.fontFamily, 'Roboto');
    });

    test('build with cssTags returns map with tag key', () {
      const config = StyleConfig(
        cssTags: [
          CssTagConfig(tag: 'mark', backgroundColor: '#ffff00'),
        ],
      );
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('mark'), true);
    });

    test('build with defaultFont and cssTags has both body and code keys', () {
      const config = StyleConfig(
        defaultFont: 'Roboto',
        cssTags: [CssTagConfig(tag: 'code')],
      );
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('body'), true);
      expect(result.containsKey('code'), true);
    });

    test('build with StyleConfig with no defaultFont has no body key', () {
      const config = StyleConfig(cssTags: []);
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('body'), false);
    });

    test('build with color in tag config', () {
      const config = StyleConfig(
        cssTags: [CssTagConfig(tag: 'b', color: '#ff0000')],
      );
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('b'), true);
    });

    test('build with padding in tag config', () {
      const config = StyleConfig(
        cssTags: [CssTagConfig(tag: 'p', padding: 8.0)],
      );
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('p'), true);
    });

    test('build handles 8-digit ARGB hex color', () {
      const config = StyleConfig(
        cssTags: [CssTagConfig(tag: 'em', backgroundColor: 'FF123456')],
      );
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('em'), true);
    });

    test('build handles invalid hex color gracefully', () {
      const config = StyleConfig(
        cssTags: [CssTagConfig(tag: 'em', backgroundColor: 'ZZZZZZ')],
      );
      final result = HtmlStyleBuilder.build(config);
      // Should not throw, and the tag should still be present
      expect(result.containsKey('em'), true);
    });

    test('build handles too-short hex color gracefully', () {
      const config = StyleConfig(
        cssTags: [CssTagConfig(tag: 'em', backgroundColor: 'FFF')],
      );
      final result = HtmlStyleBuilder.build(config);
      expect(result.containsKey('em'), true);
    });
  });
}
