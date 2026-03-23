import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../providers/categories_provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/category_card.dart';
import '../../widgets/service_card.dart';
import '../../providers/location_provider.dart';
import '../../widgets/glass_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _pageController = PageController();
  final _searchController = TextEditingController();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _showLocationDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColorsDark.surfaceElevated : AppColors.surfaceElevated,
        title: Text('Set Location', style: AppTextStyles.headingLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: HugeIcon(icon: HugeIcons.strokeRoundedLocation01, color: isDark ? AppColorsDark.primary : AppColors.primary),
              title: Text('Detect Current Location', style: AppTextStyles.labelLarge),
              onTap: () {
                ref.read(locationProvider.notifier).getCurrentLocation();
                ref.read(locationProvider.notifier).setAlternateAddress(null);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: TextField(
                controller: controller,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Enter street, area or city...',
                  prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMapsLocation01, color: isDark ? AppColorsDark.textHint : AppColors.textHint),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error))),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(locationProvider.notifier).setAlternateAddress(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).value;
    final categories = ref.watch(categoriesProvider);
    final popularServices = ref.watch(servicesProvider(null));
    final location = ref.watch(locationProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final firstName = userProfile?.fullName?.split(' ').first ?? 'Guest';

    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: isDark ? AppColorsDark.primary : AppColors.primary,
            onRefresh: () async {
              ref.invalidate(categoriesProvider);
              ref.invalidate(servicesProvider(null));
              ref.invalidate(userProfileProvider);
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              firstName,
                              style: AppTextStyles.displayLarge.copyWith(
                                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        _buildHeaderIcon(HugeIcons.strokeRoundedNotification03, hasBadge: true, onTap: () => context.push('/notifications')),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Location Picker
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: InkWell(
                      onTap: () => _showLocationDialog(context, ref),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            HugeIcon(icon: HugeIcons.strokeRoundedLocation01, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                location.isLoading ? 'Detecting...' : location.currentDisplay,
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            HugeIcon(icon: HugeIcons.strokeRoundedArrowDown01, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search for "plumbing", "salon"...',
                        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01, color: isDark ? AppColorsDark.textHint : AppColors.textHint),
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Promotional banner
                  SizedBox(
                    height: 180,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        _buildPromoCard(
                          'Premium Cleaning',
                          'Get 20% off your first home deep clean.',
                          'CODE: CLEAN20',
                          [const Color(0xFF4F46E5), const Color(0xFF3730A3)],
                          HugeIcons.strokeRoundedSparkles,
                        ),
                        _buildPromoCard(
                          'Refer & Earn',
                          'Invite friends and get Rs. 200 in your wallet.',
                          'INVITE NOW',
                          [const Color(0xFFD4B866), const Color(0xFF4F46E5)],
                          HugeIcons.strokeRoundedTicket01,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Service categories
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Categories', style: AppTextStyles.headingLarge),
                            const SizedBox(height: 4),
                            Container(height: 2, width: 30, color: isDark ? AppColorsDark.primary : AppColors.primary),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('See All', style: AppTextStyles.labelLarge.copyWith(color: isDark ? AppColorsDark.primary : AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 110,
                    child: categories.when(
                      data: (data) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        itemCount: data.length,
                        itemBuilder: (context, index) => CategoryCard(
                          category: data[index],
                          onTap: () => context.go('/home/categories/${data[index].id}'),
                        ),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Popular services
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recommended for you', style: AppTextStyles.headingLarge),
                        const SizedBox(height: 4),
                        Container(height: 2, width: 30, color: isDark ? AppColorsDark.primary : AppColors.primary),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: popularServices.when(
                      data: (data) => Column(
                        children: data.map((service) => ServiceCard(
                          service: service,
                          onTap: () => context.go('/home/services/${service.id}'),
                        )).toList(),
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
                    ),
                  ),
                  const SizedBox(height: 100), // Navigation breathing room
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasBadge = false, VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: GlassCard(
        padding: const EdgeInsets.all(10),
        borderRadius: AppRadius.md,
        child: Badge(
          isLabelVisible: hasBadge,
          backgroundColor: isDark ? AppColorsDark.primary : AppColors.primary,
          child: HugeIcon(icon: icon, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }

  Widget _buildPromoCard(String title, String desc, String btn, List<Color> colors, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: HugeIcon(icon: icon, color: Colors.white.withOpacity(0.1), size: 140),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(AppRadius.xs)),
                  child: Text(btn, style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Text(title, style: AppTextStyles.displayMedium.copyWith(color: Colors.white)),
                const SizedBox(height: 6),
                SizedBox(
                  width: 200,
                  child: Text(desc, style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.9))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
