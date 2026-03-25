import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../domain/entities/blocks/paragraph_block.dart';
import '../../../domain/entities/style_config.dart';
import '../base_block_renderer.dart';

class ParagraphRenderer extends BlockRenderer<ParagraphBlock> {
  const ParagraphRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: block.html,
      style: _buildStyleMap(styleConfig),
    );
  }

  Map<String, Style> _buildStyleMap(StyleConfig? config) {
    if (config == null || config.cssTags.isEmpty) return {};
    return {
      for (final tag in config.cssTags)
        tag.tag: Style(
          backgroundColor: tag.backgroundColor != null
              ? _parseColor(tag.backgroundColor!)
              : null,
          color: tag.color != null ? _parseColor(tag.color!) : null,
          padding: tag.padding != null
              ? HtmlPaddings.all(tag.padding!)
              : null,
        ),
    };
  }

  Color _parseColor(String hex) {
    final code = hex.replaceAll('#', '');
    return Color(int.parse(code, radix: 16));
  }
}
