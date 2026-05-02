# Phase 4 Tasks: Smart Planning Engine

## 1. Core Matching Engine
- [ ] Implement `MatchingService` in `packages/prospekt_core` (Domain).
- [ ] Create logic to match `RecipeIngredients` with active `Offers` (fuzzy matching for names like "Kartoffeln" vs "Speisekartoffeln").
- [ ] Implement "Convenience Matching": Suggest recipes that can be made with "Maggi/Knorr Fix" if ingredients are on offer.

## 2. Savings & Calculation
- [ ] Logic to calculate the total price of a recipe based on current offers vs. estimated standard prices.
- [ ] Provide a "Total Savings" metric for a generated meal plan.

## 3. Preference Learning (Initial)
- [ ] Implement a scoring system for recipes based on user rating and selection frequency.
- [ ] Integrate the scoring system into the matching algorithm to favor preferred meals.

## 4. UI: Meal Planner Dashboard
- [ ] Create `MealPlannerPage` in the main app.
- [ ] Implement a "Generate Plan" flow that uses the Matching Engine.
- [ ] Add a view to see "Recommended Recipes" based on current brochures.

## 5. Testing & Verification
- [ ] Unit tests for the matching algorithm with complex scenarios (multiple offers, missing ingredients).
- [ ] BDD tests for the "Generate Plan" user journey.
