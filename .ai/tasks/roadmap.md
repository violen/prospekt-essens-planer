# Project Roadmap & Active Tasks

This is the consolidated source of truth for current development and future enhancements.

## ✅ Completed Phase: Phase 8 - Recipe & Ingredient Management
**Goal:** Enable users to define recipes with specific ingredients and use autocomplete based on market data.

### 1. Data Layer
- [x] Add `getUniqueProductNames` to `OfferRepository`.
- [x] Implement `getUniqueProductNames` in `OfferRepositoryImpl` (Drift).

### 2. State Management
- [x] Update `RecipeState` with `availableIngredients`.
- [x] Update `RecipeController` to fetch unique products on init.
- [x] Modify `addRecipe` to accept a list of ingredient names.

### 3. UI Redesign
- [x] Implement `ModalBottomSheet` for recipe creation.
- [x] Add `Autocomplete<String>` for ingredient input.
- [x] Display ingredients as removable `Chip` widgets.

## ✅ Completed Phase: Phase 9 - Semantic Normalization & Ready Meals
- **Normalization:** Map marketing variations ("Bio Kartoffeln") to base ingredients ("Kartoffel").
- **Ready Meals:** Support direct "Pizza" suggestions without predefined recipes.

---

## ✅ Completed Phase: Phase 10 - App Redesign & Modernization
**Goal:** Transition from functional MVP UI to a polished, modern application with pastel themes and improved UX.

### 1. Theming & Colors
- [x] Implement a pastel-based color palette for Light Mode.
- [x] Optimize Dark Mode for high contrast and readability.
- [x] Define global `ThemeData` with updated typography.

### 2. UI/UX Refinement
- [x] Improve navigation feedback and transitions.
- [x] Polish suggestion cards with better visual hierarchy.
- [x] Add loading skeletons for data-heavy views.

---

## ---

## 🟢 Current Phase: Phase 11 - Onboarding & Tutorial (In Progress)
**Goal:** Ensure new users understand the app's value proposition through a guided tour.

### 1. Tutorial Engine
- [ ] Integrate a tutorial/feature-tour package (e.g., 	utorial_coach_mark).
- [ ] Define highlight steps for Import, Recipes, and Suggestions.

### 2. First-Launch Logic
- [ ] Implement persistence to show tutorial only on first launch.

🔵 Upcoming Phases
- Guided step-by-step tour for new users.

### Phase 12: Continuous Recognition Optimization
- Test-driven refinement using `sample_data/` assets.

---

## ✅ Completed Phases
- **Phase 1-6:** Core foundation, ingestion, monorepo refactoring, matching engine, verification.
- **Phase 7:** Advanced Product Recognition (Heuristic Filtering via `ProductClassifier`).
- **Phase 8:** Recipe & Ingredient Management (Autocomplete).

