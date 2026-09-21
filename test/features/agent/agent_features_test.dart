import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/features/agent/data/models/extraction_model.dart';

void main() {
  group('ExtractionModel Tests', () {
    test('fromJson parses agent extraction item correctly', () {
      final json = {
        'id': 42,
        'title_number': 'TN-771',
        'owner_name': 'Robert Martin',
        'status': 'extracted',
        'has_exception': true,
        'exception_reason': 'Unclear signature scan',
        'raw_text': 'EXTRACTED LAND DEED TEXT CONTENT',
      };

      final model = ExtractionModel.fromJson(json);

      expect(model.id, 42);
      expect(model.titleNumber, 'TN-771');
      expect(model.status, 'extracted');
      expect(model.hasException, true);
      expect(model.exceptionReason, 'Unclear signature scan');
      expect(model.rawText, 'EXTRACTED LAND DEED TEXT CONTENT');
    });
  });
}
