import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../domain/entities/style_config.dart';

/// Builds a `flutter_html` style map from a [StyleConfig].
///
/// Centralises font and CSS-tag styling so every HTML-rendering block
/// renderer applies them consistently without duplicating logic.
class HtmlStyleBuilder {
  HtmlStyleBuilder._();

  /// Returns a style map ready to pass to [Html.style].
  ///
  /// Always includes a `body` rule that applies [StyleConfig.defaultFont]
  /// when one is configured, so the font propagates to all HTML content.
  static Map<String, Style> build(StyleConfig? config) {
    final map = <String, Style>{};

    if (config?.defaultFont != null) {
      map['body'] = Style(fontFamily: config!.defaultFont);
    }

    for (final tag in config?.cssTags ?? []) {
      map[tag.tag] = Style(
        backgroundColor: tag.backgroundColor != null
            ? _parseColor(tag.backgroundColor!)
            : null,
        color: tag.color != null ? _parseColor(tag.color!) : null,
        padding:
            tag.padding != null ? HtmlPaddings.all(tag.padding!) : null,
        fontFamily: config?.defaultFont,
      );
    }

    return map;
  }

  static Color _parseColor(String hex) {
    // Remove leading '#' characters, if any.
    final code = hex.replaceAll('#', '');

    // Normalize to 8-digit ARGB. Accept 6-digit RGB or 8-digit ARGB; otherwise fallback.
    String normalized;
    if (code.length == 6) {
      // Treat 6-digit RGB as fully opaque.
      normalized = 'FF$code';
    } else if (code.length == 8) {
      normalized = code;
    } else {
      // Invalid length, use a safe fallback color.
      return const Color(0xFF000000);
    }

    final value = int.tryParse(normalized, radix: 16);
    if (value == null) {
      // Invalid hex characters, use a safe fallback color.
      return const Color(0xFF000000);
    }

    return Color(value);
  }
}
