# Specification: Adaptive Class & Skill System

## Overview
The Adaptive Class & Skill System introduces RPG-style classes (e.g., Warrior, Ranger, Mage) that dynamically align with the user's real-world fitness habits. Instead of manually selecting a class, the system analyzes the user's logged workouts, activities, and achievements (Titles) to assign or suggest a class that fits their playstyle.

## Core Features

### 1. Class Logic & Assignment
- **Classes Defined:**
  - **Warrior:** Focuses on strength training and gym workouts.
  - **Ranger:** Focuses on cardio, PASSOS, and DISTÂNCIA activities.
  - **Mage/Healer/Rogue (Flexible):** To be defined based on other activity types (e.g., yoga, recovery, flexibility).
- **Dynamic Assignment:** The backend will analyze the user's most frequent workouts and earned Titles to dynamically assign a class or suggest a class change. This means user actions directly dictate their RPG class.

### 2. Skill Trees & Perks
- **Class Modifiers:** Each class provides unique modifiers to the core XP and points calculation engine.
  - *Example:* A Warrior receives bonus XP for Gym Check-ins (Masmorra Exploration).
  - *Example:* A Ranger receives bonus XP for Step tracking (Hero's March).
- **Perks System:** Applying specific perks related to the assigned class to Recompensa users for consistency in their preferred activity types.

### 3. Class UI Integration
- **Herói Screen Update:** The `HeroScreen` will be updated to display the user's current Class visually, incorporating specific class colors, icons, or flair to reflect their status.
- **Class Details Screen:** A new `ClassDetailsScreen` will be created to:
  - Explain the benefits and perks of the user's current class.
  - Show progression or stats leading to the current class assignment.
  - Explain how classes can dynamically change based on shifting workout habits.
