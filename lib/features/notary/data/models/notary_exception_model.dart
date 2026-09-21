class NotaryExceptionModel {
  final int id;
  final String? titleNumber;
  final String? ownerName;
  final String? parcelReference;
  final String exceptionReason;
  final String status;
  final String validityStatus;
  final bool hasException;
  final String? rawOcrText;
  final DateTime? createdAt;

  const NotaryExceptionModel({
    required this.id,
    this.titleNumber,
    this.ownerName,
    this.parcelReference,
    required this.exceptionReason,
    required this.status,
    required this.validityStatus,
    required this.hasException,
    this.rawOcrText,
    this.createdAt,
  });

  factory NotaryExceptionModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final entities = data['extracted_entities'] is Map<String, dynamic>
        ? data['extracted_entities'] as Map<String, dynamic>
        : null;

    return NotaryExceptionModel(
      id: data['id'] is int ? data['id'] as int : int.parse((data['id'] ?? '0').toString()),
      titleNumber: data['title_number']?.toString() ?? data['titleNumber']?.toString() ?? entities?['title_number']?.toString(),
      ownerName: data['owner_name']?.toString() ?? data['ownerName']?.toString() ?? entities?['owner_name']?.toString(),
      parcelReference: data['parcel_reference']?.toString() ?? data['parcelReference']?.toString() ?? entities?['parcel_reference']?.toString(),
      exceptionReason: (data['exception_reason'] ?? data['reason'] ?? data['exception'] ?? 'OCR anomaly detected').toString(),
      status: (data['status'] ?? 'flagged').toString().toLowerCase(),
      validityStatus: (data['validity_status'] ?? data['validity'] ?? 'under_investigation').toString().toLowerCase(),
      hasException: data['has_exception'] == true || data['has_exception'] == 1 || data['has_exception'] == 'true',
      rawOcrText: data['raw_ocr_text']?.toString() ?? data['raw_text']?.toString(),
      createdAt: data['created_at'] != null ? DateTime.tryParse(data['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_number': titleNumber,
      'owner_name': ownerName,
      'parcel_reference': parcelReference,
      'exception_reason': exceptionReason,
      'status': status,
      'validity_status': validityStatus,
      'has_exception': hasException,
      'raw_ocr_text': rawOcrText,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
