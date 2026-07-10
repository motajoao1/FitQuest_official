# Specification: Titles & Achievements System

## Overview
The Titles & Achievements System aims to boost user engagement by Recompensaing them for their activities, such as step tracking and gym check-ins. Users will unlock achievements (badges) and specific titles they can display on their profile.

## Key Features
1. **Achievement and Title Models**: Data representation for achievements and titles.
2. **Achievement Engine (AchievementService)**: A background or reactive service that tracks milestones (PASSOS, check-ins) and triggers achievement unlocks.
3. **Achievements UI**: A dedicated screen (`AchievementsScreen`) to view all available and unlocked badges.
4. **Profile Customization**: Update the `HeroScreen` so users can equip unlocked Titles to display on their profile.
5. **Data Persistence**: Store unlocked achievements and titles locally using Hive.
6. **Notifications**: In-app feedback such as snackbars or modal animations when an achievement is newly unlocked.

## Data Structures (Draft)
- **Achievement**: `id`, `name`, `description`, `icon`, `isUnlocked`, `unlockedAt`.
- **Title**: `id`, `name`, `isUnlocked`.

## Success Criteria
- Achievements are correctly tracked and unlocked based on activity.
- Users can view their unlocked badges and titles in the UI.
- Selected titles are persisted and correctly displayed.
- The user is notified when an achievement is unlocked.
