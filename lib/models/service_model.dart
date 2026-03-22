class ServiceModel {
  final int id;
  final int categoryId;
  final String name;
  final String? description;
  final double basePrice;
  final String priceUnit;
  final int? durationMinutes;
  final String? imageUrl;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.basePrice,
    this.priceUnit = 'per visit',
    this.durationMinutes,
    this.imageUrl,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      basePrice: (json['base_price'] as num).toDouble(),
      priceUnit: json['price_unit'] ?? 'per visit',
      durationMinutes: json['duration_minutes'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'price_unit': priceUnit,
      'duration_minutes': durationMinutes,
      'image_url': imageUrl,
    };
  }
}
