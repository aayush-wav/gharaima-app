import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/date_formatter.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/booking_status_chip.dart';
import '../../widgets/glass_card.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  children: [
                    Text('Activity Tracker', style: AppTextStyles.displayMedium),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: isDark ? AppColorsDark.primary : AppColors.primary,
                labelColor: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                unselectedLabelColor: isDark ? AppColorsDark.textHint : AppColors.textHint,
                labelStyle: AppTextStyles.labelLarge,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Ongoing'),
                  Tab(text: 'History'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingList(['pending', 'confirmed', 'in_progress']),
                    _buildBookingList(['completed']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(List<String> statuses) {
    final user = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return Center(
        child: Text('Join us to track your activities', style: AppTextStyles.bodyMedium),
      );
    }

    // Combined stream for multiple statuses if needed
    final bookings = ref.watch(userBookingsProvider(statuses.first));

    return bookings.when(
      data: (data) {
        final filteredData = data.where((b) => statuses.contains(b.status)).toList();

        if (filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar03, 
                  color: (isDark ? AppColorsDark.textHint : AppColors.textHint).withOpacity(0.3), 
                  size: 64
                ),
                const SizedBox(height: 24),
                Text('Nothing to show', style: AppTextStyles.bodyMedium),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.xl),
          physics: const BouncingScrollPhysics(),
          itemCount: filteredData.length,
          itemBuilder: (context, index) => _buildActivityCard(filteredData[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
    );
  }

  Widget _buildActivityCard(BookingModel booking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return GestureDetector(
      onTap: () => context.push('/bookings/${booking.id}'),
      child: GlassCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: #${booking.id.substring(0, 6).toUpperCase()}',
                  style: AppTextStyles.labelSmall.copyWith(color: (isDark ? AppColorsDark.textHint : AppColors.textHint)),
                ),
                BookingStatusChip(status: booking.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Center(
                    child: HugeIcon(icon: HugeIcons.strokeRoundedTask01, color: primary, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Request',
                        style: AppTextStyles.headingSmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          HugeIcon(icon: HugeIcons.strokeRoundedCalendar01, color: (isDark ? AppColorsDark.textHint : AppColors.textHint), size: 14),
                          const SizedBox(width: 6),
                          Text(
                            DateFormatter.formatDateTime(booking.scheduledAt),
                            style: AppTextStyles.bodySmall.copyWith(color: (isDark ? AppColorsDark.textHint : AppColors.textHint)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL PRICE', style: AppTextStyles.overline.copyWith(color: (isDark ? AppColorsDark.textHint : AppColors.textHint))),
                    Text(
                      PriceFormatter.format(booking.totalPrice ?? 0),
                      style: AppTextStyles.priceText.copyWith(color: primary),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => context.push('/bookings/${booking.id}'),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'Manage',
                      style: AppTextStyles.labelSmall.copyWith(color: isDark ? AppColorsDark.textOnPrimary : AppColors.textOnPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
