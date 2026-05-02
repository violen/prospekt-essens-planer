# Project Roadmap & Active Tasks

This is the consolidated source of truth for current development and future enhancements.

## 🟢 Current Phase: Phase 7 - Advanced Product Recognition (Started)
**Goal:** Improve OCR and PDF extraction quality by filtering out non-food and drink items using an NLP heuristic pipeline.

### 1. Product Classifier
- [ ] Implement `ProductClassifier` in `prospekt_core` with dictionaries for drinks and non-food items.
- [ ] Create unit tests to verify categorization logic.

### 2. Parser Integration
- [ ] Update `PdfBrochureParser` to use the `ProductClassifier`.
- [ ] Update `OcrBrochureParser` to use the `ProductClassifier`.
- [ ] Verify filtered extraction with real-world brochure data.

---

## ✅ Completed Phases
- **Phase 1:** Core Foundation & Data Persistence (merged)
- **Phase 2:** Data Ingestion (merged)
- **Phase 3:** Monorepo Refactoring (merged)
- **Phase 4:** Smart Planning Engine (merged)
- **Phase 5:** UX, Feedback & Accessibility (merged)
- **Phase 6:** Final Polish & BDD Verification (merged)

---

## 🟡 Future Enhancements & Backlog
These items are deferred for future iterations.

### Data Ingestion & OCR
- [ ] **Live Video Scanning:** Implement a camera preview with real-time OCR overlay.
- [ ] **OCR Normalization:** Refine recognized price text to handle poor scans.

### Smart Planning Engine & Performance
- [ ] **Variable Standard Prices:** Support for ingredient-specific standard prices.
- [ ] **Isolate-based Matching:** Offload matching logic to a background Isolate.

### Infrastructure & Core
- [ ] **English Localization:** Add full multi-language support.
- [ ] **Custom Exceptions:** Enhance error handling in repositories.

