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
      url: file != null && file['url'] is String ? file['url'] as String : '',
      name: file != null && file['name'] is String ? file['name'] as String : null,
      extension: file != null && file['extension'] is String
          ? file['extension'] as String
          : null,
      size: switch (file?['size']) {
        int v => v,
        num v => v.toInt(),
        _ => null,
      },
      title: data['title'] is String ? data['title'] as String : null,
    );
  }
}
