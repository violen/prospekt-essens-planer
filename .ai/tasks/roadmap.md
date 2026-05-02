# Project Roadmap & Active Tasks

This is the consolidated source of truth for current development and future enhancements.

## 🟢 Current Phase: Phase 6 - Final Polish & Adaptive UX (Started)
**Goal:** Build the final interactive UI elements and deepen the preference learning loop.

### 1. Weekly Planner Refinement
- [ ] Implement a real "Weekly Schedule" view (assigning recipes to specific days).
- [ ] Add drag-and-drop support for planning meals.
- [ ] Integrate "Direct Item" additions (e.g., Pizza) into the weekly schedule.

### 2. Adaptive Learning & Logic
- [ ] Deepen the preference loop: Track which recommendations are accepted and boost their scores.
- [ ] Allow manual recipe creation/editing in the UI.

### 3. Verification & BDD
- [ ] Define BDD scenarios for the "Import to Plan" journey.
- [ ] Implement UI tests (BDD/Maestro style if applicable).

---

## ✅ Completed Phases
- **Phase 1:** Core Foundation & Data Persistence (merged)
- **Phase 2:** Data Ingestion (merged)
- **Phase 3:** Monorepo Refactoring (merged)
- **Phase 4:** Smart Planning Engine (merged)
- **Phase 5:** UX, Feedback & Accessibility (merged)

---

## 🟡 Future Enhancements & Backlog
These items were identified in previous phases and reviews and are deferred for later implementation.

### Data Ingestion & OCR
- [ ] **Live Video Scanning:** Implement a camera preview with real-time OCR overlay for immediate feedback.
- [ ] **OCR Normalization:** Build a normalization step to remove spaces/artifacts from recognized prices to increase accuracy on poor scans.

### Smart Planning Engine
- [ ] **Variable Standard Prices:** Add an optional `standardPrice` field to `RecipeIngredient` to improve savings calculation precision.
- [ ] **Isolate-based Matching:** Move heavy matching and scoring logic to a background Isolate to prevent UI jank with large datasets.

### Infrastructure & Core
- [ ] **English Localization:** Add `app_en.arb` and translate all UI strings.
- [ ] **Custom Exceptions:** Refactor repositories to wrap Drift exceptions in custom Domain failures.
