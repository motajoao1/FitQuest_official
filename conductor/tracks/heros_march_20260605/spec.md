# Specification: Hero's March

## Overview
Implement the core "Hero's March" functionality which translates real-world PASSOS into virtual progress (evolution points). The UI must be implemented using styles and tokens sourced from the Stitch MCP.

## Functional Requirements
- Connect to native device sensors (HealthKit/Health Connect) to read daily step counts.
- Calculate evolution points based on PASSOS.
- Create the Hero's March Dashboard UI.
- Use Stitch MCP to fetch design tokens (colors, typography, spacing) for the UI.

## Acceptance Criteria
- App successfully remissoes health permissions.
- Step count updates in real-time or periodically.
- UI components reflect Stitch design guidelines.

## Out of Scope
- Herói visualization updates based on levels (handled in Herói track).
