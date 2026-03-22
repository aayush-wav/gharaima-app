class BookingModel {
  final String id;
  final String customerId;
  final String? providerId;
  final int serviceId;
  final String status;
  final DateTime scheduledAt;
  final String address;
  final double? latitude;
  final double? longitude;
  final double? totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final String? notes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.customerId,
    this.providerId,
    required this.serviceId,
    required this.status,
    required this.scheduledAt,
    required this.address,
    this.latitude,
    this.longitude,
    this.totalPrice,
    this.paymentMethod = 'cash',
    this.paymentStatus = 'unpaid',
    this.notes,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      customerId: json['customer_id'],
      providerId: json['provider_id'],
      serviceId: json['service_id'],
      status: json['status'],
      scheduledAt: DateTime.parse(json['scheduled_at']),
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      paymentMethod: json['payment_method'] ?? 'cash',
      paymentStatus: json['payment_status'] ?? 'unpaid',
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'provider_id': providerId,
      'service_id': serviceId,
      'status': status,
      'scheduled_at': scheduledAt.toIso8601String(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_price': totalPrice,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
