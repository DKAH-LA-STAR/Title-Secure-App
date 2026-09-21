import 'package:flutter_test/flutter_test.dart';
import 'package:title_secure/features/admin/data/models/admin_models.dart';

void main() {
  group('Admin Models Tests', () {
    test('AdminStatsModel.fromJson parses report statistics payload correctly', () {
      final json = {
        'total_titles': '1250',
        'total_requests': '450',
        'total_exceptions': '15',
        'pending_verifications': '30',
        'verified_titles': '1205',
        'duplicate_alerts': '3',
      };

      final stats = AdminStatsModel.fromJson(json);

      expect(stats.totalTitles, 1250);
      expect(stats.totalRequests, 450);
      expect(stats.totalExceptions, 15);
      expect(stats.pendingVerifications, 30);
      expect(stats.verifiedTitles, 1205);
      expect(stats.duplicateAlerts, 3);
    });

    test('DuplicateClaimModel.fromJson parses duplicate claim alert correctly', () {
      final json = {
        'id': 7,
        'title_number': 'TN-332',
        'parcel_reference': 'SEC-A-10',
        'primary_owner': 'Alice',
        'conflicting_owner': 'Bob',
        'confidence_score': 0.95,
        'status': 'flagged',
      };

      final claim = DuplicateClaimModel.fromJson(json);

      expect(claim.id, 7);
      expect(claim.titleNumber, 'TN-332');
      expect(claim.parcelReference, 'SEC-A-10');
      expect(claim.primaryOwner, 'Alice');
      expect(claim.conflictingOwner, 'Bob');
      expect(claim.confidenceScore, 0.95);
      expect(claim.status, 'flagged');
    });
  });
}
