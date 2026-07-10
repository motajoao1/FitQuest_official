import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/boss_battle_provider.dart';
import '../models/damage_record.dart';
import 'dart:math';

class BossBattleScreen extends ConsumerStatefulWidget {
  const BossBattleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BossBattleScreen> createState() => _BossBattleScreenState();
}

class _BossBattleScreenState extends ConsumerState<BossBattleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _dealSimulatedDamage() {
    final record = DamageRecord(
      timestamp: DateTime.now(),
      activityType: 'PASSOS',
      amount: 500,
      damageDealt: 500,
    );
    
    // Corrigido: Passando apenas o campo int damageDealt
    ref.read(bossBattleProvider.notifier).dealDamage(record.damageDealt);
    
    final currentBoss = ref.read(bossBattleProvider);
    if (currentBoss == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chefe derrotado! Vitória épica!')),
        );
      }
    } else {
      _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bossEvent = ref.watch(bossBattleProvider);

    if (bossEvent == null) {
      return const Scaffold(
        body: Center(child: Text('Nenhum chefe ativo no momento')),
      );
    }

    final hpPercentage = bossEvent.currentHp / bossEvent.maxHp;
    final timeRemaining = bossEvent.timeLimit.difference(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Boss Battle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(bossEvent.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(bossEvent.description, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(sin(_shakeAnimation.value * pi) * 10, 0),
                  child: child,
                );
              },
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(color: Colors.red[100], shape: BoxShape.circle),
                child: const Icon(Icons.sports_martial_arts, size: 100, color: Colors.red),
              ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HP: ${bossEvent.currentHp} / ${bossEvent.maxHp}'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: hpPercentage.clamp(0.0, 1.0),
                  minHeight: 20,
                  color: hpPercentage > 0.5 ? Colors.green : (hpPercentage > 0.2 ? Colors.orange : Colors.red),
                  backgroundColor: Colors.grey[300],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Tempo Restante: ${timeRemaining.inDays}d ${timeRemaining.inHours.remainder(24)}h',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: bossEvent.currentHp > 0 ? _dealSimulatedDamage : null,
              icon: const Icon(Icons.flash_on),
              label: const Text('Simular Dano (Test)'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}