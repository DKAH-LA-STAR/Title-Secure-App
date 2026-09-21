class ExtractionModel {
  final int id;
  final double confidenceScore;
  final bool hasException;
  final Map<String, dynamic> extractedEntities;
  final String? rawText;
  final String? status;
  final int? titleId;
  final DateTime? createdAt;

  const ExtractionModel({
    required this.id,
    required this.confidenceScore,
    required this.hasException,
    required this.extractedEntities,
    this.rawText,
    this.status,
    this.titleId,
    this.createdAt,
  });

  factory ExtractionModel.fromJson(Map<String, dynamic> json) {
    return ExtractionModel(
      id: json['id'] as int,
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.0,
      hasException: json['has_exception'] as bool? ?? false,
      extractedEntities:
          (json['extracted_entities'] as Map<String, dynamic>?) ?? {},
      rawText: json['raw_text'] as String?,
      status: json['status'] as String?,
      titleId: json['title_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}

class FraudCheckModel {
  final int id;
  final double riskScore;
  final bool isDuplicate;
  final Map<String, dynamic> analysisDetails;
  final String? checkedEntityType;
  final int? checkedEntityId;
  final DateTime? createdAt;

  const FraudCheckModel({
    required this.id,
    required this.riskScore,
    required this.isDuplicate,
    required this.analysisDetails,
    this.checkedEntityType,
    this.checkedEntityId,
    this.createdAt,
  });

  factory FraudCheckModel.fromJson(Map<String, dynamic> json) {
    return FraudCheckModel(
      id: json['id'] as int,
      riskScore: (json['risk_score'] as num?)?.toDouble() ?? 0.0,
      isDuplicate: json['is_duplicate'] as bool? ?? false,
      analysisDetails:
          (json['analysis_details'] as Map<String, dynamic>?) ?? {},
      checkedEntityType: json['checked_entity_type'] as String?,
      checkedEntityId: json['checked_entity_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }
}
