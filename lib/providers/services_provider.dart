import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../models/provider_model.dart';
import 'categories_provider.dart';

final servicesProvider = FutureProvider.family<List<ServiceModel>, int?>((ref, categoryId) async {
  final bookingService = ref.watch(bookingServiceProvider);
  return await bookingService.getServices(categoryId: categoryId);
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
