# Implementation Plan: Prospekt Essens Planer Roadmap

## Objective
To build a localized, on-device Flutter application for Android that automates weekly meal planning by parsing supermarket brochures (PDFs/Scans), matching current offers with recipes (including convenience foods like Knorr/Maggi), learning user preferences, and calculating savings.

## Technical Foundation
*   **Platform:** Android (Primary & Default).
*   **Architecture:** Clean Architecture within a Melos Monorepo.
*   **State Management:** Riverpod.
*   **Local Database:** Drift (SQLite) to handle complex many-to-many relationships (Recipes <-> Ingredients <-> Offers).
*   **Processing:** On-device execution (PDF parsing, OCR via ML Kit, local matching logic).
*   **Testing:** TDD (Unit/Widget) and BDD (Integration).

## Phase 1: Core Foundation & Data Persistence (Current Focus)
**Goal:** Establish the monorepo structure, Clean Architecture layers, and the robust local database schema using Drift.

1.  **Architecture Setup:**
    *   Initialize folders for `domain`, `data`, and `presentation` layers within the main app (`apps/prospekt_essens_planer`).
    *   Setup Riverpod providers for dependency injection.
2.  **Database Design (Drift):**
    *   Define core entities: `Brochure`, `Offer` (Ingredient + Price), `Recipe`, `RecipeIngredient`, `MealPlan`.
    *   Implement relationships (e.g., matching a generic "Potato" in a recipe to a specific "Potatoes 2kg" offer).
3.  **Database Implementation & Validation:**
    *   Setup Drift with migration strategies in mind from day one.
    *   Implement `beforeOpen` hook with `validateDatabaseSchema()` running only in `kDebugMode` to ensure schema integrity during development.
    *   Write initial repository interfaces and their Drift implementations.
4.  **TDD:** Write unit tests for the repositories and complex SQL queries (e.g., finding recipes where >50% of ingredients are on offer).

## Phase 2: Data Ingestion (Brochures & OCR)
**Goal:** Enable the app to read and understand supermarket offers.

1.  **PDF Parsing:** Integrate a native or pure-Dart PDF parser to extract text and basic structure from digital brochures.
2.  **Image/Scan OCR:** Integrate Google ML Kit (On-Device Text Recognition) to process photographs of physical brochures.
3.  **Offer Extraction Logic:** Build local algorithms (Regex/NLP) to identify product names, prices, and discounts from the raw text and map them to the `Offer` database entities.
4.  **Testing:** Provide sample PDFs and images in the `test/assets/` directory to verify extraction accuracy.

## Phase 3: The Smart Planning Engine
**Goal:** The core business logic that connects offers to meals.

1.  **Recipe Matching:** Implement the algorithm to suggest recipes based on active `Offers`.
2.  **Convenience & Direct Items:**
    *   Add logic to substitute complex recipes with convenience options (e.g., "Maggi Fix for Lasagna" + Meat on offer).
    *   Handle direct item additions (e.g., frozen pizza on offer goes straight to the plan without a recipe).
3.  **Price Calculation:** Calculate the total cost of a suggested meal and the savings compared to standard prices.
4.  **TDD:** Rigorous unit testing of the matching and calculation algorithms to ensure accurate savings and logical suggestions.

## Phase 4: User Experience & Adaptive Learning
**Goal:** Build the interactive UI and the preference learning loop.

1.  **UI Implementation (Riverpod):**
    *   Build the drag-and-drop weekly planner interface.
    *   Create views for browsing offers, managing recipes, and reviewing the shopping list.
2.  **Adaptive Learning:**
    *   Track user choices (accepted vs. rejected suggestions).
    *   Adjust the scoring algorithm in the Smart Planning Engine to favor frequently chosen meals or ingredients.
3.  **BDD (Maestro/Integration):** Write comprehensive UI tests for the core user journey: "Import Brochure -> Generate Plan -> Modify Plan -> View Shopping List".

## Verification
*   **Continuous:** All commits must pass `melos run test` (enforced via Git Hygiene).
*   **Phase Gates:** Each phase concludes with a review of the implemented features against the initial requirements before moving to the next.
