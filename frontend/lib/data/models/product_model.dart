class ProductModel {
  final String id;
  final String name;
  final String? brand;
  final String? description;
  final String? imageUrl;
  final String? category;
  final String? targetBreed;
  final String? targetAgeStage;
  final int? weightKg;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.brand,
    this.description,
    this.imageUrl,
    this.category,
    this.targetBreed,
    this.targetAgeStage,
    this.weightKg,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String?,
      targetBreed: json['target_breed'] as String?,
      targetAgeStage: json['target_age_stage'] as String?,
      weightKg: json['weight_kg'] as int?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'image_url': imageUrl,
      'category': category,
      'target_breed': targetBreed,
      'target_age_stage': targetAgeStage,
      'weight_kg': weightKg,
      'is_active': isActive,
    };
  }
}

