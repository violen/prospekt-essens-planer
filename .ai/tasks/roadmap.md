# Project Roadmap & Active Tasks

This is the consolidated source of truth for current development and future enhancements.

## 🟢 Current Phase: Phase 6 - Final Polish & Adaptive UX (Reopened)
**Goal:** Complete the final functional requirements and verification.

### 1. Weekly Planner Refinement
- [x] Implement a real "Weekly Schedule" view (assigning recipes to specific days).
- [x] Add navigation between weeks.
- [ ] Implement Drag-and-Drop for planning meals (Optional Refinement).

### 2. Modern PDF Engine
- [ ] Research and integrate a modern PDF parsing library (replacing `pdf_text`).
- [ ] Re-enable PDF-based offer extraction.

### 3. Verification & BDD
- [ ] Define BDD scenarios for the "Brochure to Plan" journey.
- [ ] Implement BDD tests using Flutter's integration test framework or Maestro.

---

## ✅ Completed Phases
- **Phase 1:** Core Foundation & Data Persistence (merged)
- **Phase 2:** Data Ingestion (merged)
- **Phase 3:** Monorepo Refactoring (merged)
- **Phase 4:** Smart Planning Engine (merged)
- **Phase 5:** UX, Feedback & Accessibility (merged)

---

## 🟡 Future Enhancements & Backlog
### Data Ingestion & OCR
- [ ] **Live Video Scanning:** Implement a camera preview with real-time OCR overlay.
- [ ] **OCR Normalization:** Remove spaces/artifacts from recognized prices.

### Smart Planning Engine & Performance
- [ ] **Variable Standard Prices:** Support for ingredient-specific standard prices.
- [ ] **Isolate-based Matching:** Offload heavy logic to a background Isolate.
- [ ] **State-based Title Loading:** Integrate recipe names directly into the state.

### Infrastructure & Core
- [ ] **English Localization:** Full multi-language support.
- [ ] **Custom Exceptions:** Wrap database errors.
