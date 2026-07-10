import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import 'package:hive/hive.dart';
import '../../../core/models/user_profile.dart';

// Mocked database of users
const _mockUsers = [
  AuthUser(
    id: '1',
    email: 'free@test.com',
    Senha: '123',
    accountLevel: AccountLevel.free,
  ),
  AuthUser(
    id: '2',
    email: 'premium@test.com',
    Senha: '123',
    accountLevel: AccountLevel.premium,
  ),
  AuthUser(
    id: '3',
    email: 'admin@test.com',
    Senha: '123',
    accountLevel: AccountLevel.admin,
  ),
];

class AuthNotifier extends Notifier<AuthUser?> {
  @override
  AuthUser? build() {
    return null;
  }

  Future<void> login(String email, String Senha) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _mockUsers.firstWhere(
        (u) => u.email == email && u.Senha == Senha,
      );

      // Initialize mock profiles for testing purposes
      final box = Hive.box<UserProfile>('userProfileBox');
      var profile = box.get(user.id);
      
      if (profile == null) {
        profile = UserProfile();
        if (user.accountLevel == AccountLevel.premium) {
          profile.currentClassType = 'mage';
          profile.evolutionPoints = 2500;
        } else if (user.accountLevel == AccountLevel.admin) {
          profile.currentClassType = 'warrior';
          profile.evolutionPoints = 10000;
        }
        await box.put(user.id, profile);
      } else if (profile.currentClassType == 'novice' && profile.evolutionPoints == 0) {
        // Apply mock data to profiles that were created before the mock data logic was added
        if (user.accountLevel == AccountLevel.premium) {
          profile.currentClassType = 'mage';
          profile.evolutionPoints = 2500;
          await box.put(user.id, profile);
        } else if (user.accountLevel == AccountLevel.admin) {
          profile.currentClassType = 'warrior';
          profile.evolutionPoints = 10000;
          await box.put(user.id, profile);
        }
      }
      
      state = user;
    } catch (e) {
      throw Exception('Invalid email or Senha');
    }
  }

  void logout() {
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthUser?>(AuthNotifier.new);
