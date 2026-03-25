import '../block_entity.dart';

enum ListStyle { ordered, unordered }

class ListItem {
  /// HTML content of this item.
  final String content;

  /// Nested child items (empty for flat lists).
  final List<ListItem> items;

  const ListItem({required this.content, this.items = const []});

  ListItem copyWith({String? content, List<ListItem>? items}) => ListItem(
        content: content ?? this.content,
        items: items ?? this.items,
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        'items': items.map((i) => i.toJson()).toList(),
      };
}

class ListBlock extends BlockEntity {
  final ListStyle style;
  final List<ListItem> items;

  const ListBlock({
    required this.style,
    required this.items,
  });

  @override
  String get type => 'list';

  @override
  Map<String, dynamic> toJson() => {
        'style': style == ListStyle.ordered ? 'ordered' : 'unordered',
        'items': items.map((i) => i.toJson()).toList(),
      };
}
