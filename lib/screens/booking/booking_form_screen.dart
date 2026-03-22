import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';

class BookingFormScreen extends ConsumerStatefulWidget {
  const BookingFormScreen({super.key});

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProfileProvider).value;
    if (user?.defaultAddress != null) {
      _addressController.text = user!.defaultAddress!;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = ref.watch(currentBookingStepProvider);
    final bookingForm = ref.watch(bookingFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Service'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (step > 0) {
              ref.read(currentBookingStepProvider.notifier).state--;
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.all(AppTheme.p24),
            child: Row(
              children: [
                _buildStep(1, 'Details', step >= 0),
                _buildDivider(step >= 1),
                _buildStep(2, 'Schedule', step >= 1),
                _buildDivider(step >= 2),
                _buildStep(3, 'Confirm', step >= 2),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.p24),
              child: _buildStepContent(step, bookingForm),
            ),
          ),
          
          // Bottom Navigation
          Padding(
            padding: const EdgeInsets.all(AppTheme.p24),
            child: CustomButton(
              text: step == 2 ? 'Confirm Booking' : 'Next',
              onPressed: _onNext,
              isLoading: _isSubmitting,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int n, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? AppTheme.primary : AppTheme.border,
          child: Text(n.toString(), style: const TextStyle(fontSize: 12, color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.textTheme.bodySmall?.copyWith(color: isActive ? AppTheme.primary : AppTheme.textSecondary)),
      ],
    );
  }

  Widget _buildDivider(bool isActive) {
    return Expanded(
      child: Container(
        height: 1,
        color: isActive ? AppTheme.primary : AppTheme.border,
      ),
    );
  }

  Widget _buildStepContent(int step, BookingFormState state) {
    switch (step) {
      case 0:
        return _buildStep1(state);
      case 1:
        return _buildStep2(state);
      case 2:
        return _buildStep3(state);
      default:
        return Container();
    }
  }

  Widget _buildStep1(BookingFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selected Service', style: AppTheme.textTheme.displaySmall),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.build, color: AppTheme.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.selectedService?.name ?? 'No service selected', style: AppTheme.textTheme.displaySmall),
                  Text('Price: ${PriceFormatter.format(state.selectedService?.basePrice ?? 0)}', style: AppTheme.textTheme.bodyLarge),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Special Instructions',
          hintText: 'Any specific requirements or notes...',
          controller: _notesController,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildStep2(BookingFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick Date', style: AppTheme.textTheme.displaySmall),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = state.selectedDate?.day == date.day;
              return GestureDetector(
                onTap: () => ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(selectedDate: date)),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : Colors.white,
                    border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('E').format(date), style: TextStyle(color: isSelected ? Colors.white : AppTheme.textSecondary)),
                      Text(DateFormat('d').format(date), style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Text('Select Time Slot', style: AppTheme.textTheme.displaySmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(10, (index) {
            final hour = 8 + index;
            final time = '${hour.toString().padLeft(2, '0')}:00 AM';
            final displayTime = hour >= 12 ? (hour == 12 ? '12:00 PM' : '${hour - 12}:00 PM') : '$hour:00 AM';
            final isSelected = state.selectedTime == displayTime;
            
            return GestureDetector(
              onTap: () => ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(selectedTime: displayTime)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.white,
                  border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(displayTime, style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary)),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Service Address',
          hintText: 'Near Pashupatinath Temple, Kathmandu',
          controller: _addressController,
          prefixIcon: Icons.location_on_outlined,
        ),
      ],
    );
  }

  Widget _buildStep3(BookingFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Booking Summary', style: AppTheme.textTheme.displaySmall),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(AppTheme.p16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [AppTheme.cardShadow],
          ),
          child: Column(
            children: [
              _buildSummaryRow('Service', state.selectedService?.name ?? ''),
              _buildSummaryRow('Date', DateFormat('MMM d, yyyy').format(state.selectedDate ?? DateTime.now())),
              _buildSummaryRow('Time', state.selectedTime ?? ''),
              const Divider(),
              _buildSummaryRow('Total Price', PriceFormatter.format(state.selectedService?.basePrice ?? 0), isBold: true),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Payment Method', style: AppTheme.textTheme.displaySmall),
        const SizedBox(height: 12),
        _buildPaymentOption('Cash', Icons.money, true),
        _buildPaymentOption('eSewa (Coming Soon)', Icons.phone_android, false),
        _buildPaymentOption('Khalti (Coming Soon)', Icons.wallet, false),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
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

  Widget _buildPaymentOption(String label, IconData icon, bool isAvailable) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : AppTheme.surface,
        border: Border.all(color: label == 'Cash' ? AppTheme.primary : AppTheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: isAvailable ? AppTheme.primary : AppTheme.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: isAvailable ? AppTheme.textPrimary : AppTheme.textSecondary)),
          const Spacer(),
          if (!isAvailable) const Icon(Icons.lock_outline, size: 16, color: AppTheme.textSecondary),
          if (label == 'Cash') const Icon(Icons.check_circle, color: AppTheme.primary),
        ],
      ),
    );
  }

  Future<void> _onNext() async {
    final step = ref.read(currentBookingStepProvider);
    final state = ref.read(bookingFormProvider);

    if (step == 0) {
      if (state.selectedService == null) {
        _showError('Please select a service first');
        return;
      }
      ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(notes: _notesController.text));
      ref.read(currentBookingStepProvider.notifier).state++;
    } else if (step == 1) {
      if (state.selectedDate == null) {
        _showError('Please select a date');
        return;
      }
      if (state.selectedTime == null) {
        _showError('Please select a time slot');
        return;
      }
      if (_addressController.text.isEmpty) {
        _showError('Please enter a service address');
        return;
      }
      ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(address: _addressController.text));
      ref.read(currentBookingStepProvider.notifier).state++;
    } else if (step == 2) {
      // Confirm Booking
      setState(() => _isSubmitting = true);
      try {
        final user = ref.read(currentUserProvider);
        if (user == null) throw Exception('User not logged in');

        final timeParts = state.selectedTime!.split(':');
        final hour = int.parse(timeParts[0]) + (state.selectedTime!.contains('PM') && timeParts[0] != '12' ? 12 : 0);
        final scheduledAt = DateTime(
          state.selectedDate!.year,
          state.selectedDate!.month,
          state.selectedDate!.day,
          hour,
        );

        final booking = BookingModel(
          id: const Uuid().v4(),
          customerId: user.id,
          providerId: state.selectedProvider?.id,
          serviceId: state.selectedService!.id,
          status: 'pending',
          scheduledAt: scheduledAt,
          address: state.address!,
          totalPrice: state.selectedService!.basePrice,
          paymentMethod: 'cash',
          paymentStatus: 'unpaid',
          notes: state.notes,
          createdAt: DateTime.now(),
        );

        await ref.read(bookingServiceProvider).createBooking(booking);
        
        // Reset state
        ref.read(currentBookingStepProvider.notifier).state = 0;
        ref.read(bookingFormProvider.notifier).state = BookingFormState();
        
        context.go('/home/booking/confirm');
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
