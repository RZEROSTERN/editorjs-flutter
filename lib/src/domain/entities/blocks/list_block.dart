import '../block_entity.dart';

enum ListStyle { ordered, unordered }

class ListBlock extends BlockEntity {
  final ListStyle style;

  /// Flat list of items. Each item may contain inline HTML.
  final List<String> items;

  const ListBlock({
    required this.style,
    required this.items,
  });

  @override
  String get type => 'list';

  @override
  Map<String, dynamic> toJson() => {
        'style': style == ListStyle.ordered ? 'ordered' : 'unordered',
        'items': items,
      };
}
