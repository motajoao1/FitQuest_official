import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dynamic_quest_model.dart';
import '../providers/dynamic_quest_provider.dart';
import '../../../core/constants/enums.dart';
import '../../../core/theme/app_theme.dart';

class DynamicQuestScreen extends ConsumerWidget {
  const DynamicQuestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questsAsync = ref.watch(dynamicQuestManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quadro de Missões',
          style: GoogleFonts.cinzel(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(dynamicQuestManagerProvider.notifier).refresh(),
            tooltip: 'Atualizar Missões',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              switch (value) {
                case 'regenerate':
                  await ref.read(dynamicQuestManagerProvider.notifier).regenerateAllQuests();
                  break;
                case 'special':
                  await ref.read(dynamicQuestManagerProvider.notifier).generateSpecialQuest(
                    eventTheme: 'Winter Challenge',
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'regenerate',
                child: Text('🔄 Gerar Novas Missões'),
              ),
              const PopupMenuItem(
                value: 'special',
                child: Text('✨ Criar Missão Especial'),
              ),
            ],
          ),
        ],
      ),
      body: questsAsync.when(
        data: (quests) => _buildQuestBoard(context, ref, quests),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  Widget _buildQuestBoard(BuildContext context, WidgetRef ref, List<DynamicQuest> allQuests) {
    final dailyQuests = allQuests.where((q) => q.type == QuestType.daily).toList();
    final weeklyQuests = allQuests.where((q) => q.type == QuestType.weekly).toList();
    final specialQuests = allQuests.where((q) => q.type == QuestType.special).toList();

    if (allQuests.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quest Statistics Header
          _buildQuestStats(context, allQuests),
          const SizedBox(height: 24),
          
          // Daily Quests Section
          if (dailyQuests.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Missões Diárias',
              '📅',
              'Reseta à meia-noite',
            ),
            const SizedBox(height: 16),
            ...dailyQuests.map((quest) => _buildQuestCard(context, ref, quest)),
            const SizedBox(height: 24),
          ],
          
          // Weekly Quests Section
          if (weeklyQuests.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Desafios Semanais',
              '📋',
              'Reseta semanalmente',
            ),
            const SizedBox(height: 16),
            ...weeklyQuests.map((quest) => _buildQuestCard(context, ref, quest)),
            const SizedBox(height: 24),
          ],
          
          // Special Quests Section
          if (specialQuests.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Eventos Especiais',
              '✨',
              'Por tempo limitado!',
            ),
            const SizedBox(height: 16),
            ...specialQuests.map((quest) => _buildQuestCard(context, ref, quest)),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestStats(BuildContext context, List<DynamicQuest> quests) {
    final completed = quests.where((q) => q.isCompleted).length;
    final total = quests.length;
    final completionRate = total > 0 ? completed / total : 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            RPGTheme.parchmentBackground,
            RPGTheme.parchmentBackground.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: RPGTheme.woodMedium, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progresso das Missões',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                color: RPGTheme.inkDark,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: completionRate,
                backgroundColor: RPGTheme.leatherLight,
                valueColor: AlwaysStoppedAnimation<Color>(
                  completionRate >= 1.0 ? Colors.green : RPGTheme.woodMedium,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$completed/$total missões concluídas',
                  style: GoogleFonts.architectsDaughter(
                    fontSize: 14,
                    color: RPGTheme.woodMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularProgressIndicator(
            value: completionRate,
            backgroundColor: RPGTheme.leatherLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              completionRate >= 1.0 ? Colors.green : RPGTheme.woodMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String icon, String subtitle) {
    return Row(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: RPGTheme.inkDark,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.architectsDaughter(
                  fontSize: 14,
                  color: RPGTheme.woodMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestCard(BuildContext context, WidgetRef ref, DynamicQuest quest) {
    final progress = quest.completionPercentage;
    final timeRemaining = quest.timeRemaining;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Main Quest Card
          Container(
            decoration: BoxDecoration(
              color: RPGTheme.parchmentBackground,
              border: Border.all(
                color: _getDifficultyColor(quest.difficulty),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: quest.isCompleted ? null : () => _showQuestDetails(context, ref, quest),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quest Header
                    Row(
                      children: [
                        // Category Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(quest.difficulty).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            quest.category.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Quest Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      quest.title,
                                      style: GoogleFonts.cinzel(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                  ),
                                  _buildDifficultyBadge(quest.difficulty),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                quest.category.displayName,
                                style: GoogleFonts.architectsDaughter(
                                  fontSize: 14,
                                  color: RPGTheme.woodMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Quest Description
                    Text(
                      quest.description,
                      style: GoogleFonts.architectsDaughter(
                        fontSize: 14,
                        color: RPGTheme.woodMedium,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Progress Section
                    if (!quest.isCompleted) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Progresso: ${quest.currentValue}/${quest.targetValue}',
                                  style: GoogleFonts.architectsDaughter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: RPGTheme.leatherLight,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getDifficultyColor(quest.difficulty),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: GoogleFonts.cinzel(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getDifficultyColor(quest.difficulty),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Lower section with time and rewards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Time remaining
                          if (timeRemaining.inHours > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: timeRemaining.inHours < 24 
                                    ? Colors.orange.withOpacity(0.2)
                                    : Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _formatTimeRemaining(timeRemaining),
                                style: GoogleFonts.architectsDaughter(
                                  fontSize: 12,
                                  color: timeRemaining.inHours < 24 
                                      ? Colors.orange[700]
                                      : Colors.blue[700],
                                ),
                              ),
                            ),
                          
                          // XP Reward
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${quest.xpReward} XP',
                                  style: GoogleFonts.architectsDaughter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Completed state
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'MISSÃO CONCLUÍDA!',
                              style: GoogleFonts.cinzel(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          
          // Personalized Quest Pin/Badge
          if (quest.isPersonalized)
            Positioned(
              top: -8,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(QuestDifficulty difficulty) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getDifficultyColor(difficulty),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            difficulty.icon,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            difficulty.displayName.split(' ').first, // Just "Novice", "Hero", etc.
            style: GoogleFonts.architectsDaughter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return Colors.green;
      case QuestDifficulty.medium:
        return Colors.blue;
      case QuestDifficulty.hard:
        return Colors.orange;
      case QuestDifficulty.epic:
        return Colors.purple;
      case QuestDifficulty.legendary:
        return Colors.red;
    }
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return 'Expirando em breve!';
    }
  }

  void _showQuestDetails(BuildContext context, WidgetRef ref, DynamicQuest quest) {
    showDialog(
      context: context,
      builder: (context) => QuestDetailDialog(quest: quest, ref: ref),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: RPGTheme.woodMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Sem Missões Ativas',
            style: GoogleFonts.cinzel(
              fontSize: 24,
                color: RPGTheme.inkDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seu quadro de missões está vazio.\nAtualize para gerar novas missões!',
            textAlign: TextAlign.center,
            style: GoogleFonts.architectsDaughter(
              fontSize: 16,
              color: RPGTheme.woodMedium,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.read(dynamicQuestManagerProvider.notifier).regenerateAllQuests(),
            icon: const Icon(Icons.refresh),
            label: const Text('Gerar Missões'),
            style: ElevatedButton.styleFrom(
              backgroundColor: RPGTheme.woodMedium,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Erro no Quadro de Missões',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Falha ao carregar as missões.\nPor favor, tente novamente mais tarde.',
            textAlign: TextAlign.center,
            style: GoogleFonts.architectsDaughter(
              fontSize: 16,
              color: Colors.red[500],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class QuestDetailDialog extends StatelessWidget {
  final DynamicQuest quest;
  final WidgetRef ref;

  const QuestDetailDialog({
    super.key,
    required this.quest,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text(quest.category.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              quest.title,
              style: GoogleFonts.cinzel(fontSize: 18),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quest.description,
            style: GoogleFonts.architectsDaughter(fontSize: 16),
          ),
          const SizedBox(height: 16),
          
          // Requirements
          if (quest.requirements.isNotEmpty) ...[
            Text(
              'Requisitos:',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...quest.requirements.map(
              (req) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  '• ${req.description ?? req.type}: ${req.minValue}',
                  style: GoogleFonts.architectsDaughter(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Rewards
          if (quest.rewards.isNotEmpty) ...[
            Text(
              'Recompensas:',
              style: GoogleFonts.cinzel(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...quest.rewards.map(
              (reward) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  '• ${reward.description ?? reward.type}: ${reward.value}',
                  style: GoogleFonts.architectsDaughter(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          Text(
            'Recompensa de XP: ${quest.xpReward}',
            style: GoogleFonts.architectsDaughter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        if (!quest.isCompleted)
          ElevatedButton(
            onPressed: () {
              ref.read(dynamicQuestManagerProvider.notifier).completeQuest(quest.id);
              Navigator.of(context).pop();
            },
            child: const Text('Marcar como Concluída'),
          ),
      ],
    );
  }
}