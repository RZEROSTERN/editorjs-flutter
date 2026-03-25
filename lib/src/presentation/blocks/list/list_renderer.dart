import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../domain/entities/blocks/list_block.dart';
import '../../../domain/entities/style_config.dart';
import '../base_block_renderer.dart';

class ListRenderer extends BlockRenderer<ListBlock> {
  const ListRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildItems(block.items, block.style, 0, styleConfig),
    );
  }

  static List<Widget> _buildItems(
    List<ListItem> items,
    ListStyle style,
    int depth,
    StyleConfig? styleConfig,
  ) {
    final indentLeft = depth * 16.0;
    int counter = 1;

    return [
      for (final item in items) ...[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: indentLeft),
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 6),
              child: Text(
                style == ListStyle.ordered ? '${counter++}.' : '\u2022',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: styleConfig?.defaultFont,
                ),
              ),
            ),
            Expanded(
              child: Html(
                data: item.content,
                style: _buildStyleMap(styleConfig),
              ),
            ),
          ],
        ),
        if (item.items.isNotEmpty)
          ..._buildItems(item.items, style, depth + 1, styleConfig),
      ],
    ];
  }

  static Map<String, Style> _buildStyleMap(StyleConfig? config) {
    if (config == null || config.cssTags.isEmpty) return {};
    return {
      for (final tag in config.cssTags)
        tag.tag: Style(
          backgroundColor:
              tag.backgroundColor != null ? _parseColor(tag.backgroundColor!) : null,
          color: tag.color != null ? _parseColor(tag.color!) : null,
          padding: tag.padding != null ? HtmlPaddings.all(tag.padding!) : null,
        ),
    };
  }

  static Color _parseColor(String hex) {
    final code = hex.replaceAll('#', '');
    return Color(int.parse(code, radix: 16));
  }
}
