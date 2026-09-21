import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/features/public/data/models/verification_result_model.dart';

void main() {
  group('VerificationResultModel Tests', () {
    test('fromJson parses standard valid JSON correctly', () {
      final json = {
        'title_number': 'TN-1002',
        'status': 'valid',
        'owner_name': 'John Doe',
        'parcel_reference': 'PARCEL-12',
        'location': 'Douala',
        'area_size': '500 sqm',
        'qr_hash': 'hash_xyz',
      };

      final model = VerificationResultModel.fromJson(json);

      expect(model.titleNumber, 'TN-1002');
      expect(model.status, 'valid');
      expect(model.ownerName, 'John Doe');
      expect(model.parcelReference, 'PARCEL-12');
      expect(model.location, 'Douala');
      expect(model.areaSize, '500 sqm');
      expect(model.qrHash, 'hash_xyz');
    });
  });
}
