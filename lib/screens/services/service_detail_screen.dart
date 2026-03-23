import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../providers/services_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/provider_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_card.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final int serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceDetail = ref.watch(serviceDetailProvider(serviceId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: serviceDetail.when(
        data: (service) {
          if (service == null) return const Center(child: Text('Service not found'));
          final providers = ref.watch(providersProvider(service.categoryId));

          return OrbBackground(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroImage(isDark),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('LUXURY SERVICE', style: AppTextStyles.overline.copyWith(color: isDark ? AppColorsDark.primary : AppColors.primary)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Text(service.name, style: AppTextStyles.displayLarge)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(PriceFormatter.format(service.basePrice), style: AppTextStyles.priceLarge.copyWith(color: isDark ? AppColorsDark.primary : AppColors.primary)),
                                    Text(service.priceUnit, style: AppTextStyles.labelSmall.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                _buildBadge(HugeIcons.strokeRoundedClock01, '${service.durationMinutes ?? 0} mins', isDark),
                                const SizedBox(width: 12),
                                _buildBadge(HugeIcons.strokeRoundedStar, '4.8 (120+)', isDark),
                                const SizedBox(width: 12),
                                _buildBadge(HugeIcons.strokeRoundedSecurityCheck, 'Certified', isDark),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Text('The Experience', style: AppTextStyles.headingLarge),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              service.description ?? 'Our expert professionals deliver a high-end experience tailored to your specific needs, using premium tools and materials.',
                              style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary, height: 1.6),
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Text('What\'s Included', style: AppTextStyles.headingLarge),
                            const SizedBox(height: AppSpacing.md),
                            _buildInclusion('Professional concierge-level tools', isDark),
                            _buildInclusion('Premium environmental supplies', isDark),
                            _buildInclusion('Post-service luxury cleanup', isDark),
                            _buildInclusion('100% Satisfaction Guarantee', isDark),
                            const SizedBox(height: AppSpacing.xxl),
                            Text('Select Specialist', style: AppTextStyles.headingLarge),
                            const SizedBox(height: AppSpacing.md),
                            SizedBox(
                              height: 180,
                              child: providers.when(
                                data: (data) => ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) => ProviderCard(
                                    provider: data[index],
                                    onTap: () {
                                      ref.read(bookingFormProvider.notifier).update((state) => state.copyWith(selectedService: service, selectedProvider: data[index]));
                                      context.push('/home/booking');
                                    },
                                  ),
                                ),
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (e, _) => const Center(child: Text('Specialists currently busy.')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStickyBottomBar(context, service, isDark, ref),
                _buildBackButton(context, isDark),
              ],
            ),
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: ${e.toString()}'))),
      ),
    );
  }

  Widget _buildHeroImage(bool isDark) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.primarySurface : AppColors.primarySurface,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppRadius.xl), bottomRight: Radius.circular(AppRadius.xl)),
      ),
      child: Center(
        child: HugeIcon(icon: HugeIcons.strokeRoundedImage01, size: 80, color: (isDark ? AppColorsDark.primary : AppColors.primary).withOpacity(0.2)),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, bool isDark) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: primary.withOpacity(0.08), borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(icon: icon, color: primary, size: 14),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.labelSmall.copyWith(color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildInclusion(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle02, size: 20, color: isDark ? AppColorsDark.success : AppColors.success),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary))),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return Positioned(
      top: 48,
      left: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(2),
            color: (isDark ? AppColorsDark.glassFill : AppColors.glassFill),
            child: IconButton(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary, size: 24),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, service, bool isDark, WidgetRef ref) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: isDark ? AppColorsDark.glassFill : AppColors.glassFill,
              border: Border(top: BorderSide(color: isDark ? AppColorsDark.border : AppColors.border, width: 0.5)),
            ),
            child: CustomButton(
              text: 'Book this Service',
              onPressed: () {
                ref.read(bookingFormProvider.notifier).update((state) => state.copyWith(selectedService: service));
                context.push('/home/booking');
              },
            ),
          ),
        ),
      ),
    );
  }
}
