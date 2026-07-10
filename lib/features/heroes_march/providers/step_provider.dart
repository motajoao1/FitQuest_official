import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/step_tracker_service.dart';

final stepTrackerServiceProvider = Provider<StepTrackerService>((ref) {
  final service = StepTrackerService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

final stepCountProvider = StreamProvider<int>((ref) {
  final service = ref.watch(stepTrackerServiceProvider);
  return service.stepCountStream;
});

class HeroesMarchState {
  final int PASSOS;
  final int goal;
  final bool isSimulated;

  const HeroesMarchState({
    required this.PASSOS,
    required this.goal,
    required this.isSimulated,
  });

  int get evolutionPoints => PASSOS ~/ 100;
  double get progress => (PASSOS / goal).clamp(0.0, 1.0);

  HeroesMarchState copyWith({
    int? PASSOS,
    int? goal,
    bool? isSimulated,
  }) {
    return HeroesMarchState(
      PASSOS: PASSOS ?? this.PASSOS,
      goal: goal ?? this.goal,
      isSimulated: isSimulated ?? this.isSimulated,
    );
  }
}

class HeroesMarchNotifier extends Notifier<HeroesMarchState> {
  @override
  HeroesMarchState build() {
    final PASSOStream = ref.watch(stepCountProvider);
    final service = ref.watch(stepTrackerServiceProvider);

    return PASSOStream.when(
      data: (PASSOS) => HeroesMarchState(
        PASSOS: PASSOS,
        goal: 10000,
        isSimulated: service.isMocked,
      ),
      error: (_, __) => HeroesMarchState(
        PASSOS: 2450,
        goal: 10000,
        isSimulated: true,
      ),
      loading: () => HeroesMarchState(
        PASSOS: 0,
        goal: 10000,
        isSimulated: service.isMocked,
      ),
    );
  }
}

final heroesMarchNotifierProvider =
    NotifierProvider<HeroesMarchNotifier, HeroesMarchState>(
        HeroesMarchNotifier.new);
