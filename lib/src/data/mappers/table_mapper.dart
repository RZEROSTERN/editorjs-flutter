import '../../domain/entities/blocks/table_block.dart';
import 'block_mapper.dart';

class TableMapper implements BlockMapper<TableBlock> {
  const TableMapper();

  @override
  String get supportedType => 'table';

  @override
  TableBlock fromJson(Map<String, dynamic> data) {
    final rawContent = (data['content'] as List<dynamic>?) ?? [];
    return TableBlock(
      withHeadings: (data['withHeadings'] as bool?) ?? false,
      content: rawContent.map((row) {
        final List<dynamic> rowList = row is List ? row : <dynamic>[];
        return rowList.map((cell) => cell.toString()).toList();
      }).toList(),
    );
  }
}
