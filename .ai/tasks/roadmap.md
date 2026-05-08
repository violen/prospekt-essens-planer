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

## 🟢 Current Phase: Phase 10 - App Redesign & Modernization (In Progress)
**Goal:** Transition from functional MVP UI to a polished, modern application with pastel themes and improved UX.

### 1. Theming & Colors
- [ ] Implement a pastel-based color palette for Light Mode.
- [ ] Optimize Dark Mode for high contrast and readability.
- [ ] Define global `ThemeData` with updated typography.

### 2. UI/UX Refinement
- [ ] Improve navigation feedback and transitions.
- [ ] Polish suggestion cards with better visual hierarchy.
- [ ] Add loading skeletons for data-heavy views.

---

## 🔵 Upcoming Phases

### Phase 11: Interactive Onboarding & Tutorial
- Guided step-by-step tour for new users.

### Phase 12: Continuous Recognition Optimization
- Test-driven refinement using `sample_data/` assets.

---

## ✅ Completed Phases
- **Phase 1-6:** Core foundation, ingestion, monorepo refactoring, matching engine, verification.
- **Phase 7:** Advanced Product Recognition (Heuristic Filtering via `ProductClassifier`).
- **Phase 8:** Recipe & Ingredient Management (Autocomplete).
