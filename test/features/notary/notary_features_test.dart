import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/features/notary/data/models/notary_exception_model.dart';

void main() {
  group('NotaryExceptionModel Tests', () {
    test('fromJson parses notary exception payload correctly', () {
      final json = {
        'id': 12,
        'title_number': 'TN-9901',
        'owner_name': 'Samuel Jackson',
        'exception_reason': 'Boundary mismatch',
        'status': 'flagged',
        'validity_status': 'disputed',
        'has_exception': true,
      };

      final model = NotaryExceptionModel.fromJson(json);

      expect(model.id, 12);
      expect(model.titleNumber, 'TN-9901');
      expect(model.ownerName, 'Samuel Jackson');
      expect(model.exceptionReason, 'Boundary mismatch');
      expect(model.validityStatus, 'disputed');
      expect(model.hasException, true);
    });
  });
}
