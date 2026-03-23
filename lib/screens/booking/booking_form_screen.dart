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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Schedule Appointment', style: AppTheme.textTheme.displayMedium),
        backgroundColor: AppTheme.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
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
          // Elegant Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.p32, vertical: AppTheme.p24),
            child: Row(
              children: [
                _buildStep(1, 'Service', step >= 0, step == 0),
                _buildDivider(step >= 1),
                _buildStep(2, 'Schedule', step >= 1, step == 1),
                _buildDivider(step >= 2),
                _buildStep(3, 'Confirm', step >= 2, step == 2),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.p24),
              physics: const BouncingScrollPhysics(),
              child: _buildStepContent(step, bookingForm),
            ),
          ),
          
          // Fixed Bottom Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.p24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [AppTheme.softShadow],
            ),
            child: CustomButton(
              text: step == 2 ? 'Place Booking' : 'Continue',
              onPressed: _onNext,
              isLoading: _isSubmitting,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int n, String label, bool isCompleted, bool isCurrent) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: isCurrent || isCompleted ? AppTheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isCurrent || isCompleted ? AppTheme.primary : AppTheme.border, width: 2),
            boxShadow: isCurrent ? [AppTheme.accentShadow.copyWith(blurRadius: 8, offset: const Offset(0, 4))] : null,
          ),
          child: Center(
            child: isCompleted && !isCurrent
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
              : Text(n.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isCurrent || isCompleted ? Colors.white : AppTheme.textMuted)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: AppTheme.textTheme.bodySmall?.copyWith(
            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
            color: isCurrent || isCompleted ? AppTheme.textPrimary : AppTheme.textMuted,
            fontSize: 11,
          )
        ),
      ],
    );
  }

  Widget _buildDivider(bool isActive) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20), // Align with circles
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 2.5,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : AppTheme.border,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(int step, BookingFormState state) {
    switch (step) {
      case 0: return _buildStep1(state);
      case 1: return _buildStep2(state);
      case 2: return _buildStep3(state);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildStep1(BookingFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Selected Detail'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: Row(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: AppTheme.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.selectedService?.name ?? 'No service selected', style: AppTheme.textTheme.displaySmall),
                    const SizedBox(height: 4),
                    Text('Base Price: ${PriceFormatter.format(state.selectedService?.basePrice ?? 0)}', style: AppTheme.textTheme.bodyMedium?.copyWith(color: AppTheme.primary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Special Requirements'),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Instructions for Provider',
          hintText: 'e.g., Clean the kitchen cabinets thoroughly, avoid strong detergents...',
          controller: _notesController,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: AppTheme.textTheme.displayMedium?.copyWith(fontSize: 18));
  }

  Widget _buildStep2(BookingFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Select Preferred Date'),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 14,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = state.selectedDate?.day == date.day && state.selectedDate?.month == date.month;
              return GestureDetector(
                onTap: () => ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(selectedDate: date)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : Colors.white,
                    border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected ? [AppTheme.accentShadow.copyWith(blurRadius: 10, offset: const Offset(0, 4))] : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('MMM').format(date).toUpperCase(), style: TextStyle(color: isSelected ? Colors.white.withOpacity(0.8) : AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(DateFormat('d').format(date), style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(DateFormat('EEE').format(date), style: TextStyle(color: isSelected ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: 11)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Select Start Time'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 14,
          children: List.generate(10, (index) {
            final hour = 8 + index;
            final isPM = hour >= 12;
            final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
            final displayTime = '$displayHour:00 ${isPM ? 'PM' : 'AM'}';
            final isSelected = state.selectedTime == displayTime;
            
            return GestureDetector(
              onTap: () => ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(selectedTime: displayTime)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.white,
                  border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected ? [AppTheme.accentShadow.copyWith(blurRadius: 8, offset: const Offset(0, 4))] : null,
                ),
                child: Text(displayTime, style: TextStyle(color: isSelected ? Colors.white : AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('Delivery Location'),
        const SizedBox(height: 12),
        CustomTextField(
          label: 'Service Address',
          hintText: 'House No, Street Name, Area...',
          controller: _addressController,
          prefixIcon: Icons.my_location_rounded,
        ),
      ],
    );
  }

  Widget _buildStep3(BookingFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Final Summary'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(AppTheme.p24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.border),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: Column(
            children: [
              _buildSummaryRow('Service', state.selectedService?.name ?? ''),
              _buildSummaryRow('Scheduled Date', DateFormat('EEEE, MMM d').format(state.selectedDate ?? DateTime.now())),
              _buildSummaryRow('Time Slot', state.selectedTime ?? ''),
              _buildSummaryRow('Location', state.address ?? 'Not set', isSmall: true),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('Investment', style: AppTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                   Text(PriceFormatter.format(state.selectedService?.basePrice ?? 0), style: AppTheme.textTheme.displayMedium?.copyWith(color: AppTheme.primary, fontSize: 24)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader('How would you like to pay?'),
        const SizedBox(height: 16),
        _buildPaymentOption('Secure Cash on Service', Icons.payments_rounded, true, isSelected: true),
        _buildPaymentOption('Pay via eSewa / Khalti', Icons.account_balance_wallet_rounded, false),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isSmall = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
                fontSize: isSmall ? 12 : 14,
                color: AppTheme.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String label, IconData icon, bool isAvailable, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : AppTheme.background,
        border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected ? [AppTheme.accentShadow.copyWith(blurRadius: 10)] : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: isAvailable ? AppTheme.primary.withOpacity(0.1) : AppTheme.border, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: isAvailable ? AppTheme.primary : AppTheme.textMuted, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label, 
              style: TextStyle(
                color: isAvailable ? AppTheme.textPrimary : AppTheme.textMuted, 
                fontWeight: FontWeight.bold,
                fontSize: 15,
              )
            ),
          ),
          if (!isAvailable) 
            Text('(UPCOMING)', style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5))
          else if (isSelected)
            const Icon(Icons.check_circle_rounded, color: AppTheme.primary),
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
