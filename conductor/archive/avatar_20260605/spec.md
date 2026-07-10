# Specification: Herói Progression

## Overview
Implement the Herói leveling system. This involves calculating level-ups based on accumulated evolution points, persisting this data using Hive, and updating the Herói UI.

## Functional Requirements
- Implement Hive local database.
- Create models for User Profile and Herói.
- Implement leveling logic (e.g., XP thresholds for each level).
- Persist step count, points, and current level to Hive.
- Implement Herói UI (use Stitch MCP for visual styling).

## Acceptance Criteria
- App successfully reads/writes to Hive database.
- Herói level increments correctly when XP thresholds are met.
- UI reflects the current Herói state and uses Stitch styles.

## Out of Scope
- Server-side data sync.
