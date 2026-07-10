import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/daily_quests_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyQuestsScreen extends ConsumerWidget {
  const DailyQuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missoes = ref.watch(dailyQuestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quadro de missoes'),
      ),
      body: missoes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/monster.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No missoes posted today...',
                    style: GoogleFonts.architectsDaughter(
                      fontSize: 24,
                      color: RPGTheme.woodMedium,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              itemCount: missoes.length,
              itemBuilder: (context, index) {
                final quest = missoes[index];
                final progress = quest.targetValue > 0
                    ? quest.currentValue / quest.targetValue
                    : 0.0;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // The Quest Card (Piece of paper)
                      Container(
                        decoration: BoxDecoration(
                          color: RPGTheme.parchmentBackground,
                          border: Border.all(color: RPGTheme.woodMedium, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10), // Space for the pin
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      quest.title,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                                        decorationThickness: 2.0,
                                      ),
                                    ),
                                  ),
                                  if (quest.isCompleted)
                                    Transform.rotate(
                                      angle: -0.2,
                                      child: Text(
                                        'DONE',
                                        style: GoogleFonts.architectsDaughter(
                                          color: RPGTheme.potionRed,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              Text(
                                quest.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 20.0),
                              // Hand-drawn style progress indicator
                              Container(
                                height: 16,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: RPGTheme.inkDark, width: 1.5),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                                        height: double.infinity,
                                        color: quest.isCompleted ? RPGTheme.woodMedium : RPGTheme.leatherLight.withOpacity(0.5),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${quest.currentValue} / ${quest.targetValue}',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                    'Recompensa: ${quest.xpRecompensa} XP',
                                    style: GoogleFonts.architectsDaughter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: RPGTheme.inkDark,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      
                      // Push Pin drawn at the top center
                      Positioned(
                        top: -10,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: RPGTheme.potionRed,
                            shape: BoxShape.circle,
                            border: Border.all(color: RPGTheme.inkDark, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(1, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
