class PetModel {
  final String id;
  final String userId;
  final String breedCode;
  final String weightBucket;
  final String ageStage;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  PetModel({
    required this.id,
    required this.userId,
    required this.breedCode,
    required this.weightBucket,
    required this.ageStage,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      breedCode: json['breed_code'] as String,
      weightBucket: json['weight_bucket'] as String,
      ageStage: json['age_stage'] as String,
      isPrimary: json['is_primary'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breed_code': breedCode,
      'weight_bucket': weightBucket,
      'age_stage': ageStage,
      'is_primary': isPrimary,
    };
  }
}

