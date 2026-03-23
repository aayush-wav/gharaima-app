import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../models/provider_model.dart';
import 'booking_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final servicesProvider = FutureProvider.family<List<ServiceModel>, int?>((ref, categoryId) async {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final bookingService = ref.watch(bookingServiceProvider);
  final services = await bookingService.getServices(categoryId: categoryId);
  
  if (query.isEmpty) return services;
  return services.where((s) {
    final nameMatch = s.name.toLowerCase().contains(query);
    final descMatch = (s.description ?? '').toLowerCase().contains(query);
    return nameMatch || descMatch;
  }).toList();
});

final providersProvider = FutureProvider.family<List<ProviderModel>, int?>((ref, categoryId) async {
  final bookingService = ref.watch(bookingServiceProvider);
  return await bookingService.getProviders(categoryId: categoryId);
});

final serviceDetailProvider = FutureProvider.family<ServiceModel?, int>((ref, id) async {
  final bookingService = ref.watch(bookingServiceProvider);
  final services = await bookingService.getServices();
  return services.firstWhere((e) => e.id == id);
});
