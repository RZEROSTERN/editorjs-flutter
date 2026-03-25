import '../../domain/entities/blocks/quote_block.dart';
import 'block_mapper.dart';

class QuoteMapper implements BlockMapper<QuoteBlock> {
  const QuoteMapper();

  @override
  String get supportedType => 'quote';

  @override
  QuoteBlock fromJson(Map<String, dynamic> data) {
    final alignStr = (data['alignment'] as String?) ?? 'left';
    return QuoteBlock(
      text: (data['text'] as String?) ?? '',
      caption: data['caption'] as String?,
      alignment: QuoteAlignment.values.firstWhere(
        (a) => a.name == alignStr,
        orElse: () => QuoteAlignment.left,
      ),
    );
  }
}
