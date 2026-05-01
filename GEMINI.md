# Project: Prospekt Essens Planer

## Project Overview
A Flutter-based mobile application (focused on Android) for planning meals based on supermarket brochures (Prospekte). The project is managed as a Melos monorepo.

## AI Development Workflow
We use the `.ai` folder to manage the development lifecycle:
- **Vision:** Defined in `.ai/vision.md`.
- **Tasks:** Tracked in `.ai/tasks/`.
- **Plans:** Detailed implementation plans in `.ai/plans/`.

## Strategic Mandates (Enforced Skills)
0.  **Workflow Validator:** Proactive audit as "Step 0" for any new task. Ensures a feature branch and an open MR/PR exist BEFORE writing code.
1.  **Workflow Guard:** Strictly FORBIDDEN to commit directly to protected branches (`main`, `master`, `develop`). All work must happen in feature branches.
2.  **Secret Safety:** Active scanning via `secret-detection`. NEVER commit secrets or API tokens. Rigorously protect `.env` files and `.github/token`.
3.  **Git Integrity:** Active enforcement via `git-hygiene`. Commits must be feature-specific and follow Conventional Commits. Always verify `git status` and `git diff` before committing.
4.  **Platform Focus:** Android is the primary and default target. Other platforms are opt-in only.

## Key Files & Directories
- `.ai/`: AI workspace context.
- `GEMINI.md`: This instruction file.
- `apps/prospekt_essens_planer/`: Main Flutter application.
- `melos.yaml`: Monorepo configuration.
- `.version-fox.toml`: Tool version management.
