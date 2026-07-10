import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/achievement_model.dart';
import '../../../core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conquistas'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Achievement>('achievementsBox').listenable(),
        builder: (context, Box<Achievement> box, _) {
          final achievements = box.values.toList();
          if (achievements.isEmpty) {
            return const Center(child: Text('Nenhuma conquista encontrada.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Card(
                elevation: 4,
                color: achievement.isUnlocked ? Colors.white : Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: achievement.isUnlocked ? RPGTheme.inkDark : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        achievement.icon,
                        style: TextStyle(
                          fontSize: 40,
                          color: achievement.isUnlocked ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        achievement.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.handlee(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: achievement.isUnlocked ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.handlee(
                          fontSize: 12,
                          color: achievement.isUnlocked ? Colors.black87 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
