import '../block_entity.dart';

/// Raw HTML block. Content is sanitized before rendering.
class RawBlock extends BlockEntity {
  final String html;

  const RawBlock({required this.html});

  @override
  String get type => 'raw';

  @override
  Map<String, dynamic> toJson() => {'html': html};
}
