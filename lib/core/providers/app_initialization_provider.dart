library app_initialization;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/repository_providers.dart';

/// Provider that manages app-wide initialization
class AppInitializationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    await _initializeRepositories();
  }

  Future<void> _initializeRepositories() async {
    // Initialize all repositories
    final repositoryManager = ref.read(repositoryManagerProvider);
    await repositoryManager.initializeAll();
  }
}

final appInitializationProvider = AsyncNotifierProvider<AppInitializationNotifier, void>(() {
  return AppInitializationNotifier();
});