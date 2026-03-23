import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../models/review_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../utils/date_formatter.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/booking_status_chip.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/glass_card.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  bool _isCancelling = false;

  Future<void> _cancelBooking() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColorsDark.surfaceElevated : AppColors.surfaceElevated,
        title: Text('Cancel Appointment?', style: AppTextStyles.headingLarge),
        content: Text('Are you sure you want to cancel this concierge service?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No', style: AppTextStyles.labelLarge)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes, Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.error))),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isCancelling = true);
      try {
        await ref.read(bookingServiceProvider).updateBookingStatus(widget.bookingId, 'cancelled');
        ref.invalidate(userBookingsProvider(null));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.error, content: Text('Error: $e')));
      } finally {
        setState(() => _isCancelling = false);
      }
    }
  }

  void _showReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassBottomSheet(child: _ReviewBottomSheet(bookingId: widget.bookingId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(userBookingsProvider(null));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: bookings.when(
                  data: (data) {
                    final booking = data.firstWhere((e) => e.id == widget.bookingId, orElse: () => throw Exception('Not found'));
                    
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusTimeline(booking.status, isDark),
                          const SizedBox(height: 32),
                          
                          _buildSectionTitle('Concierge Detail', isDark),
                          GlassCard(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              children: [
                                _buildInfoRow('SERVICE ID', '#${booking.id.substring(0, 8).toUpperCase()}', isDark, isBold: true),
                                _buildInfoRow('SCHEDULED', DateFormatter.formatDateTime(booking.scheduledAt), isDark),
                                _buildInfoRow('INVESTMENT', PriceFormatter.format(booking.totalPrice ?? 0), isDark),
                                _buildInfoRow('METHOD', booking.paymentMethod.toUpperCase(), isDark),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          _buildSectionTitle('Specialist Information', isDark),
                          _buildProviderCard(booking.providerId, isDark),
                          
                          const SizedBox(height: 32),
                          _buildSectionTitle('Service Location', isDark),
                          _buildMap(booking.latitude, booking.longitude, booking.address, isDark),
                          
                          const SizedBox(height: 48),
                          if (booking.status == 'pending' || booking.status == 'confirmed')
                            CustomButton(
                              text: 'Cancel Appointment',
                              onPressed: _cancelBooking,
                              isLoading: _isCancelling,
                              isSecondary: true,
                            ),
                          if (booking.status == 'completed')
                            CustomButton(
                              text: 'Share your Experience',
                              onPressed: _showReviewSheet,
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 24),
            onPressed: () => context.pop(),
          ),
          Text('Activity Detail', style: AppTextStyles.headingMedium),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(String currentStatus, bool isDark) {
    final statuses = ['pending', 'confirmed', 'in_progress', 'completed'];
    final currentIndex = statuses.indexOf(currentStatus.toLowerCase());
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final border = isDark ? AppColorsDark.border : AppColors.border;

    return Row(
      children: List.generate(4, (index) {
        final isActive = index <= currentIndex;
        final isLast = index == 3;
        
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: index == 0 ? Colors.transparent : (isActive ? primary : border))),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? primary : border,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(child: Container(height: 1, color: isLast ? Colors.transparent : (index < currentIndex ? primary : border))),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                statuses[index].toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  fontSize: 8,
                  letterSpacing: 0.5,
                  fontWeight: index == currentIndex ? FontWeight.w800 : FontWeight.w500,
                  color: index == currentIndex ? primary : (isDark ? AppColorsDark.textHint : AppColors.textHint),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, left: 4),
      child: Text(
        title.toUpperCase(), 
        style: AppTextStyles.overline.copyWith(
          color: isDark ? AppColorsDark.textHint : AppColors.textHint,
          letterSpacing: 2.0
        )
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint)),
          Text(value, style: AppTextStyles.labelMedium.copyWith(color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary, fontWeight: isBold ? FontWeight.w800 : FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildProviderCard(String? providerId, bool isDark) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    if (providerId == null) {
      return GlassCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(child: Text('Specialist pending assignment', style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint))),
      );
    }
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
            child: HugeIcon(icon: HugeIcons.strokeRoundedUser, color: primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ram Shrestha', style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Row(
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedStar, color: isDark ? AppColorsDark.warning : AppColors.warning, size: 12),
                    const SizedBox(width: 4),
                    Text('4.8 Expert', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => launchUrl(Uri.parse('tel:9841000001')),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isDark ? AppColorsDark.primary : AppColors.primary, shape: BoxShape.circle),
              child: const HugeIcon(icon: HugeIcons.strokeRoundedCall, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(double? lat, double? lng, String address, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(lat ?? 27.7172, lng ?? 85.3240), zoom: 15),
              markers: {
                Marker(markerId: const MarkerId('u_loc'), position: LatLng(lat ?? 27.7172, lng ?? 85.3240)),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HugeIcon(icon: HugeIcons.strokeRoundedMapsLocation01, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(address, style: AppTextStyles.bodySmall.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary))),
          ],
        ),
      ],
    );
  }
}

class _ReviewBottomSheet extends ConsumerStatefulWidget {
  final String bookingId;
  const _ReviewBottomSheet({required this.bookingId});

  @override
  ConsumerState<_ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends ConsumerState<_ReviewBottomSheet> {
  int _rating = 5;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Signature Review', style: AppTextStyles.headingLarge),
          const SizedBox(height: 8),
          Text('How was your concierge experience?', style: AppTextStyles.bodySmall),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => IconButton(
              onPressed: () => setState(() => _rating = index + 1),
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedStar, 
                size: 32, 
                color: index < _rating ? (isDark ? AppColorsDark.warning : AppColors.warning) : (isDark ? AppColorsDark.border : AppColors.border)
              ),
            )),
          ),
          const SizedBox(height: 32),
          CustomTextField(
            label: 'The Experience', 
            controller: _commentController, 
            maxLines: 4, 
            hintText: 'Share your thoughts with us...',
            prefixIcon: HugeIcons.strokeRoundedNoteEdit,
          ),
          const SizedBox(height: 48),
          CustomButton(
            text: 'Submit Testimony',
            isLoading: _isSubmitting,
            onPressed: () async {
              setState(() => _isSubmitting = true);
              try {
                final user = ref.read(currentUserProvider);
                final review = ReviewModel(
                  id: 0,
                  bookingId: widget.bookingId,
                  customerId: user!.id,
                  providerId: 'provider-uuid-placeholder',
                  rating: _rating,
                  comment: _commentController.text,
                  createdAt: DateTime.now(),
                );
                await ref.read(bookingServiceProvider).submitReview(review);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your testimony.')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.error, content: Text('Error: $e')));
              } finally {
                setState(() => _isSubmitting = false);
              }
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
