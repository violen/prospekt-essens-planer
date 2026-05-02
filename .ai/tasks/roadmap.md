# Project Roadmap & Active Tasks

This is the consolidated source of truth for current development and future enhancements.

## ✅ Project Status: MVP Reached
All initial development phases (1-6) have been successfully completed and merged into the main branch. The app is functional on Android and ready for use.

---

## ✅ Completed Phases
- **Phase 1:** Core Foundation & Data Persistence (merged)
- **Phase 2:** Data Ingestion (merged)
- **Phase 3:** Monorepo Refactoring (merged)
- **Phase 4:** Smart Planning Engine (merged)
- **Phase 5:** UX, Feedback & Accessibility (merged)
- **Phase 6:** Final Polish & Adaptive UX (merged)

---

## 🟡 Future Enhancements & Backlog
These items were identified during reviews and development and are deferred for future iterations.

### Data Ingestion & OCR
- [ ] **Modern PDF Engine:** Re-implement PDF text extraction using a modern library (e.g., `syncfusion_flutter_pdf`) to replace the removed `pdf_text`.
- [ ] **Live Video Scanning:** Implement a camera preview with real-time OCR overlay.
- [ ] **OCR Normalization:** Remove spaces/artifacts from recognized prices to increase accuracy.

### Smart Planning Engine & Performance
- [ ] **Variable Standard Prices:** Add support for ingredient-specific standard prices.
- [ ] **Isolate-based Matching:** Offload heavy matching logic to a background Isolate.
- [ ] **State-based Title Loading:** Integrate recipe names directly into the `WeeklyPlannerState` to avoid `FutureBuilder` flickering.

### Infrastructure & Core
- [ ] **English Localization:** Add `app_en.arb` for full multi-language support.
- [ ] **Custom Exceptions:** Wrap database errors in custom Domain failures.
