import '../../domain/entities/blocks/attaches_block.dart';
import 'block_mapper.dart';

class AttachesMapper implements BlockMapper<AttachesBlock> {
  const AttachesMapper();

  @override
  String get supportedType => 'attaches';

  @override
  AttachesBlock fromJson(Map<String, dynamic> data) {
    final file = data['file'] as Map<String, dynamic>?;
    return AttachesBlock(
      url: (file?['url'] as String?) ?? '',
      name: file?['name'] as String?,
      extension: file?['extension'] as String?,
      size: file?['size'] as int?,
      title: data['title'] as String?,
    );
  }
}
