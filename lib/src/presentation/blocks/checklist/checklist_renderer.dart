import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/checklist_block.dart';
import '../base_block_renderer.dart';

class ChecklistRenderer extends BlockRenderer<ChecklistBlock> {
  const ChecklistRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: block.items.map((item) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: Icon(
                item.checked
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                size: 18,
                color: item.checked
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(
                  fontFamily: styleConfig?.defaultFont,
                  decoration:
                      item.checked ? TextDecoration.lineThrough : null,
                  color: item.checked ? Colors.grey : null,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
