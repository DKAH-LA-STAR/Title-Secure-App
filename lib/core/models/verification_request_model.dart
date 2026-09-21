class PaymentModel {
  final int id;
  final double amount;
  final String currency;
  final String provider;
  final String transactionReference;
  final String status;
  final DateTime? createdAt;

  const PaymentModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.provider,
    required this.transactionReference,
    required this.status,
    this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'XAF',
      provider: json['provider'] as String,
      transactionReference: json['transaction_reference'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'currency': currency,
        'provider': provider,
        'transaction_reference': transactionReference,
        'status': status,
      };
}

class SubmittedDocumentModel {
  final int id;
  final String documentType;
  final String filePath;
  final String? status;

  const SubmittedDocumentModel({
    required this.id,
    required this.documentType,
    required this.filePath,
    this.status,
  });

  factory SubmittedDocumentModel.fromJson(Map<String, dynamic> json) {
    return SubmittedDocumentModel(
      id: json['id'] as int,
      documentType: json['document_type'] as String? ?? 'document',
      filePath: json['file_path'] as String? ?? '',
      status: json['status'] as String?,
    );
  }
}

class VerificationRequestModel {
  final int id;
  final String trackingCode;
  final String status;
  final String paymentStatus;
  final String? paymentRef;
  final List<SubmittedDocumentModel> submittedDocuments;
  final PaymentModel? payment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VerificationRequestModel({
    required this.id,
    required this.trackingCode,
    required this.status,
    required this.paymentStatus,
    this.paymentRef,
    this.submittedDocuments = const [],
    this.payment,
    this.createdAt,
    this.updatedAt,
  });

  factory VerificationRequestModel.fromJson(Map<String, dynamic> json) {
    final docs = (json['submitted_documents'] as List<dynamic>?)
            ?.map((d) =>
                SubmittedDocumentModel.fromJson(d as Map<String, dynamic>))
            .toList() ??
        [];
    return VerificationRequestModel(
      id: json['id'] as int,
      trackingCode: json['tracking_code'] as String,
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['payment_status'] as String? ?? 'unpaid',
      paymentRef: json['payment_ref'] as String?,
      submittedDocuments: docs,
      payment: json['payment'] != null
          ? PaymentModel.fromJson(json['payment'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }
}
