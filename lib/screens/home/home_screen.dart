import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/categories_provider.dart';
import '../../providers/services_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/category_card.dart';
import '../../widgets/service_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider).value;
    final categories = ref.watch(categoriesProvider);
    final popularServices = ref.watch(servicesProvider(null));

    final firstName = userProfile?.fullName?.split(' ').first ?? 'Guest';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: () async {
            ref.invalidate(categoriesProvider);
            ref.invalidate(servicesProvider(null));
            ref.invalidate(userProfileProvider);
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: AppTheme.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          Text(
                            firstName,
                            style: AppTheme.textTheme.displayLarge,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildHeaderIcon(Icons.search_rounded),
                          const SizedBox(width: 12),
                          _buildHeaderIcon(Icons.notifications_none_rounded, hasBadge: true),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.p24),

                // Location Picker
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 18, color: AppTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            userProfile?.defaultAddress ?? 'Set your delivery location',
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primary),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.p32),

                // Promotional banner
                SizedBox(
                  height: 180,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    children: [
                      _buildPromoCard(
                        'Premium Cleaning',
                        'Get 20% off your first home deep clean.',
                        'CODE: CLEAN20',
                        [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
                        Icons.cleaning_services_rounded,
                      ),
                      _buildPromoCard(
                        'Refer & Earn',
                        'Invite friends and get Rs. 200 in your wallet.',
                        'INVITE NOW',
                        [const Color(0xFF7C3AED), const Color(0xFF6D28D9)],
                        Icons.card_giftcard_rounded,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.p24),

                // Service categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categories', style: AppTheme.textTheme.displayMedium),
                          const SizedBox(height: 4),
                          Container(height: 3, width: 40, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
                        child: const Row(
                          children: [
                            Text('See All', style: TextStyle(fontWeight: FontWeight.bold)),
                            Icon(Icons.chevron_right_rounded, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.p16),
                SizedBox(
                  height: 140, // More breathing room
                  child: categories.when(
                    data: (data) => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
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

                const SizedBox(height: AppTheme.p16),

                // Popular services
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Popular Services', style: AppTheme.textTheme.displayMedium),
                      const SizedBox(height: 4),
                      Container(height: 3, width: 40, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.p20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
                  child: popularServices.when(
                    data: (data) => Column(
                      children: data.take(4).map((service) => ServiceCard(
                        service: service,
                        onTap: () => context.go('/home/services/${service.id}'),
                      )).toList(),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
                  ),
                ),
                const SizedBox(height: AppTheme.p32), // Extra padding at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, {bool hasBadge = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: hasBadge 
        ? Badge(
            backgroundColor: AppTheme.primary,
            child: Icon(icon, color: AppTheme.textPrimary, size: 22),
          )
        : Icon(icon, color: AppTheme.textPrimary, size: 22),
    );
  }

  Widget _buildPromoCard(String title, String desc, String btn, List<Color> colors, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              icon,
              size: 150,
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    btn,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: Text(
                    desc,
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
