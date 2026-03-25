import '../../domain/entities/blocks/paragraph_block.dart';
import 'block_mapper.dart';

class ParagraphMapper implements BlockMapper<ParagraphBlock> {
  const ParagraphMapper();

  @override
  String get supportedType => 'paragraph';

  @override
  ParagraphBlock fromJson(Map<String, dynamic> data) => ParagraphBlock(
        html: (data['text'] as String?) ?? '',
      );
}
