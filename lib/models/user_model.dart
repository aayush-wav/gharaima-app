class UserModel {
  final String id;
  final String phone;
  final String? fullName;
  final String? profilePhotoUrl;
  final String? defaultAddress;
  final double? defaultLatitude;
  final double? defaultLongitude;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.phone,
    this.fullName,
    this.profilePhotoUrl,
    this.defaultAddress,
    this.defaultLatitude,
    this.defaultLongitude,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      fullName: json['full_name'],
      profilePhotoUrl: json['profile_photo_url'],
      defaultAddress: json['default_address'],
      defaultLatitude: json['default_latitude']?.toDouble(),
      defaultLongitude: json['default_longitude']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'default_address': defaultAddress,
      'default_latitude': defaultLatitude,
      'default_longitude': defaultLongitude,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
