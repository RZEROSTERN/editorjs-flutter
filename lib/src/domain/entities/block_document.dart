import 'block_entity.dart';

class BlockDocument {
  final int time;
  final String version;
  final List<BlockEntity> blocks;

  const BlockDocument({
    required this.time,
    required this.version,
    required this.blocks,
  });

  Map<String, dynamic> toJson() => {
        'time': time,
        'version': version,
        'blocks': blocks
            .map((b) => {'type': b.type, 'data': b.toJson()})
            .toList(),
      };
}
