import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/delimiter_block.dart';
import '../base_block_renderer.dart';

class DelimiterRenderer extends BlockRenderer<DelimiterBlock> {
  const DelimiterRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: Colors.grey),
    );
  }
}
