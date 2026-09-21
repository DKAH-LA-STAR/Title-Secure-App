class AdminStatsModel {
  final int totalTitles;
  final int totalRequests;
  final int totalExceptions;
  final int pendingVerifications;
  final int verifiedTitles;
  final int duplicateAlerts;

  const AdminStatsModel({
    this.totalTitles = 0,
    this.totalRequests = 0,
    this.totalExceptions = 0,
    this.pendingVerifications = 0,
    this.verifiedTitles = 0,
    this.duplicateAlerts = 0,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final requestsSummary = data['verification_requests_summary'] is Map<String, dynamic>
        ? data['verification_requests_summary'] as Map<String, dynamic>
        : null;
    final fraudMetrics = data['fraud_metrics'] is Map<String, dynamic>
        ? data['fraud_metrics'] as Map<String, dynamic>
        : null;

    final computedTotalRequests = requestsSummary?.values.fold<int>(
          0,
          (sum, v) => sum + (int.tryParse(v.toString()) ?? 0),
        ) ??
        0;

    return AdminStatsModel(
      totalTitles: int.tryParse(data['total_titles']?.toString() ?? '') ??
          (int.tryParse(fraudMetrics?['total_checks_run']?.toString() ?? '') ?? 0),
      totalRequests: int.tryParse(data['total_requests']?.toString() ?? '') ??
          computedTotalRequests,
      totalExceptions: int.tryParse(data['total_exceptions']?.toString() ?? '') ??
          (int.tryParse(fraudMetrics?['high_risk_flagged']?.toString() ?? '') ?? 0),
      pendingVerifications: int.tryParse(data['pending_verifications']?.toString() ?? '') ??
          (int.tryParse(requestsSummary?['pending']?.toString() ?? '') ?? 0),
      verifiedTitles: int.tryParse(data['verified_titles']?.toString() ?? '') ??
          (int.tryParse(requestsSummary?['verified']?.toString() ?? '') ?? 0),
      duplicateAlerts: int.tryParse(data['duplicate_alerts']?.toString() ?? '') ??
          (int.tryParse(fraudMetrics?['high_risk_flagged']?.toString() ?? '') ?? 0),
    );
  }
}

class DuplicateClaimModel {
  final int id;
  final String titleNumber;
  final String parcelReference;
  final String primaryOwner;
  final String conflictingOwner;
  final double confidenceScore;
  final String status;
  final DateTime? flaggedAt;

  const DuplicateClaimModel({
    required this.id,
    required this.titleNumber,
    required this.parcelReference,
    required this.primaryOwner,
    required this.conflictingOwner,
    required this.confidenceScore,
    required this.status,
    this.flaggedAt,
  });

  factory DuplicateClaimModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final landTitle = data['land_title'] is Map<String, dynamic>
        ? data['land_title'] as Map<String, dynamic>
        : null;
    final analysisDetails = data['analysis_details'] is Map<String, dynamic>
        ? data['analysis_details'] as Map<String, dynamic>
        : null;

    final titleNum = data['title_number']?.toString() ??
        data['titleNumber']?.toString() ??
        landTitle?['title_number']?.toString() ??
        'N/A';

    final parcel = data['parcel_reference']?.toString() ??
        data['parcelReference']?.toString() ??
        landTitle?['parcel_id']?.toString() ??
        landTitle?['location_address']?.toString() ??
        'N/A';

    final primary = data['primary_owner']?.toString() ??
        data['owner_a']?.toString() ??
        landTitle?['owner_name']?.toString() ??
        'Official Title Owner';

    final conflicting = data['conflicting_owner']?.toString() ??
        data['owner_b']?.toString() ??
        analysisDetails?['conflicting_claimant']?.toString() ??
        analysisDetails?['note']?.toString() ??
        'Duplicate / High-Risk Claimant';

    final riskScore = double.tryParse(
          data['risk_score']?.toString() ??
              data['confidence_score']?.toString() ??
              data['similarity']?.toString() ??
              '0.0',
        ) ??
        0.0;

    return DuplicateClaimModel(
      id: data['id'] is int ? data['id'] as int : int.parse((data['id'] ?? '0').toString()),
      titleNumber: titleNum,
      parcelReference: parcel,
      primaryOwner: primary,
      conflictingOwner: conflicting,
      confidenceScore: riskScore,
      status: (data['status'] ?? (data['is_duplicate'] == true ? 'duplicate' : 'high_risk')).toString().toLowerCase(),
      flaggedAt: data['flagged_at'] != null || data['created_at'] != null || data['checked_at'] != null
          ? DateTime.tryParse((data['flagged_at'] ?? data['checked_at'] ?? data['created_at']).toString())
          : null,
    );
  }
}
