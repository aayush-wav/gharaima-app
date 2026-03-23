import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/provider_model.dart';
import '../services/booking_service.dart';
import 'auth_provider.dart';

final bookingServiceProvider = Provider<BookingService>((ref) => BookingService());

final userBookingsProvider = FutureProvider.family<List<BookingModel>, String?>((ref, status) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final bookingService = ref.watch(bookingServiceProvider);
  return await bookingService.getMyBookings(user.id, status: status);
});

final currentBookingStepProvider = StateProvider<int>((ref) => 0);

class BookingFormState {
  final ServiceModel? selectedService;
  final ProviderModel? selectedProvider;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? address;
  final String? notes;
  final String paymentMethod;

  BookingFormState({
    this.selectedService,
    this.selectedProvider,
    this.selectedDate,
    this.selectedTime,
    this.address,
    this.notes,
    this.paymentMethod = 'cash',
  });

  BookingFormState copyWith({
    ServiceModel? selectedService,
    ProviderModel? selectedProvider,
    DateTime? selectedDate,
    String? selectedTime,
    String? address,
    String? notes,
    String? paymentMethod,
  }) {
    return BookingFormState(
      selectedService: selectedService ?? this.selectedService,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

final bookingFormProvider = StateProvider<BookingFormState>((ref) => BookingFormState());
