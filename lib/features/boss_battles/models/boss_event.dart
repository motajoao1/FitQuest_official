class Reward {
  final String id;
  final String name;
  final int quantity;
  
  Reward({required this.id, required this.name, required this.quantity});
}

class BossEvent {
  final String id;
  final String name;
  final String description;
  final String artworkUrl;
  final int maxHp;
  final int currentHp;
  final DateTime timeLimit;
  final List<Reward> rewards; // Renomeado de Recompensas

  BossEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.artworkUrl,
    required this.maxHp,
    required this.currentHp,
    required this.timeLimit,
    required this.rewards,
  });

  BossEvent copyWith({
    String? id,
    String? name,
    String? description,
    String? artworkUrl,
    int? maxHp,
    int? currentHp,
    DateTime? timeLimit,
    List<Reward>? rewards,
  }) {
    return BossEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      artworkUrl: artworkUrl ?? this.artworkUrl,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      timeLimit: timeLimit ?? this.timeLimit,
      rewards: rewards ?? this.rewards,
    );
  }
}