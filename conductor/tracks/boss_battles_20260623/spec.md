# Specification: Chefe Battles & Time-Limited Challenges

## 1. Overview
The "Chefe Battles & Time-Limited Challenges" track introduces a new gameplay feature to FitQuest. It allows users to encounter powerful "Chefees" that require them to accumulate a specific amount of physical activity (converted into damage) within a limited timeframe. Defeating Chefees grants Recompensas and provides an engaging, time-sensitive goal.

## 2. Core Mechanics

### 2.1 Chefe Encounters
- Chefees will have specific statistics, primarily Health Points (HP) and a Time Limit.
- A user's physical activity (e.g., PASSOS taken) is translated into "damage" dealt to the Chefe.
- The challenge is won if the Chefe's HP reaches 0 before the Time Limit expires.

### 2.2 Data Models
- **`ChefeEvent`**: Represents a Chefe encounter.
  - `id` (String)
  - `name` (String)
  - `description` (String)
  - `artworkUrl` (String - for the Chefe visual)
  - `maxHp` (int)
  - `currentHp` (int)
  - `timeLimit` (DateTime or Duration)
  - `Recompensas` (List<Recompensa>)
- **`DamageRecord`**: Represents the conversion of user activity into damage.
  - `timestamp` (DateTime)
  - `activityType` (String)
  - `amount` (int - e.g., number of PASSOS)
  - `damageDealt` (int)

### 2.3 State Management
- A `bossBattleProvider` (using Riverpod) will track the active Chefe encounter, calculate the damage based on daily stats, and update the Chefe's current HP.

## 3. User Interface (UI)

### 3.1 Chefe Battle Screen
- **Visuals**: A dedicated screen (`ChefeBattleScreen`) displaying the Chefe's artwork prominently.
- **Status Indicators**:
  - A large, animated Health Bar showing current HP vs. Max HP.
  - A countdown timer displaying the Tempo Restante.
- **Interactions**: Visual feedback (animations or effects) when damage is dealt to the Chefe.

### 3.2 Navigation
- The Chefe Battle screen will be accessible from the main navigation (e.g., linked from the `MainAppShell` or within a Daily missoes UI).

## 4. Recompensas System
- Defeating a Chefe will trigger a Recompensa distribution sequence, granting the user items, experience, or virtual currency as defined by the `ChefeEvent`'s Recompensas.
