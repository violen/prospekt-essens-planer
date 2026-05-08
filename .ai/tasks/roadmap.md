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

---

## 🔵 Upcoming Phases

### Phase 9: Semantic Normalization & Ready Meals
- **Normalization:** Map marketing variations ("Bio Kartoffeln") to base ingredients ("Kartoffel").
- **Ready Meals:** Support direct "Pizza" suggestions without predefined recipes.

### Phase 10: App Redesign (Modernization)
- Pastel color themes for Light Mode, optimized Dark Mode.
- UX polish and improved navigation.

### Phase 11: Interactive Onboarding & Tutorial
- Guided step-by-step tour for new users.

### Phase 12: Continuous Recognition Optimization
- Test-driven refinement using `sample_data/` assets.

---

## ✅ Completed Phases
- **Phase 1-6:** Core foundation, ingestion, monorepo refactoring, matching engine, verification.
- **Phase 7:** Advanced Product Recognition (Heuristic Filtering via `ProductClassifier`).
