import '../block_entity.dart';

class ChecklistItem {
  final String text;
  final bool checked;

  const ChecklistItem({required this.text, this.checked = false});

  ChecklistItem copyWith({String? text, bool? checked}) => ChecklistItem(
        text: text ?? this.text,
        checked: checked ?? this.checked,
      );

  Map<String, dynamic> toJson() => {'text': text, 'checked': checked};
}

class ChecklistBlock extends BlockEntity {
  final List<ChecklistItem> items;

  const ChecklistBlock({required this.items});

  @override
  String get type => 'checklist';

  @override
  Map<String, dynamic> toJson() => {
        'items': items.map((i) => i.toJson()).toList(),
      };
}
