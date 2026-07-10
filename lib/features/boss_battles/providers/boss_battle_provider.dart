import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/boss_event.dart'; // Nome do arquivo corrigido

final bossBattleProvider = NotifierProvider<BossBattleNotifier, BossEvent?>(BossBattleNotifier.new);

class BossBattleNotifier extends Notifier<BossEvent?> {
  @override
  BossEvent? build() {
    return BossEvent(
      id: 'boss_1',
      name: 'O Rei Preguiça',
      description: 'Um gigante preguiçoso que quer te manter no sofá.',
      artworkUrl: 'assets/bosses/sloth_king.png',
      maxHp: 10000,
      currentHp: 10000,
      timeLimit: DateTime.now().add(const Duration(days: 3)),
      rewards: [
        Reward(id: 'xp_potion', name: 'XP Potion', quantity: 1),
        Reward(id: 'gold', name: 'Gold Coins', quantity: 500),
      ],
    );
  }

  void dealDamage(int damage) { // Ajuste conforme seu DamageRecord
    if (state == null) return;
    
    int newHp = state!.currentHp - damage;
    if (newHp <= 0) {
      state = null; // Boss derrotado!
    } else {
      state = state!.copyWith(currentHp: newHp);
    }
  }
}