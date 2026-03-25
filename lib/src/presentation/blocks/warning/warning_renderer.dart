import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/warning_block.dart';
import '../base_block_renderer.dart';

class WarningRenderer extends BlockRenderer<WarningBlock> {
  const WarningRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        border: Border.all(color: const Color(0xFFFFE082)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10, top: 2),
            child: Icon(Icons.warning_amber_rounded,
                color: Color(0xFFF9A825), size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (block.title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      block.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: styleConfig?.defaultFont,
                      ),
                    ),
                  ),
                Text(
                  block.message,
                  style: TextStyle(fontFamily: styleConfig?.defaultFont),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
