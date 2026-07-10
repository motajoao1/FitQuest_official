library repository_providers;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_interfaces.dart';
import 'hive_user_profile_repository.dart';
import 'hive_achievement_repository.dart';
import 'hive_title_repository.dart';

import '../../features/auth/providers/auth_provider.dart';

// Repository providers using Riverpod
final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final authUser = ref.watch(authProvider);
  return HiveUserProfileRepository(userId: authUser?.id ?? '0');
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return HiveAchievementRepository();
});

final titleRepositoryProvider = Provider<TitleRepository>((ref) {
  return HiveTitleRepository();
});

// Repository manager for initialization
class RepositoryManager {
  final List<Repository> _repositories = [];
  
  void addRepository(Repository repository) {
    _repositories.add(repository);
  }
  
  Future<void> initializeAll() async {
    for (final repository in _repositories) {
      await repository.init();
    }
  }
  
  Future<void> closeAll() async {
    for (final repository in _repositories) {
      await repository.close();
    }
  }
}

final repositoryManagerProvider = Provider<RepositoryManager>((ref) {
  final manager = RepositoryManager();
  
  // Add all repositories
  manager.addRepository(ref.read(userProfileRepositoryProvider));
  manager.addRepository(ref.read(achievementRepositoryProvider));
  manager.addRepository(ref.read(titleRepositoryProvider));
  
  return manager;
});