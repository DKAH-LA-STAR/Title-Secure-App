import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/features/client/data/models/client_request_model.dart';

void main() {
  group('ClientRequestModel Tests', () {
    test('fromJson parses tracking model and computes step index correctly', () {
      final json = {
        'id': 105,
        'tracking_code': 'TRK-2026-991',
        'status': 'verified',
        'title_number': 'TN-551',
        'owner_name': 'Alice Smith',
        'parcel_reference': 'PAR-88',
      };

      final model = ClientRequestModel.fromJson(json);

      expect(model.id, 105);
      expect(model.trackingCode, 'TRK-2026-991');
      expect(model.status, 'verified');
      expect(model.currentStepIndex, 4); // verified step index
    });

    test('currentStepIndex returns correct timeline index for processing status', () {
      final json = {
        'id': 106,
        'tracking_code': 'TRK-2026-992',
        'status': 'processing',
      };

      final model = ClientRequestModel.fromJson(json);
      expect(model.currentStepIndex, 1);
    });
  });
}
