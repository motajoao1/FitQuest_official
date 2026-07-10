import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GymLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String vicinity;

  GymLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.vicinity,
  });

  factory GymLocation.fromJson(Map<String, dynamic> json) {
    return GymLocation(
      id: json['place_id'],
      name: json['name'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      vicinity: json['vicinity'] ?? '',
    );
  }
}

class LocationService {
  bool _isMocked = false;
  final String _googleApiKey = const String.fromEnvironment('GOOGLE_API_KEY', defaultValue: '');

  bool get isMocked => _isMocked;

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    if (kIsWeb) {
      _isMocked = true;
      return true;
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      _isMocked = true;
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        _isMocked = true;
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      _isMocked = true;
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission || _isMocked) {
      return _getMockPosition();
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('Error getting current position: $e');
      _isMocked = true;
      return _getMockPosition();
    }
  }

  Future<List<GymLocation>> getNearbyGyms(Position position) async {
    if (_isMocked || _googleApiKey.isEmpty) {
      if (_googleApiKey.isEmpty) {
        debugPrint('Google API Key not found, using mock data.');
      }
      return _getMockGyms(position);
    }

    try {
      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
          'location=${position.latitude},${position.longitude}'
          '&radius=1500'
          '&type=gym'
          '&key=$_googleApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          return results.map((json) => GymLocation.fromJson(json)).toList();
        } else {
          debugPrint('Places API error: ${data['status']}');
          _isMocked = true;
          return _getMockGyms(position);
        }
      } else {
        debugPrint('Failed to fetch gyms: ${response.statusCode}');
        _isMocked = true;
        return _getMockGyms(position);
      }
    } catch (e) {
      debugPrint('Exception while fetching gyms: $e');
      _isMocked = true;
      return _getMockGyms(position);
    }
  }

  Position _getMockPosition() {
    // Simulate a position (e.g., center of a city)
    return Position(
      longitude: -122.084,
      latitude: 37.422,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  List<GymLocation> _getMockGyms(Position position) {
    return [
      GymLocation(
        id: 'mock_gym_1',
        name: 'Iron Temple Fitness',
        latitude: position.latitude + 0.002,
        longitude: position.longitude + 0.002,
        vicinity: '123 Muscle Ave',
      ),
      GymLocation(
        id: 'mock_gym_2',
        name: 'Goblin Cave Crossfit',
        latitude: position.latitude - 0.003,
        longitude: position.longitude + 0.001,
        vicinity: '456 Sweat St',
      ),
      GymLocation(
        id: 'mock_gym_3',
        name: 'Dragon Roost Climbing',
        latitude: position.latitude + 0.001,
        longitude: position.longitude - 0.002,
        vicinity: '789 Peak Blvd',
      ),
    ];
  }
}
