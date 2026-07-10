import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/dungeon_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/user_profile.dart';
import '../../auth/providers/auth_provider.dart';

class DungeonScreen extends ConsumerStatefulWidget {
  const DungeonScreen({super.key});

  @override
  ConsumerState<DungeonScreen> createState() => _DungeonScreenState();
}

class _DungeonScreenState extends ConsumerState<DungeonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dungeonNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dungeonNotifierProvider);
    final authUser = ref.watch(authProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Masmorras'),
      ),
      body: CustomPaint(
        painter: GridPaperPainter(),
        child: state.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: RPGTheme.inkDark),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: RPGTheme.potionRed.withOpacity(0.1),
                          border: Border.all(color: RPGTheme.potionRed, width: 2),
                        ),
                        child: Text(state.error!, style: const TextStyle(color: RPGTheme.potionRed)),
                      ),
                    if (state.checkedInGym != null)
                      Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: RPGTheme.parchmentBackground,
                          border: Border.all(color: RPGTheme.inkDark, width: 3),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.castle, size: 60, color: RPGTheme.inkDark),
                            const SizedBox(height: 16),
                            Text('Masmorra atual:', style: GoogleFonts.architectsDaughter(color: RPGTheme.woodMedium, fontSize: 18)),
                            Text(state.checkedInGym!.name, style: GoogleFonts.architectsDaughter(color: RPGTheme.potionRed, fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final box = Hive.box<UserProfile>('userProfileBox');
                                final userId = authUser?.id ?? '0';
                                var profile = box.get(userId) ?? UserProfile();
                                profile.evolutionPoints += 150;
                                await box.put(userId, profile);
                                ref.read(dungeonNotifierProvider.notifier).checkout();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Treino na Masmorra concluído! +150 XP')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.fitness_center),
                              label: const Text('Treinar (+150 XP) e Sair'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: RPGTheme.potionRed,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text('Masmorras Próximas', style: textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.nearbyGyms.isEmpty
                          ? const Center(child: Text('Nenhuma masmorra mapeada por perto...'))
                          : ListView.builder(
                              itemCount: state.nearbyGyms.length,
                              itemBuilder: (context, index) {
                                final gym = state.nearbyGyms[index];
                                final isCheckedIn = state.checkedInGym?.id == gym.id;
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ListTile(
                                    title: Text(gym.name, style: GoogleFonts.architectsDaughter(fontSize: 20, fontWeight: FontWeight.bold)),
                                    subtitle: Text(gym.vicinity, style: GoogleFonts.patrickHand()),
                                    trailing: isCheckedIn 
                                      ? const Icon(Icons.close, color: RPGTheme.potionRed) 
                                      : OutlinedButton(
                                          onPressed: () => ref.read(dungeonNotifierProvider.notifier).checkIn(gym),
                                          child: const Text('Entrar'),
                                        ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(dungeonNotifierProvider.notifier).refresh(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class GridPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = RPGTheme.leatherLight.withOpacity(0.2)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 30) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 30) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}