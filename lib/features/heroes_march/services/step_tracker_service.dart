import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepTrackerService {
  final _stepCountController = StreamController<int>.broadcast();
  StreamSubscription<StepCount>? _pedometerSubscription;
  int? _initialsteps;
  int _laststeps = 0;
  bool _isMocked = false;
  Timer? _mockTimer;

  Stream<int> get stepCountStream => _stepCountController.stream;

  bool get isMocked => _isMocked;

  Future<bool> checkAndRequestPermissions() async {
    if (kIsWeb) {
      _enableMocking();
      return true;
    }

    try {
      if (Platform.isAndroid) {
        final status = await Permission.activityRecognition.status;
        if (status.isGranted) {
          return true;
        }
        final result = await Permission.activityRecognition.request();
        return result.isGranted;
      } else if (Platform.isIOS) {
        final status = await Permission.sensors.status;
        if (status.isGranted) {
          return true;
        }
        final result = await Permission.sensors.request();
        return result.isGranted;
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }

    _enableMocking();
    return false;
  }

  void initialize() async {
    final hasPermission = await checkAndRequestPermissions();
    if (hasPermission && !kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        _pedometerSubscription = Pedometer.stepCountStream.listen(
          _onStepCount,
          onError: _onStepCountError,
        );
      } catch (e) {
        debugPrint('Failed to start pedometer stream: $e');
        _enableMocking();
      }
    } else {
      _enableMocking();
    }
  }

  void _onStepCount(StepCount event) {
    _isMocked = false;
    final steps = event.steps;
    if (_initialsteps == null) {
      _initialsteps = steps;
      _stepCountController.add(0);
    } else {
      _laststeps = steps - _initialsteps!;
      _stepCountController.add(_laststeps);
    }
  }

  void _onStepCountError(error) {
    debugPrint('Pedometer stream error: $error');
    _enableMocking();
  }

  void _enableMocking() {
    if (_isMocked) return;
    _isMocked = true;
    debugPrint('Enabling simulated step counting.');
    
    // Seed with a base number of steps for today
    _laststeps = 2450;
    _stepCountController.add(_laststeps);

    // Periodically increment steps to simulate progress
    _mockTimer?.cancel();
    _mockTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _laststeps += (10 + (20 * (1.0 - 2.0 * (0.5 - (DateTime.now().millisecond / 1000))))).round(); // random-ish increment
      _stepCountController.add(_laststeps);
    });
  }

  void dispose() {
    _pedometerSubscription?.cancel();
    _mockTimer?.cancel();
    _stepCountController.close();
  }
}
