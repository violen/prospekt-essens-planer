# Phase 4 Tasks: Smart Planning Engine

## 1. Core Matching Engine
- [x] Implement `MatchingService` in `packages/prospekt_core` (Domain).
- [x] Create logic to match `RecipeIngredients` with active `Offers` (fuzzy matching).
- [x] Implement "Convenience Matching": Initial heuristic integrated into summaries.

## 2. Savings & Calculation
- [x] Logic to calculate the total price of a recipe based on current offers.
- [x] Provide a "Total Savings" metric for matching recipes.

## 3. Preference Learning (Initial)
- [x] Implement `ScoringService` for ranking recipes based on match rate and rating.
- [x] Integrate the scoring system into the recommendations flow.

## 4. UI: Meal Planner Dashboard
- [x] Create `MealPlannerPage` and `MealPlannerController`.
- [x] Implement recommendation view with expansion details.
- [x] Add navigation shell in `main.dart`.

## 5. Testing & Verification
- [x] Unit tests for `MatchingService` and `ScoringService`.
- [x] Static analysis and workspace-wide test verification.

## 6. Future Enhancements & Optimization (Review Feedback)
- [ ] (Refinement) Variable Standard Prices: Add an optional `standardPrice` field to `RecipeIngredient` to improve savings calculation precision.
- [ ] (Optimization) Isolate-based Matching: Move heavy matching and scoring logic to a background Isolate to prevent UI jank with large datasets.
