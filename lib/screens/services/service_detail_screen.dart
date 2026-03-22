import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/services_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/provider_card.dart';
import '../../widgets/custom_button.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final int serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceDetail = ref.watch(serviceDetailProvider(serviceId));

    return Scaffold(
      body: serviceDetail.when(
        data: (service) {
          if (service == null) return const Center(child: Text('Service not found'));
          
          final providers = ref.watch(providersProvider(service.categoryId));

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Image Placeholder
                    Container(
                      height: 250,
                      width: double.infinity,
                      color: AppTheme.surface,
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 80, color: AppTheme.textSecondary),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(AppTheme.p24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(service.name, style: AppTheme.textTheme.displayLarge),
                              Text(
                                PriceFormatter.format(service.basePrice),
                                style: AppTheme.textTheme.displayMedium?.copyWith(color: AppTheme.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.p8),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: AppTheme.textSecondary),
                              const SizedBox(width: AppTheme.p4),
                              Text('${service.durationMinutes ?? 0} mins • ${service.priceUnit}', style: AppTheme.textTheme.bodySmall),
                            ],
                          ),
                          const SizedBox(height: AppTheme.p24),
                          
                          Text('What\'s included', style: AppTheme.textTheme.displaySmall),
                          const SizedBox(height: AppTheme.p12),
                          _buildInclusion('Professional equipment and tools'),
                          _buildInclusion('High-quality cleaning supplies'),
                          _buildInclusion('Post-service cleanup'),
                          
                          const SizedBox(height: AppTheme.p24),
                          
                          Text('Available providers', style: AppTheme.textTheme.displaySmall),
                          const SizedBox(height: AppTheme.p12),
                          SizedBox(
                            height: 160,
                            child: providers.when(
                              data: (data) => ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (context, index) => ProviderCard(
                                  provider: data[index],
                                  onTap: () {
                                    ref.read(bookingFormProvider.notifier).update((state) => state.copyWith(
                                      selectedService: service,
                                      selectedProvider: data[index],
                                    ));
                                    context.push('/home/booking');
                                  },
                                ),
                              ),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, _) => Center(child: Text('Error loading providers')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Sticky Book Now Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.p24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: CustomButton(
                    text: 'Book Now',
                    onPressed: () {
                      ref.read(bookingFormProvider.notifier).update((state) => state.copyWith(
                        selectedService: service,
                      ));
                      context.push('/home/booking');
                    },
                  ),
                ),
              ),
              
              // Back Button
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: ${e.toString()}'))),
      ),
    );
  }

  Widget _buildInclusion(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: AppTheme.success),
          const SizedBox(width: 8),
          Text(text, style: AppTheme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
