import '../block_entity.dart';

class WarningBlock extends BlockEntity {
  final String title;
  final String message;

  const WarningBlock({required this.title, required this.message});

  @override
  String get type => 'warning';

  @override
  Map<String, dynamic> toJson() => {'title': title, 'message': message};
}
