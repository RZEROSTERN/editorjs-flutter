import '../../domain/entities/blocks/embed_block.dart';
import 'block_mapper.dart';

class EmbedMapper implements BlockMapper<EmbedBlock> {
  const EmbedMapper();

  @override
  String get supportedType => 'embed';

  @override
  EmbedBlock fromJson(Map<String, dynamic> data) => EmbedBlock(
        service: (data['service'] as String?) ?? '',
        source: (data['source'] as String?) ?? '',
        embed: (data['embed'] as String?) ?? '',
        width: data['width'] as int?,
        height: data['height'] as int?,
        caption: data['caption'] as String?,
      );
}
