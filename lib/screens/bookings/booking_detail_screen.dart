import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import '../../widgets/star_rating.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  bool _isCancelling = false;

  Future<void> _cancelBooking() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, Cancel', style: TextStyle(color: AppTheme.primary))),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => _isCancelling = false);
      }
    }
  }

  void _showReviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => _ReviewBottomSheet(bookingId: widget.bookingId),
    );
  }

  @override
  Widget build(BuildContext context) {
    // For MVP, we'll fetch from the list provider and find by ID
    final bookings = ref.watch(userBookingsProvider(null));

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: bookings.when(
        data: (data) {
          final booking = data.firstWhere((e) => e.id == widget.bookingId, orElse: () => throw Exception('Booking not found'));
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusTimeline(booking.status),
                const SizedBox(height: 24),
                
                _buildSectionTitle('Service Info'),
                _buildInfoCard([
                  _buildInfoRow('Booking ID', booking.id.substring(0, 8).toUpperCase(), isBold: true),
                  _buildInfoRow('Scheduled' , DateFormatter.formatDateTime(booking.scheduledAt)),
                  _buildInfoRow('Price', PriceFormatter.format(booking.totalPrice ?? 0)),
                  _buildInfoRow('Payment', booking.paymentMethod.toUpperCase()),
                ]),
                
                const SizedBox(height: 24),
                _buildSectionTitle('Provider Info'),
                _buildProviderCard(booking.providerId),
                
                const SizedBox(height: 24),
                _buildSectionTitle('Service Location'),
                _buildMap(booking.latitude, booking.longitude, booking.address),
                
                const SizedBox(height: 32),
                if (booking.status == 'pending' || booking.status == 'confirmed')
                  CustomButton(
                    text: 'Cancel Booking',
                    onPressed: _cancelBooking,
                    isLoading: _isCancelling,
                    isSecondary: true,
                  ),
                if (booking.status == 'completed')
                  CustomButton(
                    text: 'Leave a Review',
                    onPressed: _showReviewSheet,
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }

  Widget _buildStatusTimeline(String currentStatus) {
    final statuses = ['pending', 'confirmed', 'in_progress', 'completed'];
    final currentIndex = statuses.indexOf(currentStatus.toLowerCase());

    return Row(
      children: List.generate(statuses.length, (index) {
        final isActive = index <= currentIndex;
        final isCurrent = index == currentIndex;
        
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container(height: 2, color: index == 0 ? Colors.transparent : (isActive ? AppTheme.primary : AppTheme.border))),
                  CircleAvatar(radius: 6, backgroundColor: isCurrent ? AppTheme.primary : (isActive ? AppTheme.primary.withOpacity(0.5) : AppTheme.border)),
                  Expanded(child: Container(height: 2, color: index == statuses.length - 1 ? Colors.transparent : (index < currentIndex ? AppTheme.primary : AppTheme.border))),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                statuses[index].replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? AppTheme.primary : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: AppTheme.textTheme.displaySmall),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.p16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.border), borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildProviderCard(String? providerId) {
    if (providerId == null) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.p16),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
        child: const Center(child: Text('Provider not assigned yet', style: TextStyle(color: AppTheme.textSecondary))),
      );
    }
    // TODO: Fetch provider name and phone
    return Container(
      padding: const EdgeInsets.all(AppTheme.p16),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppTheme.border), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const CircleAvatar(radius: 25, backgroundColor: AppTheme.surface, child: Icon(Icons.person, color: AppTheme.textSecondary)),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ram Shrestha', style: TextStyle(fontWeight: FontWeight.bold)),
              StarRating(rating: 4.8),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => launchUrl(Uri.parse('tel:9841000001')),
            icon: const CircleAvatar(backgroundColor: AppTheme.success, child: Icon(Icons.phone, color: Colors.white, size: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(double? lat, double? lng, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(lat ?? 27.7172, lng ?? 85.3240), zoom: 15),
              markers: {
                Marker(markerId: const MarkerId('loc'), position: LatLng(lat ?? 27.7172, lng ?? 85.3240)),
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(address, style: AppTheme.textTheme.bodySmall),
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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Leave a Review', style: AppTheme.textTheme.displayMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => IconButton(
              onPressed: () => setState(() => _rating = index + 1),
              icon: Icon(Icons.star, size: 40, color: index < _rating ? AppTheme.warning : AppTheme.border),
            )),
          ),
          const SizedBox(height: 24),
          CustomTextField(label: 'Comment', controller: _commentController, maxLines: 3, hintText: 'Share your experience...'),
          const SizedBox(height: 32),
          CustomButton(
            text: 'Submit Review',
            isLoading: _isSubmitting,
            onPressed: () async {
              setState(() => _isSubmitting = true);
              try {
                final user = ref.read(currentUserProvider);
                // In a real app, we'd fetch the booking details for providerId
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your review!')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              } finally {
                setState(() => _isSubmitting = false);
              }
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
