import '../entities/block_document.dart';
import '../repositories/document_repository.dart';

class SerializeDocument {
  final DocumentRepository _repository;

  const SerializeDocument(this._repository);

  String call(BlockDocument document) => _repository.serialize(document);
}
