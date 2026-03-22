import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>((ref) => BookingService());

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final bookingService = ref.watch(bookingServiceProvider);
  return await bookingService.getCategories();
});

final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);

final categoryDetailProvider = FutureProvider.family<CategoryModel?, int>((ref, id) async {
  final categories = await ref.watch(categoriesProvider.future);
  return categories.firstWhere((e) => e.id == id, orElse: () => throw Exception('Category not found'));
});
