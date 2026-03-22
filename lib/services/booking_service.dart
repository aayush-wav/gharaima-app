import '../models/booking_model.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../models/provider_model.dart';
import '../models/review_model.dart';
import 'supabase_service.dart';

class BookingService {
  final _client = SupabaseService().client;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.from('categories').select();
    return (response as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<List<ServiceModel>> getServices({int? categoryId}) async {
    var query = _client.from('services').select();
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    final response = await query;
    return (response as List).map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<List<ProviderModel>> getProviders({int? categoryId}) async {
    var query = _client.from('providers').select();
    if (categoryId != null) {
      // Postgres array contains categoryId
      query = query.filter('category_ids', 'cs', '{$categoryId}');
    }
    final response = await query;
    return (response as List).map((e) => ProviderModel.fromJson(e)).toList();
  }

  Future<void> createBooking(BookingModel booking) async {
    await _client.from('bookings').insert(booking.toJson());
  }

  Future<List<BookingModel>> getMyBookings(String customerId, {String? status}) async {
    var query = _client.from('bookings').select().eq('customer_id', customerId);
    if (status != null) {
      query = query.eq('status', status);
    }
    final response = await query.order('created_at', ascending: false);
    return (response as List).map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _client.from('bookings').update({'status': status}).eq('id', bookingId);
  }

  Future<void> submitReview(ReviewModel review) async {
    await _client.from('reviews').insert(review.toJson());
  }

  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    final response = await _client.from('reviews').select().eq('provider_id', providerId);
    return (response as List).map((e) => ReviewModel.fromJson(e)).toList();
  }
}
