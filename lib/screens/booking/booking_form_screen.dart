import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:uuid/uuid.dart';
import '../../config/theme.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/glass_card.dart';

class BookingFormScreen extends ConsumerStatefulWidget {
  const BookingFormScreen({super.key});

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: OrbBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context, step),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xl),
                child: Row(
                  children: [
                    _buildStep(1, 'Service', step >= 0, step == 0),
                    _buildStepDivider(step >= 1),
                    _buildStep(2, 'Schedule', step >= 1, step == 1),
                    _buildStepDivider(step >= 2),
                    _buildStep(3, 'Confirm', step >= 2, step == 2),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  physics: const BouncingScrollPhysics(),
                  child: _buildStepContent(step, bookingForm),
                ),
              ),
              
              _buildBottomAction(step, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, int step) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, color: AppColors.textPrimary, size: 24),
            onPressed: () {
              if (step > 0) {
                ref.read(currentBookingStepProvider.notifier).state--;
              } else {
                context.pop();
              }
            },
          ),
          Text('Appointment', style: AppTextStyles.headingMedium),
          const SizedBox(width: 48), // Spacer to center title
        ],
      ),
    );
  }

  Widget _buildStep(int n, String label, bool isCompleted, bool isCurrent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: isCurrent || isCompleted ? primary : (isDark ? AppColorsDark.surface : Colors.white),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: isCurrent || isCompleted ? primary : (isDark ? AppColorsDark.border : AppColors.border), width: 1.5),
          ),
          child: Center(
            child: isCompleted && !isCurrent
              ? const HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle01, color: Colors.white, size: 16)
              : Text(n.toString(), style: AppTextStyles.labelLarge.copyWith(color: isCurrent || isCompleted ? Colors.white : (isDark ? AppColorsDark.textHint : AppColors.textHint))),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: AppTextStyles.labelSmall.copyWith(
            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
            color: isCurrent || isCompleted ? (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary) : (isDark ? AppColorsDark.textHint : AppColors.textHint),
          )
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 1,
          color: isActive ? (isDark ? AppColorsDark.primary : AppColors.primary) : (isDark ? AppColorsDark.border : AppColors.border),
        ),
      ),
    );
  }

  Widget _buildBottomAction(int step, bool isDark) {
    final glassFill = isDark ? AppColorsDark.glassFill : AppColors.glassFill;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: glassFill,
            border: Border(top: BorderSide(color: isDark ? AppColorsDark.border : AppColors.border, width: 0.5)),
          ),
          child: CustomButton(
            text: step == 2 ? 'Place Booking' : 'Continue',
            onPressed: _onNext,
            isLoading: _isSubmitting,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Concierge Service', style: AppTextStyles.headingLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          child: Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: (isDark ? AppColorsDark.primary : AppColors.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: HugeIcon(icon: HugeIcons.strokeRoundedTask01, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.selectedService?.name ?? 'No service selected', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 4),
                    Text(
                      PriceFormatter.format(state.selectedService?.basePrice ?? 0), 
                      style: AppTextStyles.priceText.copyWith(color: isDark ? AppColorsDark.primary : AppColors.primary, fontSize: 16)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Service Instructions', style: AppTextStyles.headingLarge),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Special notes for provider',
          hintText: 'e.g. Please bring extra floor mops...',
          controller: _notesController,
          maxLines: 4,
          prefixIcon: HugeIcons.strokeRoundedNoteEdit,
        ),
      ],
    );
  }

  Widget _buildStep2(BookingFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Appointment Date', style: AppTextStyles.headingLarge),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 14,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = state.selectedDate?.day == date.day && state.selectedDate?.month == date.month;
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final primary = isDark ? AppColorsDark.primary : AppColors.primary;

              return GestureDetector(
                onTap: () => ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(selectedDate: date)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? primary : (isDark ? AppColorsDark.surface : Colors.white),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: isSelected ? primary : (isDark ? AppColorsDark.border : AppColors.border), width: 1.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('MMM').format(date).toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: isSelected ? Colors.white70 : (isDark ? AppColorsDark.textHint : AppColors.textHint), fontSize: 9)),
                      Text(DateFormat('d').format(date), style: AppTextStyles.displayMedium.copyWith(color: isSelected ? Colors.white : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary), fontSize: 20)),
                      Text(DateFormat('EEE').format(date), style: AppTextStyles.labelSmall.copyWith(color: isSelected ? Colors.white : (isDark ? AppColorsDark.textSecondary : AppColors.textSecondary), fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Start Time', style: AppTextStyles.headingLarge),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(8, (index) {
            final hour = 9 + index;
            final ampm = hour >= 12 ? 'PM' : 'AM';
            final hr = hour > 12 ? hour - 12 : hour;
            final displayTime = '$hr:00 $ampm';
            final isSelected = state.selectedTime == displayTime;
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final primary = isDark ? AppColorsDark.primary : AppColors.primary;

            return GestureDetector(
              onTap: () => ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(selectedTime: displayTime)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? primary : (isDark ? AppColorsDark.surface : Colors.white),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: isSelected ? primary : (isDark ? AppColorsDark.border : AppColors.border)),
                ),
                child: Text(displayTime, style: AppTextStyles.labelLarge.copyWith(color: isSelected ? Colors.white : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary))),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Delivery Address', style: AppTextStyles.headingLarge),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Street or locality',
          hintText: 'House No, Building, Area...',
          controller: _addressController,
          prefixIcon: HugeIcons.strokeRoundedMapsLocation01,
        ),
      ],
    );
  }

  Widget _buildStep3(BookingFormState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Luxury Summary', style: AppTextStyles.headingLarge),
        const SizedBox(height: AppSpacing.md),
        GlassCard(
          child: Column(
            children: [
              _buildSummaryRow('Service', state.selectedService?.name ?? ''),
              _buildSummaryRow('Scheduled', DateFormat('EEEE, MMM d').format(state.selectedDate ?? DateTime.now())),
              _buildSummaryRow('Time Slot', state.selectedTime ?? ''),
              _buildSummaryRow('Destination', state.address ?? 'Not set', isSmall: true),
              const Divider(height: 32, thickness: 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('Investment', style: AppTextStyles.labelLarge),
                   Text(PriceFormatter.format(state.selectedService?.basePrice ?? 0), style: AppTextStyles.priceLarge.copyWith(color: primary)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('Choose Method', style: AppTextStyles.headingLarge),
        const SizedBox(height: AppSpacing.md),
        _buildPaymentOption('Secure Cash on Service', HugeIcons.strokeRoundedMoney03, isDark, isSelected: true),
        _buildPaymentOption('eSewa / Khalti Payments', HugeIcons.strokeRoundedSmartphone02, isDark, isAvailable: false),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isSmall = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.end,
              style: AppTextStyles.labelMedium.copyWith(fontSize: isSmall ? 11 : 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String label, IconData icon, bool isDark, {bool isSelected = false, bool isAvailable = true}) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: isAvailable ? primary : (isDark ? AppColorsDark.textHint : AppColors.textHint), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label, 
                style: AppTextStyles.labelLarge.copyWith(color: isAvailable ? (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary) : (isDark ? AppColorsDark.textHint : AppColors.textHint))
              ),
            ),
            if (isSelected) HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle02, color: primary, size: 20),
            if (!isAvailable) Text('UPCOMING', style: AppTextStyles.labelSmall.copyWith(color: isDark ? AppColorsDark.textHint : AppColors.textHint, fontSize: 8)),
          ],
        ),
      ),
    );
  }

  Future<void> _onNext() async {
    final step = ref.read(currentBookingStepProvider);
    final state = ref.read(bookingFormProvider);

    if (step == 0) {
      if (state.selectedService == null) {
        _showError('No service selected');
        return;
      }
      ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(notes: _notesController.text));
      ref.read(currentBookingStepProvider.notifier).state++;
    } else if (step == 1) {
      if (state.selectedDate == null || state.selectedTime == null || _addressController.text.isEmpty) {
        _showError('Complete scheduling details');
        return;
      }
      ref.read(bookingFormProvider.notifier).update((s) => s.copyWith(address: _addressController.text));
      ref.read(currentBookingStepProvider.notifier).state++;
    } else if (step == 2) {
      setState(() => _isSubmitting = true);
      try {
        final user = ref.read(currentUserProvider);
        if (user == null) return;

        final timeParts = state.selectedTime!.split(':');
        final hour = int.parse(timeParts[0]) + (state.selectedTime!.contains('PM') && timeParts[0] != '12' ? 12 : 0);
        final scheduledAt = DateTime(state.selectedDate!.year, state.selectedDate!.month, state.selectedDate!.day, hour);

        final booking = BookingModel(
          id: const Uuid().v4(),
          customerId: user.id,
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: AppColors.error, content: Text(message, style: const TextStyle(color: Colors.white))));
  }
}
