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

## Phase 1: Core Foundation & Data Persistence
**Goal:** Establish the monorepo structure, Clean Architecture layers, and the robust local database schema using Drift. (Status: Merged).

## Phase 2: Data Ingestion (Brochures & OCR)
**Goal:** Enable the app to read and understand supermarket offers. (Status: Merged).

## Phase 3: Monorepo Refactoring (Architecture Alignment)
**Goal:** Properly leverage the Melos monorepo structure by moving shared logic out of the main app. (Status: Merged).

## Phase 4: The Smart Planning Engine
**Goal:** The core business logic that connects offers to meals. (Status: Completed, awaiting PR review).

1.  **Recipe Matching:** Implement the algorithm to suggest recipes based on active `Offers`.
2.  **Savings Calculation:** Logic to calculate total savings per recipe based on current brochures.
3.  **Initial Learning:** Scoring system that favors recipes chosen or highly rated by the user.

## Phase 5: UX, Feedback & Accessibility
**Goal:** Ensure a professional, accessible, and intuitive user experience.

1.  **User Guidance & Feedback:**
    *   Implement clear feedback for long-running processes (OCR, Parsing).
    *   Use Snackbars and haptic feedback for success/error states.
2.  **Accessibility (A11y):**
    *   Ensure proper semantics for screen readers (Semantics widgets).
    *   Verify color contrast and support for dynamic font sizes.
3.  **UI Refinement:**
    *   Polishing transitions and animations.
    *   Implementing a consistent design language (Material 3).

## Phase 6: Final Polish & Adaptive UX
**Goal:** Build the final interactive UI elements and deepen the preference learning loop.

1.  **UI Implementation:** Refine the drag-and-drop weekly planner interface.
2.  **BDD (Maestro/Integration):** Write comprehensive UI tests for the core user journey.

## Verification
*   **Continuous:** All commits must pass `melos run test`.
*   **Phase Gates:** Each phase concludes with a review of the implemented features before moving to the next.
