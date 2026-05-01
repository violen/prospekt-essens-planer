# Project: Prospekt Essens Planer

## Project Overview
A Flutter-based mobile application (focused on Android) for planning meals based on supermarket brochures (Prospekte). The project is managed as a Melos monorepo.

## AI Development Workflow
We use the `.ai` folder to manage the development lifecycle:
- **Vision:** Defined in `.ai/vision.md`.
- **Tasks:** Tracked in `.ai/tasks/`.
- **Plans:** Detailed implementation plans in `.ai/plans/`.

## Strategic Mandates
- **Secret Safety:** NEVER log, print, or commit secrets, API keys, or sensitive credentials. Rigorously protect `.env` files and `.github/token`.
- **Git Integrity:** Follow Conventional Commits. Review diffs before staging.
- **Platform Focus:** Android is the primary and default target. Other platforms are opt-in only.

## Key Files & Directories
- `.ai/`: AI workspace context.
- `GEMINI.md`: This instruction file.
- `apps/prospekt_essens_planer/`: Main Flutter application.
- `melos.yaml`: Monorepo configuration.
- `.version-fox.toml`: Tool version management.
