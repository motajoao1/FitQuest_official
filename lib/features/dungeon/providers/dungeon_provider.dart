import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

class DungeonState {
  final bool isLoading;
  final Position? currentLocation;
  final List<GymLocation> nearbyGyms;
  final String? error;
  final GymLocation? checkedInGym;

  DungeonState({
    this.isLoading = false,
    this.currentLocation,
    this.nearbyGyms = const [],
    this.error,
    this.checkedInGym,
  });

  DungeonState copyWith({
    bool? isLoading,
    Position? currentLocation,
    List<GymLocation>? nearbyGyms,
    String? error,
    GymLocation? checkedInGym,
  }) {
    return DungeonState(
      isLoading: isLoading ?? this.isLoading,
      currentLocation: currentLocation ?? this.currentLocation,
      nearbyGyms: nearbyGyms ?? this.nearbyGyms,
      error: error,
      checkedInGym: checkedInGym ?? this.checkedInGym,
    );
  }
}

class DungeonNotifier extends Notifier<DungeonState> {
  late final LocationService _locationService;

  @override
  DungeonState build() {
    _locationService = ref.watch(locationServiceProvider);
    Future.microtask(() => _initialize());
    return DungeonState();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        final gyms = await _locationService.getNearbyGyms(position);
        state = state.copyWith(
          isLoading: false,
          currentLocation: position,
          nearbyGyms: gyms,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Não foi possível determinar a localização.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await _initialize();
  }

  Future<bool> checkIn(GymLocation gym) async {
    if (state.currentLocation == null) return false;

    // Cálculo correto da distância usando o método nativo do Geolocator
    final double distance = Geolocator.distanceBetween(
      state.currentLocation!.latitude,
      state.currentLocation!.longitude,
      gym.latitude,
      gym.longitude,
    );

    // Se estiver dentro de 200 metros ou for mockado, permite o check-in
    if (distance <= 200 || _locationService.isMocked) {
      state = state.copyWith(checkedInGym: gym);
      return true;
    } else {
      state = state.copyWith(error: 'Você está muito longe para fazer check-in.');
      return false;
    }
  }

  void checkout() {
    state = DungeonState(
      isLoading: state.isLoading,
      currentLocation: state.currentLocation,
      nearbyGyms: state.nearbyGyms,
      error: state.error,
      checkedInGym: null,
    );
  }
}

// Nome do provider atualizado para manter a consistência
final dungeonNotifierProvider = NotifierProvider<DungeonNotifier, DungeonState>(() {
  return DungeonNotifier();
});