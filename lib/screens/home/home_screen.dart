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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(categoriesProvider);
            ref.invalidate(servicesProvider(null));
            ref.invalidate(userProfileProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: AppTheme.p16),
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
                            '${_getGreeting()}, $firstName',
                            style: AppTheme.textTheme.displayMedium,
                          ),
                          const SizedBox(height: AppTheme.p4),
                          GestureDetector(
                            onTap: () {
                              context.go('/profile/edit');
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.primary),
                                const SizedBox(width: AppTheme.p4),
                                Text(
                                  userProfile?.defaultAddress ?? 'Set your location',
                                  style: AppTheme.textTheme.bodySmall?.copyWith(color: AppTheme.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifications coming soon!')),
                          );
                        },
                        icon: const Badge(
                          label: Text('2', style: TextStyle(fontSize: 8)),
                          child: Icon(Icons.notifications_outlined),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.p24),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Search coming soon!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: AppTheme.textSecondary),
                          SizedBox(width: 12),
                          Text('Search for services...', style: TextStyle(color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.p24),

                // Promotional banner
                SizedBox(
                  height: 150,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    children: [
                      _buildPromoCard(
                        'Book your first cleaning — 20% off',
                        'Use code: HELLO20',
                        [Colors.red.shade400, Colors.red.shade700],
                      ),
                      _buildPromoCard(
                        'Refer a friend, earn Rs. 200',
                        'Tell your friends about us!',
                        [Colors.blue.shade400, Colors.blue.shade700],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppTheme.p8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? AppTheme.primary : AppTheme.border,
                    ),
                  )),
                ),

                const SizedBox(height: AppTheme.p24),

                // Service categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('What do you need?', style: AppTheme.textTheme.displaySmall),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to categories list
                        },
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: categories.when(
                    data: (data) => ListView.builder(
                      scrollDirection: Axis.horizontal,
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
                  child: Text('Popular services', style: AppTheme.textTheme.displaySmall),
                ),
                const SizedBox(height: AppTheme.p16),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard(String title, String subtitle, List<Color> colors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
      padding: const EdgeInsets.all(AppTheme.p24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}
