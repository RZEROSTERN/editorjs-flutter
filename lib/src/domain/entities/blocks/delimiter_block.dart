import '../block_entity.dart';

class DelimiterBlock extends BlockEntity {
  const DelimiterBlock();

  @override
  String get type => 'delimiter';

  @override
  Map<String, dynamic> toJson() => {};
}
