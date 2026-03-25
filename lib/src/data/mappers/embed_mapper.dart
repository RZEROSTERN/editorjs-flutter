import '../../domain/entities/blocks/embed_block.dart';
import 'block_mapper.dart';

class EmbedMapper implements BlockMapper<EmbedBlock> {
  const EmbedMapper();

  @override
  String get supportedType => 'embed';

  @override
  EmbedBlock fromJson(Map<String, dynamic> data) => EmbedBlock(
        service: data['service'] is String ? data['service'] as String : '',
        source: data['source'] is String ? data['source'] as String : '',
        embed: data['embed'] is String ? data['embed'] as String : '',
        width: switch (data['width']) {
          int v => v,
          num v => v.toInt(),
          _ => null,
        },
        height: switch (data['height']) {
          int v => v,
          num v => v.toInt(),
          _ => null,
        },
        caption:
            data['caption'] is String ? data['caption'] as String : null,
      );
}
