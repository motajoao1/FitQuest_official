import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/models/title_model.dart';
import '../../../core/services/leveling_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../achievements/screens/achievements_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/providers/auth_provider.dart';
import '../../classes/providers/class_provider.dart';
import '../../classes/screens/class_details_screen.dart';

// Classe renomeada para AvatarScreen para bater com o construtor do MainAppShell
class AvatarScreen extends ConsumerWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authProvider);
    final currentClass = ref.watch(classProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha do Herói'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pergaminho.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<UserProfile>('userProfileBox').listenable(),
          builder: (context, Box<UserProfile> box, _) {
            final userId = authUser?.id ?? '0';
            final userProfile = box.get(userId) ?? UserProfile();
            final currentLevel = LevelingService.calculateLevel(userProfile.evolutionPoints);
            final progress = LevelingService.getProgressToNextLevel(userProfile.evolutionPoints);
            final xpForCurrent = LevelingService.getXpForCurrentLevel(userProfile.evolutionPoints);
            final xpRequired = LevelingService.getXpRequiredForNextLevel(userProfile.evolutionPoints);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: RPGTheme.inkDark, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: RPGTheme.woodMedium, width: 1),
                        ),
                        child: Center(
                          child: Icon(
                            _getIconData(currentClass.iconName),
                            size: 80,
                            color: RPGTheme.inkDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        '___________________________',
                        style: TextStyle(color: RPGTheme.leatherLight, fontSize: 20),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showTitleSelection(context, ref, userProfile, Hive.box<TitleModel>('titlesBox')),
                            child: Text(
                              _getSelectedTitleName(userProfile, Hive.box<TitleModel>('titlesBox')),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dotted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ClassDetailsScreen()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Classe: ${currentClass.name}',
                                  style: GoogleFonts.macondo(
                                    color: RPGTheme.potionRed,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dotted,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.info_outline, size: 16, color: RPGTheme.potionRed),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('NÍVEL: ', style: Theme.of(context).textTheme.headlineMedium),
                      Text(
                        '$currentLevel',
                        style: GoogleFonts.medievalSharp(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: RPGTheme.potionRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: RPGTheme.inkDark, width: 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pontos de Evolução (XP)', style: Theme.of(context).textTheme.titleLarge),
                            Text('$xpForCurrent / $xpRequired XP', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          children: [
                            Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: RPGTheme.inkDark, width: 2),
                              ),
                              child: CustomPaint(painter: HatchPainter()),
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  width: constraints.maxWidth * progress,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: RPGTheme.woodMedium.withOpacity(0.3),
                                    border: const Border(
                                      right: BorderSide(color: RPGTheme.inkDark, width: 2),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  OutlinedButton.icon(
                    onPressed: () {
                      final box = Hive.box<UserProfile>('userProfileBox');
                      final userId = authUser?.id ?? '0';
                      var profile = box.get(userId) ?? UserProfile();
                      profile.evolutionPoints += 50;
                      box.put(userId, profile);
                    },
                    icon: const Icon(Icons.fitness_center),
                    label: const Text('Treinar (+50 XP)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: RPGTheme.inkDark,
                      side: const BorderSide(color: RPGTheme.inkDark, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      textStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                      );
                    },
                    icon: const Icon(Icons.emoji_events),
                    label: const Text('Ver Conquistas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RPGTheme.inkDark,
                      foregroundColor: RPGTheme.parchmentBackground,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  if (authUser != null) ...[
                    const SizedBox(height: 30),
                    Text(
                      'Logado como: ${authUser.email}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Nível da Conta: ${authUser.accountLevel.name.toUpperCase()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RPGTheme.potionRed,
                        foregroundColor: RPGTheme.parchmentBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getSelectedTitleName(UserProfile profile, Box<TitleModel> titlesBox) {
    if (profile.selectedTitleId == null) return 'Nenhum Título Equipado';
    final title = titlesBox.get(profile.selectedTitleId);
    return title?.name ?? 'Título Desconhecido';
  }

  void _showTitleSelection(BuildContext context, WidgetRef ref, UserProfile profile, Box<TitleModel> titlesBox) {
    showModalBottomSheet(
      context: context,
      backgroundColor: RPGTheme.parchmentBackground,
      builder: (context) {
        final unlockedTitles = titlesBox.values.where((t) => t.isUnlocked).toList();
        if (unlockedTitles.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Nenhum título desbloqueado. Continue treinando!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        return ListView.builder(
          itemCount: unlockedTitles.length,
          itemBuilder: (context, index) {
            final title = unlockedTitles[index];
            return ListTile(
              title: Text(title.name, style: Theme.of(context).textTheme.titleLarge),
              trailing: profile.selectedTitleId == title.id ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                final box = Hive.box<UserProfile>('userProfileBox');
                final userId = ref.read(authProvider)?.id ?? '0';
                box.put(userId, profile.copyWith(selectedTitleId: title.id));
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'fitness_center': return Icons.fitness_center;
      case 'directions_run': return Icons.directions_run;
      case 'self_improvement': return Icons.self_improvement;
      default: return Icons.person_outline;
    }
  }
}

class HatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RPGTheme.leatherLight.withOpacity(0.5)
      ..strokeWidth = 1;
    for (double i = 0; i < size.width + size.height; i += 8) {
      canvas.drawLine(Offset(i, 0), Offset(i - size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}