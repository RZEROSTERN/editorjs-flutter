import '../block_entity.dart';

class CodeBlock extends BlockEntity {
  /// Raw source code string.
  final String code;

  const CodeBlock({required this.code});

  @override
  String get type => 'code';

  @override
  Map<String, dynamic> toJson() => {'code': code};
}
