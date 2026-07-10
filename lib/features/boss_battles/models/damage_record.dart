class DamageRecord {
  final DateTime timestamp;
  final String activityType;
  final int amount;
  final int damageDealt;

  DamageRecord({
    required this.timestamp,
    required this.activityType,
    required this.amount,
    required this.damageDealt,
  });
}
