import '../entities/block_document.dart';
import '../repositories/document_repository.dart';

class ParseDocument {
  final DocumentRepository _repository;

  const ParseDocument(this._repository);

  BlockDocument call(String jsonString) => _repository.parse(jsonString);
}
