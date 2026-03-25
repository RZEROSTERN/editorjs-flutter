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
      items: rawItems.map(_parseItem).toList(),
    );
  }

  /// Handles both flat string items (standard @editorjs/list) and
  /// nested object items (@editorjs/nested-list).
  ListItem _parseItem(dynamic raw) {
    if (raw is String) {
      return ListItem(content: raw);
    }
    if (raw is Map<String, dynamic>) {
      final nestedRaw = (raw['items'] as List<dynamic>?) ?? [];
      return ListItem(
        content: (raw['content'] as String?) ?? '',
        items: nestedRaw.map(_parseItem).toList(),
      );
    }
    return ListItem(content: raw.toString());
  }
}
