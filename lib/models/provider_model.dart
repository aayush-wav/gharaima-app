class ProviderModel {
  final String id;
  final String fullName;
  final String? phone;
  final String? profilePhotoUrl;
  final String? bio;
  final List<int>? categoryIds;
  final double rating;
  final int totalReviews;
  final bool isAvailable;
  final double? latitude;
  final double? longitude;

  ProviderModel({
    required this.id,
    required this.fullName,
    this.phone,
    this.profilePhotoUrl,
    this.bio,
    this.categoryIds,
    this.rating = 0,
    this.totalReviews = 0,
    this.isAvailable = true,
    this.latitude,
    this.longitude,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'],
      fullName: json['full_name'],
      phone: json['phone'],
      profilePhotoUrl: json['profile_photo_url'],
      bio: json['bio'],
      categoryIds: (json['category_ids'] as List?)?.map((e) => e as int).toList(),
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'profile_photo_url': profilePhotoUrl,
      'bio': bio,
      'category_ids': categoryIds,
      'rating': rating,
      'total_reviews': totalReviews,
      'is_available': isAvailable,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
