import '../../domain/entities/blocks/header_block.dart';
import 'block_mapper.dart';

class HeaderMapper implements BlockMapper<HeaderBlock> {
  const HeaderMapper();

  @override
  String get supportedType => 'header';

  @override
  HeaderBlock fromJson(Map<String, dynamic> data) => HeaderBlock(
        text: (data['text'] as String?) ?? '',
        level: data['level'] is int ? data['level'] as int : 1,
      );
}
