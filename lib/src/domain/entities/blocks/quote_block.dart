import '../block_entity.dart';

enum QuoteAlignment { left, center, right }

class QuoteBlock extends BlockEntity {
  /// HTML content of the quote body.
  final String text;

  /// Optional attribution / caption.
  final String? caption;

  final QuoteAlignment alignment;

  const QuoteBlock({
    required this.text,
    this.caption,
    this.alignment = QuoteAlignment.left,
  });

  @override
  String get type => 'quote';

  @override
  Map<String, dynamic> toJson() => {
        'text': text,
        'caption': caption ?? '',
        'alignment': alignment.name,
      };
}
