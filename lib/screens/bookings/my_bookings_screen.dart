import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/date_formatter.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/booking_status_chip.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Activity Tracker', style: AppTheme.textTheme.displayMedium),
        elevation: 0,
        backgroundColor: AppTheme.background,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ongoing'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList(['pending', 'confirmed', 'in_progress']),
          _buildBookingList(['completed']),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<String> statuses) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const Center(child: Text('Join us to track your activities'));

    // Combined stream for multiple statuses if needed, or filter in data
    final bookings = ref.watch(userBookingsProvider(statuses.first)); // Simplified for demo

    return bookings.when(
      data: (data) {
        // Filter for simplicity since provider might be status-specific
        final filteredData = data.where((b) => statuses.contains(b.status)).toList();

        if (filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.05), shape: BoxShape.circle),
                  child: Icon(Icons.auto_awesome_rounded, size: 64, color: AppTheme.primary.withOpacity(0.2)),
                ),
                const SizedBox(height: 24),
                Text('Nothing to show here', style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppTheme.p24),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: InkWell(
        onTap: () => context.push('/bookings/${booking.id}'),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'ID: #${booking.id.substring(0, 6).toUpperCase()}',
                      style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
                    ),
                  ),
                  BookingStatusChip(status: booking.status),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    height: 54,
                    width: 54,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.home_repair_service_rounded, color: AppTheme.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Service Request', style: AppTheme.textTheme.displaySmall?.copyWith(fontSize: 17)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 12, color: AppTheme.textMuted),
                            const SizedBox(width: 6),
                            Text(
                              DateFormatter.formatDateTime(booking.scheduledAt),
                              style: AppTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PriceFormatter.format(booking.totalPrice ?? 0),
                    style: AppTheme.textTheme.displaySmall?.copyWith(color: AppTheme.primary, fontSize: 18),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.textPrimary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Manage',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
