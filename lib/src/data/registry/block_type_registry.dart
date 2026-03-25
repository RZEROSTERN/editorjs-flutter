import '../../domain/entities/block_entity.dart';
import '../mappers/block_mapper.dart';
import '../mappers/checklist_mapper.dart';
import '../mappers/code_mapper.dart';
import '../mappers/delimiter_mapper.dart';
import '../mappers/header_mapper.dart';
import '../mappers/image_mapper.dart';
import '../mappers/list_mapper.dart';
import '../mappers/paragraph_mapper.dart';
import '../mappers/quote_mapper.dart';
import '../mappers/table_mapper.dart';
import '../mappers/warning_mapper.dart';

/// Maps EditorJS block type strings to their [BlockMapper] implementations.
///
/// Built-in block types are pre-registered. Call [register] to add support
/// for custom block types without modifying any core package file.
class BlockTypeRegistry {
  final Map<String, BlockMapper> _mappers = {};

  BlockTypeRegistry() {
    register(const HeaderMapper());
    register(const ParagraphMapper());
    register(const ListMapper());
    register(const DelimiterMapper());
    register(const ImageMapper());
    register(const QuoteMapper());
    register(const CodeMapper());
    register(const ChecklistMapper());
    register(const TableMapper());
    register(const WarningMapper());
  }

  /// Registers a [BlockMapper]. Overwrites any existing mapper for the same type.
  void register(BlockMapper mapper) {
    _mappers[mapper.supportedType] = mapper;
  }

  /// Returns the deserialized entity, or `null` if the type is unknown.
  /// Callers decide how to handle `null` — the registry never throws.
  BlockEntity? parse(String type, Map<String, dynamic> data) {
    return _mappers[type]?.fromJson(data);
  }

  bool supports(String type) => _mappers.containsKey(type);
}
