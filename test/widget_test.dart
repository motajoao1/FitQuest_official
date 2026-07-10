import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitquest/main.dart';
import 'package:fitquest/features/auth/screens/login_screen.dart';
import 'package:fitquest/core/repositories/repository_providers.dart';
import 'repository_test.dart'; // Import our mock repositories

void main() {
  group('Widget Tests', () {
    testWidgets('FitQuest app should start with login screen', (WidgetTester tester) async {
      // Create overrides for testing with mock repositories
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(MockUserProfileRepository()),
            achievementRepositoryProvider.overrideWithValue(MockAchievementRepository()),
            titleRepositoryProvider.overrideWithValue(MockTitleRepository()),
          ],
          child: const FitQuestApp(),
        ),
      );

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      // Verify that login screen elements are present
      // Note: This might need adjustment based on actual login screen implementation
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('should handle navigation properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(MockUserProfileRepository()),
            achievementRepositoryProvider.overrideWithValue(MockAchievementRepository()),
            titleRepositoryProvider.overrideWithValue(MockTitleRepository()),
          ],
          child: const FitQuestApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Test that the app doesn't crash and renders something
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('repository providers should work correctly', (WidgetTester tester) async {
      final mockUserRepo = MockUserProfileRepository();
      final mockAchievementRepo = MockAchievementRepository();
      final mockTitleRepo = MockTitleRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
            achievementRepositoryProvider.overrideWithValue(mockAchievementRepo),
            titleRepositoryProvider.overrideWithValue(mockTitleRepo),
          ],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                final userRepo = ref.read(userProfileRepositoryProvider);
                final achievementRepo = ref.read(achievementRepositoryProvider);
                final titleRepo = ref.read(titleRepositoryProvider);
                
                return Scaffold(
                  body: Column(
                    children: [
                      Text('User Repository: ${userRepo.runtimeType}'),
                      Text('Achievement Repository: ${achievementRepo.runtimeType}'),
                      Text('Title Repository: ${titleRepo.runtimeType}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that mock repositories are being used
      expect(find.text('User Repository: MockUserProfileRepository'), findsOneWidget);
      expect(find.text('Achievement Repository: MockAchievementRepository'), findsOneWidget);
      expect(find.text('Title Repository: MockTitleRepository'), findsOneWidget);
    });
  });
}
