import 'package:flutter_test/flutter_test.dart';
import 'package:editorjs_flutter/src/data/utils/html_sanitizer.dart';

void main() {
  group('HtmlSanitizer', () {
    test('passes clean HTML unchanged', () {
      const input = '<p>Hello <b>world</b></p>';
      expect(HtmlSanitizer.sanitize(input), equals(input));
    });

    test('strips <script> tags', () {
      const input = '<p>Safe</p><script>alert("xss")</script>';
      final result = HtmlSanitizer.sanitize(input);
      expect(result, contains('<p>Safe</p>'));
      expect(result, isNot(contains('<script>')));
      expect(result, isNot(contains('alert')));
    });

    test('strips <script> tags case-insensitively', () {
      const input = '<p>Safe</p><SCRIPT>alert("xss")</SCRIPT>';
      final result = HtmlSanitizer.sanitize(input);
      expect(result, isNot(contains('SCRIPT')));
      expect(result, isNot(contains('alert')));
    });

    test('strips multiline script blocks', () {
      const input = '<p>A</p><script>\n  var x = 1;\n  alert(x);\n</script><p>B</p>';
      final result = HtmlSanitizer.sanitize(input);
      expect(result, contains('<p>A</p>'));
      expect(result, contains('<p>B</p>'));
      expect(result, isNot(contains('script')));
      expect(result, isNot(contains('alert')));
    });

    test('strips <iframe> tags', () {
      const input = '<p>Safe</p><iframe src="https://evil.com"></iframe>';
      final result = HtmlSanitizer.sanitize(input);
      expect(result, contains('<p>Safe</p>'));
      expect(result, isNot(contains('<iframe')));
    });

    test('strips onclick event handler attribute', () {
      const input = '<p onclick="alert(1)">Click me</p>';
      final result = HtmlSanitizer.sanitize(input);
      expect(result, isNot(contains('onclick')));
      expect(result, contains('Click me'));
    });

    test('strips onload event handler attribute', () {
      const input = '<img src="x" onload="alert(1)">';
      final result = HtmlSanitizer.sanitize(input);
      expect(result, isNot(contains('onload')));
    });

    test('handles empty string', () {
      expect(HtmlSanitizer.sanitize(''), equals(''));
    });

    test('handles plain text with no HTML', () {
      const input = 'Just plain text, no HTML here.';
      expect(HtmlSanitizer.sanitize(input), equals(input));
    });
  });
}
