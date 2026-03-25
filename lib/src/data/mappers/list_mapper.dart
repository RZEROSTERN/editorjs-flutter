import '../../domain/entities/blocks/list_block.dart';
import 'block_mapper.dart';

class ListMapper implements BlockMapper<ListBlock> {
  const ListMapper();

  @override
  String get supportedType => 'list';

  @override
  ListBlock fromJson(Map<String, dynamic> data) {
    final styleStr = (data['style'] as String?) ?? 'unordered';
    final rawItems = (data['items'] as List<dynamic>?) ?? [];

    return ListBlock(
      style: styleStr == 'ordered' ? ListStyle.ordered : ListStyle.unordered,
      items: rawItems.map((e) => e.toString()).toList(),
    );
  }
}
