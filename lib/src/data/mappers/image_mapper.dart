import '../../domain/entities/blocks/image_block.dart';
import 'block_mapper.dart';

class ImageMapper implements BlockMapper<ImageBlock> {
  const ImageMapper();

  @override
  String get supportedType => 'image';

  @override
  ImageBlock fromJson(Map<String, dynamic> data) {
    final file = data['file'] as Map<String, dynamic>?;
    return ImageBlock(
      url: (file?['url'] as String?) ?? '',
      caption: data['caption'] as String?,
      withBorder: (data['withBorder'] as bool?) ?? false,
      stretched: (data['stretched'] as bool?) ?? false,
      withBackground: (data['withBackground'] as bool?) ?? false,
    );
  }
}
