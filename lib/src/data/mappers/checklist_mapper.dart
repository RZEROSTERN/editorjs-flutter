import '../../domain/entities/blocks/checklist_block.dart';
import 'block_mapper.dart';

class ChecklistMapper implements BlockMapper<ChecklistBlock> {
  const ChecklistMapper();

  @override
  String get supportedType => 'checklist';

  @override
  ChecklistBlock fromJson(Map<String, dynamic> data) {
    final rawItems =
        data['items'] is List ? data['items'] as List<dynamic> : <dynamic>[];
    return ChecklistBlock(
      items: rawItems.whereType<Map<String, dynamic>>().map((i) {
        return ChecklistItem(
          text: i['text'] is String ? i['text'] as String : '',
          checked: i['checked'] is bool ? i['checked'] as bool : false,
        );
      }).toList(),
    );
  }
}
