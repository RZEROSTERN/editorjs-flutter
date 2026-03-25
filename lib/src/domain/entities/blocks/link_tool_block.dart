import '../block_entity.dart';

class LinkToolMeta {
  final String? title;
  final String? description;
  final String? imageUrl;

  const LinkToolMeta({this.title, this.description, this.imageUrl});

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'image': {'url': imageUrl},
      };
}

class LinkToolBlock extends BlockEntity {
  final String link;
  final LinkToolMeta? meta;

  const LinkToolBlock({required this.link, this.meta});

  @override
  String get type => 'linkTool';

  @override
  Map<String, dynamic> toJson() => {
        'link': link,
        if (meta != null) 'meta': meta!.toJson(),
      };
}
