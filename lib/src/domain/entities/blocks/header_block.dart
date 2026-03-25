import '../block_entity.dart';

class HeaderBlock extends BlockEntity {
  /// Text content of the heading (may contain inline HTML).
  final String text;

  /// Heading level: 1–6.
  final int level;

  const HeaderBlock({
    required this.text,
    required this.level,
  });

  @override
  String get type => 'header';

  @override
  Map<String, dynamic> toJson() => {
        'text': text,
        'level': level,
      };
}
