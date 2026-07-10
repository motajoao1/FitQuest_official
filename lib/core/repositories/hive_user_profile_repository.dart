library hive_repositories;

import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../constants/app_constants.dart';
import '../errors/app_errors.dart';
import 'repository_interfaces.dart';

class HiveUserProfileRepository implements UserProfileRepository {
  static const String _boxName = 'userProfileBox';
  late Box<UserProfile> _box;
  final String userId;

  HiveUserProfileRepository({this.userId = '0'});
  
  @override
  Future<void> init() async {
    try {
      _box = await Hive.openBox<UserProfile>(_boxName);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to initialize user profile repository',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  @override
  Future<void> close() async {
    await _box.close();
  }

  @override
  Stream<UserProfile?> watchProfile() {
    return _box.watch(key: userId).asyncMap((_) async => await getProfile());
  }

  @override
  Future<UserProfile?> getProfile() async {
    try {
      return _box.get(userId);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to retrieve user profile',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    try {
      await _box.put(userId, profile);
    } catch (e) {
      throw RepositoryError.now(
        message: 'Failed to save user profile',
        details: e.toString(),
        isRetryable: true,
      );
    }
  }

  @override
  Future<void> updateSteps(int steps) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(stepCount: steps);
    await saveProfile(updated);
  }

  @override
  Future<void> addExperience(int xp) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(evolutionPoints: profile.evolutionPoints + xp);
    await saveProfile(updated);
  }

  @override
  Future<void> updateLevel(int level) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(level: level);
    await saveProfile(updated);
  }

  @override
  Future<void> setCharacterClass(String classId) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(currentClassType: classId);
    await saveProfile(updated);
  }

  @override
  Future<void> setSelectedTitle(String? titleId) async {
    final profile = await getProfile() ?? UserProfile();
    final updated = profile.copyWith(selectedTitleId: titleId);
    await saveProfile(updated);
  }
}