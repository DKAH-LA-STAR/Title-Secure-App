class ExtractionModel {
  final int id;
  final String? titleNumber;
  final String? ownerName;
  final String? rawText;
  final String status;
  final bool hasException;
  final String? exceptionReason;
  final String? documentPath;
  final DateTime? createdAt;

  const ExtractionModel({
    required this.id,
    this.titleNumber,
    this.ownerName,
    this.rawText,
    required this.status,
    required this.hasException,
    this.exceptionReason,
    this.documentPath,
    this.createdAt,
  });

  factory ExtractionModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : (json.containsKey('extraction') && json['extraction'] is Map<String, dynamic>
            ? json['extraction'] as Map<String, dynamic>
            : json);

    return ExtractionModel(
      id: data['id'] is int ? data['id'] as int : int.parse((data['id'] ?? '0').toString()),
      titleNumber: data['title_number']?.toString() ?? data['titleNumber']?.toString(),
      ownerName: data['owner_name']?.toString() ?? data['ownerName']?.toString(),
      rawText: data['raw_text']?.toString() ?? data['ocr_text']?.toString(),
      status: (data['status'] ?? 'pending').toString().toLowerCase(),
      hasException: data['has_exception'] == true || data['has_exception'] == 1 || data['has_exception'] == 'true',
      exceptionReason: data['exception_reason']?.toString() ?? data['exception']?.toString(),
      documentPath: data['document_path']?.toString() ?? data['document_url']?.toString(),
      createdAt: data['created_at'] != null ? DateTime.tryParse(data['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_number': titleNumber,
      'owner_name': ownerName,
      'raw_text': rawText,
      'status': status,
      'has_exception': hasException,
      'exception_reason': exceptionReason,
      'document_path': documentPath,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
