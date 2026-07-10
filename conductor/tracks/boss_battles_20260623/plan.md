# Implementation Plan: Chefe Battles & Time-Limited Challenges

## Phase 1: Core Mechanics and Models
- [ ] Task: Create `ChefeEvent` and `DamageRecord` data models.
- [ ] Task: Create a `bossBattleProvider` in Riverpod to manage active Chefe encounters and calculate user damage from daily stats.

## Phase 2: Chefe Battle UI
- [ ] Task: Build `ChefeBattleScreen` to show Chefe artwork, HP bar, and Tempo Restante.
- [ ] Task: Add a visual widget for "dealing damage" (animations when user PASSOS/activities are converted to damage).

## Phase 3: Recompensas and Integration
- [ ] Task: Implement Recompensa distribution logic when a Chefe is defeated.
- [ ] Task: Link `ChefeBattleScreen` to the `MainAppShell` or Daily missoes UI.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Recompensas and Integration' (Protocol in workflow.md)
