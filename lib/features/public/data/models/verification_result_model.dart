class VerificationResultModel {
  final String titleNumber;
  final String? qrHash;
  final String status; // valid, disputed, revoked, under_investigation
  final String ownerName;
  final String parcelReference;
  final String? location;
  final String? areaSize;
  final DateTime? issueDate;
  final Map<String, dynamic>? details;

  const VerificationResultModel({
    required this.titleNumber,
    this.qrHash,
    required this.status,
    required this.ownerName,
    required this.parcelReference,
    this.location,
    this.areaSize,
    this.issueDate,
    this.details,
  });

  factory VerificationResultModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : (json.containsKey('land_title') && json['land_title'] is Map<String, dynamic>
            ? json['land_title'] as Map<String, dynamic>
            : json);

    return VerificationResultModel(
      titleNumber: (data['title_number'] ?? data['titleNumber'] ?? 'N/A').toString(),
      qrHash: data['qr_hash']?.toString() ?? data['qrHash']?.toString(),
      status: (data['validity_status'] ?? data['status'] ?? 'under_investigation').toString().toLowerCase(),
      ownerName: (data['owner_name'] ?? data['ownerName'] ?? data['owner'] ?? 'N/A').toString(),
      parcelReference: (data['parcel_id'] ?? data['parcel_reference'] ?? data['parcelReference'] ?? data['parcel_ref'] ?? 'N/A').toString(),
      location: data['location_address']?.toString() ?? data['location']?.toString() ?? data['address']?.toString(),
      areaSize: data['area_sqm']?.toString() ?? data['area_size']?.toString() ?? data['area']?.toString(),
      issueDate: data['created_at'] != null || data['issue_date'] != null
          ? DateTime.tryParse((data['created_at'] ?? data['issue_date']).toString())
          : null,
      details: data['details'] is Map<String, dynamic> ? data['details'] as Map<String, dynamic> : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title_number': titleNumber,
      'qr_hash': qrHash,
      'status': status,
      'owner_name': ownerName,
      'parcel_reference': parcelReference,
      'location': location,
      'area_size': areaSize,
      'issue_date': issueDate?.toIso8601String(),
      'details': details,
    };
  }
}
