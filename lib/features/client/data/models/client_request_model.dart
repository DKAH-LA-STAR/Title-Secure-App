class ClientRequestModel {
  final int id;
  final String trackingCode;
  final String? titleNumber;
  final String? ownerName;
  final String? parcelReference;
  final String? location;
  final String status;
  final String? documentUrl;
  final String? certificateUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClientRequestModel({
    required this.id,
    required this.trackingCode,
    this.titleNumber,
    this.ownerName,
    this.parcelReference,
    this.location,
    required this.status,
    this.documentUrl,
    this.certificateUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ClientRequestModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : (json.containsKey('request') && json['request'] is Map<String, dynamic>
            ? json['request'] as Map<String, dynamic>
            : json);

    return ClientRequestModel(
      id: data['id'] is int ? data['id'] as int : int.parse((data['id'] ?? '0').toString()),
      trackingCode: (data['tracking_code'] ?? data['trackingCode'] ?? 'N/A').toString(),
      titleNumber: data['title_number']?.toString() ?? data['titleNumber']?.toString(),
      ownerName: data['owner_name']?.toString() ?? data['ownerName']?.toString(),
      parcelReference: data['parcel_reference']?.toString() ?? data['parcelReference']?.toString(),
      location: data['location']?.toString(),
      status: (data['status'] ?? 'pending').toString().toLowerCase(),
      documentUrl: data['document_path']?.toString() ?? data['document_url']?.toString(),
      certificateUrl: data['certificate_url']?.toString(),
      createdAt: data['created_at'] != null ? DateTime.tryParse(data['created_at'].toString()) : null,
      updatedAt: data['updated_at'] != null ? DateTime.tryParse(data['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracking_code': trackingCode,
      'title_number': titleNumber,
      'owner_name': ownerName,
      'parcel_reference': parcelReference,
      'location': location,
      'status': status,
      'document_path': documentUrl,
      'certificate_url': certificateUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  int get currentStepIndex {
    switch (status) {
      case 'pending':
        return 0;
      case 'processing':
        return 1;
      case 'extracted':
        return 2;
      case 'in_review':
        return 3;
      case 'verified':
        return 4;
      default:
        return 0;
    }
  }
}
