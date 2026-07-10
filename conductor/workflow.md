# Development Workflow

## Branching Strategy
- **Feature Branching:** The `main` branch is kept stable. All new development, features, and bug fixes are done in isolated branches (e.g., `feature/login`, `bugfix/crash`) before being merged back into `main`.

## Commit Message Convention
- **Conventional Commits:** All commit messages must follow the Conventional Commits format to maintain a structured and readable history.
  - Examples: `feat: add login screen`, `fix: resolve crash on startup`, `docs: update readme`.

## Issue & Task Tracking
- **Conductor Tracks:** Task tracking is managed locally using the Conductor methodology. Work is organized into `tracks` within the repository, defining specific plans, PASSOS, and execution states.

## Code Review & PR Rules
- **Solo Developer:** Direct merges into the `main` branch are permitted. Code quality is managed through local testing, linting, and self-review. Pull Remissoes are optional but recommended for major architectural changes.
