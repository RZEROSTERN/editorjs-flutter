import '../block_entity.dart';

class AttachesBlock extends BlockEntity {
  final String url;
  final String? name;
  final String? extension;

  /// File size in bytes. Null if not provided.
  final int? size;

  final String? title;

  const AttachesBlock({
    required this.url,
    this.name,
    this.extension,
    this.size,
    this.title,
  });

  @override
  String get type => 'attaches';

  @override
  Map<String, dynamic> toJson() => {
        'file': {
          'url': url,
          if (name != null) 'name': name,
          if (extension != null) 'extension': extension,
          if (size != null) 'size': size,
        },
        'title': title ?? '',
      };
}
