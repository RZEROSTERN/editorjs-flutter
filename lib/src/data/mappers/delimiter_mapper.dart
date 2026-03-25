import '../../domain/entities/blocks/delimiter_block.dart';
import 'block_mapper.dart';

class DelimiterMapper implements BlockMapper<DelimiterBlock> {
  const DelimiterMapper();

  @override
  String get supportedType => 'delimiter';

  @override
  DelimiterBlock fromJson(Map<String, dynamic> data) => const DelimiterBlock();
}
