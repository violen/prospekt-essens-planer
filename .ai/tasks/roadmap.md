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

## ✅ Completed Phase: Phase 11 - Onboarding & Tutorial
**Goal:** Ensure new users understand the app's value proposition through a guided tour.

### 1. Tutorial Engine
- [x] Integrate a tutorial/feature-tour package (`tutorial_coach_mark`).
- [x] Define highlight steps for Import, Recipes, and Suggestions.

### 2. First-Launch Logic
- [x] Implement persistence to show tutorial only on first launch (`shared_preferences`).
- [x] Added a replay mechanism via a help icon in the Weekly Planner.


---

## ✅ Completed Phase: Phase 12 - Smart Document Scanning
**Goal:** Improve OCR quality by implementing a smart document scanner for photography.

### 1. Document Scanner API
- [x] Integrate Google ML Kit Document Scanner API (`google_mlkit_document_scanner`).
- [x] Replace basic `image_picker` for brochures with the scanner UI.

### 2. Post-Processing
- [x] Implement automatic cropping and perspective correction (provided by native scanner UI).


---

## ## 🟢 Current Phase: Phase 13 - Continuous Recognition Optimization (Started)
**Goal:** Ensure 100% match rate for Fix-Products using real-world brochure samples.

### 1. Test Environment
- [ ] user adds raw PDFs/Photos to sample_data/.
- [ ] AI embeds these as temporary assets in the debug build.

### 2. Iterative Improvement
- [ ] automated tests are written against specific real-world samples.

---

## 🔵 Upcoming Phases
- Guided step-by-step tour for new users.

### Phase 13: Continuous Recognition Optimization
- Test-driven refinement using `sample_data/` assets.

---

## ✅ Completed Phases
- **Phase 1-6:** Core foundation, ingestion, monorepo refactoring, matching engine, verification.
- **Phase 7:** Advanced Product Recognition (Heuristic Filtering via `ProductClassifier`).
- **Phase 8:** Recipe & Ingredient Management (Autocomplete).




