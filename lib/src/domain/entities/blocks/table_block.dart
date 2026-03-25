import '../block_entity.dart';

class TableBlock extends BlockEntity {
  /// Whether the first row is a header row.
  final bool withHeadings;

  /// 2-D list: content[row][column]. Each cell is plain text; any HTML will be rendered literally.
  final List<List<String>> content;

  const TableBlock({
    required this.content,
    this.withHeadings = false,
  });

  @override
  String get type => 'table';

  @override
  Map<String, dynamic> toJson() => {
        'withHeadings': withHeadings,
        'content': content,
      };
}
