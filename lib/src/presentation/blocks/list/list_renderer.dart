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
      children: [
        for (var i = 0; i < block.items.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 6),
                child: Text(
                  _bullet(i),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                child: Html(
                  data: block.items[i],
                  style: _buildStyleMap(styleConfig),
                ),
              ),
            ],
          ),
      ],
    );
  }

  String _bullet(int index) =>
      block.style == ListStyle.ordered ? '${index + 1}.' : '\u2022';

  Map<String, Style> _buildStyleMap(StyleConfig? config) {
    if (config == null || config.cssTags.isEmpty) return {};
    return {
      for (final tag in config.cssTags)
        tag.tag: Style(
          backgroundColor: tag.backgroundColor != null
              ? _parseColor(tag.backgroundColor!)
              : null,
          color: tag.color != null ? _parseColor(tag.color!) : null,
          padding: tag.padding != null ? HtmlPaddings.all(tag.padding!) : null,
        ),
    };
  }

  Color _parseColor(String hex) {
    final code = hex.replaceAll('#', '');
    return Color(int.parse(code, radix: 16));
  }
}
