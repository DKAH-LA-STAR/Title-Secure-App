class LandTitleModel {
  final int id;
  final String titleNumber;
  final String ownerName;
  final String validityStatus;
  final String? parcelId;
  final String? locationAddress;
  final String? qrHash;
  final double? areaSqm;
  final double? estimatedValue;
  final DateTime? issuedDate;
  final DateTime? createdAt;

  const LandTitleModel({
    required this.id,
    required this.titleNumber,
    required this.ownerName,
    required this.validityStatus,
    this.parcelId,
    this.locationAddress,
    this.qrHash,
    this.areaSqm,
    this.estimatedValue,
    this.issuedDate,
    this.createdAt,
  });

  factory LandTitleModel.fromJson(Map<String, dynamic> json) {
    return LandTitleModel(
      id: json['id'] as int,
      titleNumber: json['title_number'] as String,
      ownerName: json['owner_name'] as String,
      validityStatus: json['validity_status'] as String? ?? 'valid',
      parcelId: json['parcel_id'] as String?,
      locationAddress: json['location_address'] as String?,
      qrHash: json['qr_hash'] as String?,
      areaSqm: (json['area_sqm'] as num?)?.toDouble(),
      estimatedValue: (json['estimated_value'] as num?)?.toDouble(),
      issuedDate: json['issued_date'] != null
          ? DateTime.tryParse(json['issued_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title_number': titleNumber,
        'owner_name': ownerName,
        'validity_status': validityStatus,
        if (parcelId != null) 'parcel_id': parcelId,
        if (locationAddress != null) 'location_address': locationAddress,
        if (qrHash != null) 'qr_hash': qrHash,
        if (areaSqm != null) 'area_sqm': areaSqm,
        if (estimatedValue != null) 'estimated_value': estimatedValue,
        if (issuedDate != null) 'issued_date': issuedDate!.toIso8601String(),
      };
}
