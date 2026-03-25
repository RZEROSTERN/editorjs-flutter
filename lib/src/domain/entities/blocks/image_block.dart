import '../block_entity.dart';

class ImageBlock extends BlockEntity {
  final String url;
  final String? caption;
  final bool withBorder;
  final bool stretched;
  final bool withBackground;

  const ImageBlock({
    required this.url,
    this.caption,
    this.withBorder = false,
    this.stretched = false,
    this.withBackground = false,
  });

  @override
  String get type => 'image';

  @override
  Map<String, dynamic> toJson() => {
        'file': {'url': url},
        'caption': caption ?? '',
        'withBorder': withBorder,
        'stretched': stretched,
        'withBackground': withBackground,
      };
}
