/// Lightweight HTML sanitizer for EditorJS block content.
///
/// Strips `<script>` tags and `on*` event handler attributes to prevent
/// JavaScript injection. `flutter_html` does not execute JS, but sanitizing
/// at the data layer keeps the domain clean regardless of the renderer used.
class HtmlSanitizer {
  HtmlSanitizer._();

  static final _scriptTag = RegExp(
    r'<script[^>]*>.*?</script>',
    caseSensitive: false,
    dotAll: true,
  );

  static final _eventHandlers = RegExp(
    r'''\s+on\w+\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]*)''',
    caseSensitive: false,
  );

  static final _iframeTag = RegExp(
    r'<iframe[^>]*>.*?</iframe>',
    caseSensitive: false,
    dotAll: true,
  );

  /// Returns a sanitized copy of [html] safe to pass to a renderer.
  static String sanitize(String html) => html
      .replaceAll(_scriptTag, '')
      .replaceAll(_iframeTag, '')
      .replaceAll(_eventHandlers, '');
}
