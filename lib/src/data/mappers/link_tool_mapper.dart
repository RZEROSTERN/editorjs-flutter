import '../../domain/entities/blocks/link_tool_block.dart';
import 'block_mapper.dart';

class LinkToolMapper implements BlockMapper<LinkToolBlock> {
  const LinkToolMapper();

  @override
  String get supportedType => 'linkTool';

  @override
  LinkToolBlock fromJson(Map<String, dynamic> data) {
    final rawMeta = data['meta'] as Map<String, dynamic>?;
    final rawImage = rawMeta?['image'] is Map ? rawMeta!['image'] as Map<String, dynamic> : null;

    final meta = rawMeta == null
        ? null
        : LinkToolMeta(
            title: rawMeta['title'] as String?,
            description: rawMeta['description'] as String?,
            imageUrl: rawImage?['url'] as String?,
          );

    return LinkToolBlock(
      link: (data['link'] as String?) ?? '',
      meta: meta,
    );
  }
}
