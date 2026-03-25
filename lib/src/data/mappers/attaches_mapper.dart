import '../../domain/entities/blocks/attaches_block.dart';
import 'block_mapper.dart';

class AttachesMapper implements BlockMapper<AttachesBlock> {
  const AttachesMapper();

  @override
  String get supportedType => 'attaches';

  @override
  AttachesBlock fromJson(Map<String, dynamic> data) {
    final file = data['file'] is Map ? data['file'] as Map<String, dynamic> : null;
    return AttachesBlock(
      url: (file?['url'] as String?) ?? '',
      name: file?['name'] as String?,
      extension: file?['extension'] as String?,
      size: switch (file?['size']) {
        int v => v,
        num v => v.toInt(),
        _ => null,
      },
      title: data['title'] as String?,
    );
  }
}
