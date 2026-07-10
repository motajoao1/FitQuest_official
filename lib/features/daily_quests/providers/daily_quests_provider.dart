import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/quest_model.dart';
import 'package:intl/intl.dart';

final dailyQuestsProvider = NotifierProvider<DailymissoesNotifier, List<Quest>>(DailymissoesNotifier.new);

class DailymissoesNotifier extends Notifier<List<Quest>> {
  late Box<Quest> _missoesBox;
  late Box<String> _appStateBox;
  
  static const String _lastQuestDateKey = 'lastQuestDate';

  @override
  List<Quest> build() {
    _missoesBox = Hive.box<Quest>('missoesBox');
    _appStateBox = Hive.box<String>('appStateBox');
    return _initializemissoes();
  }

  List<Quest> _initializemissoes() {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDateStr = _appStateBox.get(_lastQuestDateKey);

    if (lastDateStr != todayStr) {
      _generateDailymissoes();
      _appStateBox.put(_lastQuestDateKey, todayStr);
    }
    return _missoesBox.values.toList();
  }

  void _generateDailymissoes() {
    // Clear old missoes
    _missoesBox.clear();

    final newmissoes = [
      Quest(
        id: 'quest_PASSOS',
        title: "Hero's March",
        description: 'Walk 10,000 PASSOS today.',
        targetValue: 10000,
        xpRecompensa: 50,
      ),
      Quest(
        id: 'quest_Masmorra',
        title: 'Masmorra Explorer',
        description: 'Complete 1 Masmorra Check-in.',
        targetValue: 1,
        xpRecompensa: 30,
      ),
      Quest(
        id: 'quest_hydration',
        title: 'Elixir da Vida',
        description: 'Beba 8 copos de água.',
        targetValue: 8,
        xpRecompensa: 20,
      ),
    ];

    for (var quest in newmissoes) {
      _missoesBox.put(quest.id, quest);
    }
  }

  void updateQuestProgress(String id, int addedValue) {
    final questIndex = state.indexWhere((q) => q.id == id);
    if (questIndex != -1) {
      final quest = state[questIndex];
      if (quest.isCompleted) return; // already CONCLUÍDO

      final newValue = quest.currentValue + addedValue;
      final isCompleted = newValue >= quest.targetValue;

      final updatedQuest = quest.copyWith(
        currentValue: newValue,
        isCompleted: isCompleted,
      );

      _missoesBox.put(id, updatedQuest);
      
      state = [
        for (final q in state)
          if (q.id == id) updatedQuest else q
      ];

      if (isCompleted) {
        // ref.read(levelingServiceProvider).addExperience(updatedQuest.xpRecompensa); // TODO: implement XP addition
      }
    }
  }

  void setQuestProgress(String id, int newValue) {
    final questIndex = state.indexWhere((q) => q.id == id);
    if (questIndex != -1) {
      final quest = state[questIndex];
      if (quest.isCompleted) return;

      final isCompleted = newValue >= quest.targetValue;

      final updatedQuest = quest.copyWith(
        currentValue: newValue,
        isCompleted: isCompleted,
      );

      _missoesBox.put(id, updatedQuest);
      
      state = [
        for (final q in state)
          if (q.id == id) updatedQuest else q
      ];

      if (isCompleted) {
        // ref.read(levelingServiceProvider).addExperience(updatedQuest.xpRecompensa); // TODO: implement XP addition
      }
    }
  }
}
