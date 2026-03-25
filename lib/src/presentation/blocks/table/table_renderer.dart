import 'package:flutter/material.dart';

import '../../../domain/entities/blocks/table_block.dart';
import '../base_block_renderer.dart';

class TableRenderer extends BlockRenderer<TableBlock> {
  const TableRenderer({super.key, required super.block, super.styleConfig});

  @override
  Widget build(BuildContext context) {
    if (block.content.isEmpty) return const SizedBox.shrink();

    final columnCount = block.content.map((r) => r.length).reduce(
          (a, b) => a > b ? a : b,
        );
    if (columnCount == 0) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        children: block.content.asMap().entries.map((entry) {
          final rowIndex = entry.key;
          final row = entry.value;
          final isHeader = block.withHeadings && rowIndex == 0;

          return TableRow(
            decoration: isHeader
                ? BoxDecoration(color: Colors.grey.shade100)
                : null,
            children: List.generate(columnCount, (colIndex) {
              final cell =
                  colIndex < row.length ? row[colIndex] : '';
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: Text(
                  cell,
                  style: TextStyle(
                    fontWeight:
                        isHeader ? FontWeight.bold : FontWeight.normal,
                    fontFamily: styleConfig?.defaultFont,
                  ),
                ),
              );
            }),
          );
        }).toList(),
      ),
    );
  }
}
