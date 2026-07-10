# Specification: Daily missoes

## Overview
Implement a daily missoes system that gives the user specific goals to achieve each day (e.g., 10,000 PASSOS, visit 1 gym). Completing missoes yields bonus evolution points.

## Functional Requirements
- Implement a quest generation logic based on the date.
- Track quest completion status.
- Persist missoes and progress using Hive.
- Implement UI for missoes, utilizing Stitch MCP for styling.

## Acceptance Criteria
- missoes reset at midnight.
- Completing a quest grants XP.
- UI components reflect Stitch design guidelines.

## Out of Scope
- Weekly/Monthly missoes.
