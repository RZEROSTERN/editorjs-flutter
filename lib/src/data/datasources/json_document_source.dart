import 'dart:convert';
import 'dart:developer' as dev;

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
    late final Map<String, dynamic> root;
    try {
      root = jsonDecode(jsonString) as Map<String, dynamic>;
    } on FormatException catch (_) {
      return BlockDocument(
        time: DateTime.now().millisecondsSinceEpoch,
        version: '',
        blocks: const [],
      );
    } on TypeError catch (_) {
      return BlockDocument(
        time: DateTime.now().millisecondsSinceEpoch,
        version: '',
        blocks: const [],
      );
    }

    final rawBlocks =
        root['blocks'] is List ? root['blocks'] as List<dynamic> : <dynamic>[];

    final blocks = rawBlocks
        .whereType<Map<String, dynamic>>()
        .map((b) {
          final type = b['type'] is String ? b['type'] as String : '';
          final data = b['data'] is Map<String, dynamic>
              ? b['data'] as Map<String, dynamic>
              : <String, dynamic>{};
          final entity = registry.parse(type, data);
          if (entity == null && type.isNotEmpty) {
            dev.log(
              'Unknown block type ignored: "$type"',
              name: 'EditorJSFlutter',
            );
          }
          return entity;
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
