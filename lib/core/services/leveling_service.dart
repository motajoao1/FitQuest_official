class LevelingService {
  static const int baseXP = 100;

  // Calculates the level based on total XP
  static int calculateLevel(int totalXp) {
    int level = 1;
    int xpRequired = baseXP;
    int currentXp = totalXp;

    while (currentXp >= xpRequired) {
      currentXp -= xpRequired;
      level++;
      xpRequired = level * baseXP;
    }
    return level;
  }

  // Returns progress to next level as a percentage (0.0 to 1.0)
  static double getProgressToNextLevel(int totalXp) {
    int level = 1;
    int xpRequired = baseXP;
    int currentXp = totalXp;

    while (currentXp >= xpRequired) {
      currentXp -= xpRequired;
      level++;
      xpRequired = level * baseXP;
    }

    return currentXp / xpRequired;
  }

  static int getXpForCurrentLevel(int totalXp) {
    int level = 1;
    int xpRequired = baseXP;
    int currentXp = totalXp;

    while (currentXp >= xpRequired) {
      currentXp -= xpRequired;
      level++;
      xpRequired = level * baseXP;
    }

    return currentXp;
  }

  static int getXpRequiredForNextLevel(int totalXp) {
    int level = 1;
    int xpRequired = baseXP;
    int currentXp = totalXp;

    while (currentXp >= xpRequired) {
      currentXp -= xpRequired;
      level++;
      xpRequired = level * baseXP;
    }

    return xpRequired;
  }
}
