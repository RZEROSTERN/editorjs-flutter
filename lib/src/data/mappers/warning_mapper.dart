import '../../domain/entities/blocks/warning_block.dart';
import 'block_mapper.dart';

class WarningMapper implements BlockMapper<WarningBlock> {
  const WarningMapper();

  @override
  String get supportedType => 'warning';

  @override
  WarningBlock fromJson(Map<String, dynamic> data) => WarningBlock(
        title: (data['title'] as String?) ?? '',
        message: (data['message'] as String?) ?? '',
      );
}
