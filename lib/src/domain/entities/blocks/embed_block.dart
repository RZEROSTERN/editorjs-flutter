import '../block_entity.dart';

class EmbedBlock extends BlockEntity {
  /// The service name (e.g. 'youtube', 'vimeo', 'codepen').
  final String service;

  /// Original source URL as entered by the user.
  final String source;

  /// Embed URL (typically an iframe src). Not used for rendering in Flutter,
  /// but preserved for round-trip JSON serialization.
  final String embed;

  final int? width;
  final int? height;
  final String? caption;

  const EmbedBlock({
    required this.service,
    required this.source,
    required this.embed,
    this.width,
    this.height,
    this.caption,
  });

  @override
  String get type => 'embed';

  @override
  Map<String, dynamic> toJson() => {
        'service': service,
        'source': source,
        'embed': embed,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        'caption': caption ?? '',
      };
}
