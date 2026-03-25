import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../data/utils/html_sanitizer.dart';
import '../../../domain/entities/blocks/raw_block.dart';
import '../../utils/html_style_builder.dart';
import '../base_block_renderer.dart';

/// Renders raw HTML content. Content is sanitized before display.
class RawRenderer extends BlockRenderer<RawBlock> {
  const RawRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: HtmlSanitizer.sanitize(block.html),
      style: HtmlStyleBuilder.build(styleConfig),
    );
  }
}
