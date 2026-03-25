import 'dart:convert';

import '../../domain/entities/block_document.dart';
import '../../domain/entities/block_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../registry/block_type_registry.dart';

/// Implements [DocumentRepository] using EditorJS JSON as the serialization format.
class JsonDocumentSource implements DocumentRepository {
  final BlockTypeRegistry registry;

  const JsonDocumentSource({required this.registry});

  @override
  BlockDocument parse(String jsonString) {
    final Map<String, dynamic> root = jsonDecode(jsonString) as Map<String, dynamic>;
    final rawBlocks = (root['blocks'] as List<dynamic>?) ?? [];

    final blocks = rawBlocks
        .whereType<Map<String, dynamic>>()
        .map((b) {
          final type = (b['type'] as String?) ?? '';
          final data = (b['data'] as Map<String, dynamic>?) ?? {};
          return registry.parse(type, data);
        })
        .whereType<BlockEntity>()
        .toList();

    return BlockDocument(
      time: (root['time'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      version: (root['version'] as String?) ?? '',
      blocks: blocks,
    );
  }

  @override
  String serialize(BlockDocument document) => jsonEncode(document.toJson());
}
