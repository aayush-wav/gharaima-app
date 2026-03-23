import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationState {
  final String address;
  final bool isLoading;
  final String? error;
  final String? alternateAddress;

  LocationState({
    this.address = 'Fetching location...',
    this.isLoading = false,
    this.error,
    this.alternateAddress,
  });

  LocationState copyWith({
    String? address,
    bool? isLoading,
    String? error,
    String? alternateAddress,
  }) {
    return LocationState(
      address: address ?? this.address,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      alternateAddress: alternateAddress ?? this.alternateAddress,
    );
  }

  String get currentDisplay => alternateAddress ?? address;
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState()) {
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(address: 'Location disabled', isLoading: false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(address: 'Permission denied', isLoading: false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(address: 'Permissions locked', isLoading: false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.street}, ${place.locality}';
        state = state.copyWith(address: address, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(address: 'Balkhu, Kathmandu', isLoading: false, error: e.toString());
    }
  }

  void setAlternateAddress(String? alt) {
    state = state.copyWith(alternateAddress: alt);
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
