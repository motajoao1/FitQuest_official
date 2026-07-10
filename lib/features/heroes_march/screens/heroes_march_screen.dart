import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/step_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../activities/screens/log_activity_screen.dart';
class HeroesMarchScreen extends ConsumerWidget {
  const HeroesMarchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(heroesMarchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('The Marcha do Herói'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Adventure Status Banner (Sketch style)
              Container(
                decoration: BoxDecoration(
                  color: RPGTheme.parchmentBackground,
                  border: Border.all(color: RPGTheme.inkDark, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: RPGTheme.woodMedium.withOpacity(0.2),
                      offset: const Offset(4, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.explore_outlined,
                      color: RPGTheme.inkDark,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOCALIZAÇÃO ATUAL',
                            style: GoogleFonts.architectsDaughter(
                              color: RPGTheme.woodMedium,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bosque dos Sussurros (Andar 1)',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.isSimulated)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: RPGTheme.potionRed, width: 2),
                        ),
                        child: Text(
                          'SIM',
                          style: GoogleFonts.architectsDaughter(
                            color: RPGTheme.potionRed,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Main Circular Progress for Step Tracking (Hand-drawn compass look)
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: RPGTheme.inkDark,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: RPGTheme.woodMedium,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Custom sketchy progress
                          SizedBox(
                            width: 230,
                            height: 230,
                            child: CircularProgressIndicator(
                              value: state.progress,
                              strokeWidth: 12,
                              backgroundColor: RPGTheme.leatherLight.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(RPGTheme.inkDark),
                            ),
                          ),
                          // Inner dash border
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: RPGTheme.leatherLight, width: 1),
                            ),
                          ),
                          // Step Count Details
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.directions_walk,
                                color: RPGTheme.inkDark,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 0, end: state.PASSOS),
                                duration: const Duration(milliseconds: 500),
                                builder: (context, value, child) {
                                  return Text(
                                    '$value',
                                    style: GoogleFonts.architectsDaughter(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: RPGTheme.potionRed,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'PASSOS',
                                style: GoogleFonts.architectsDaughter(
                                  color: RPGTheme.inkDark,
                                  fontSize: 16,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Progress Percentage
                              Text(
                                '${(state.progress * 100).toInt()}% CONCLUÍDO',
                                style: GoogleFonts.patrickHand(
                                  color: RPGTheme.woodMedium,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Evolution Points Display (Hand-drawn list)
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: RPGTheme.leatherLight, width: 2),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PONTOS DE EVOLUÇÃO (XP)',
                      style: GoogleFonts.architectsDaughter(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: RPGTheme.inkDark,
                      ),
                    ),
                    Text(
                      '+${state.evolutionPoints} XP',
                      style: GoogleFonts.architectsDaughter(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: RPGTheme.potionRed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics & Log grid (Sketchy cards)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: RPGTheme.inkDark, width: 1.5),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.local_fire_department_outlined, color: RPGTheme.inkDark, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'CALORIAS',
                            style: GoogleFonts.architectsDaughter(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(state.PASSOS * 0.04).toStringAsFixed(1)} kcal',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: RPGTheme.inkDark, width: 1.5),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Icon(Icons.explore_outlined, color: RPGTheme.inkDark, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'DISTÂNCIA',
                            style: GoogleFonts.architectsDaughter(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(state.PASSOS * 0.0008).toStringAsFixed(2)} km',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LogActivityScreen()),
          );
        },
        backgroundColor: RPGTheme.inkDark,
        icon: const Icon(Icons.add, color: RPGTheme.parchmentBackground),
        label: Text(
          'Registrar Atividade',
          style: GoogleFonts.architectsDaughter(
            color: RPGTheme.parchmentBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
