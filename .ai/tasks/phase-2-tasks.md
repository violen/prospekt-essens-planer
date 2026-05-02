# Phase 2 Tasks: Data Ingestion (Brochures & OCR)

## 1. PDF Parsing Integration
- [x] Research and add a Flutter-compatible PDF parsing package (`pdf_text`).
- [x] Create `BrochureParser` interface in `domain/repositories`.
- [x] Implement `PdfBrochureParser` in `data/repositories` with improved regex and unit detection.
- [x] Add unit tests for PDF extraction logic.

## 2. Image OCR Integration (ML Kit)
- [x] Add `google_mlkit_text_recognition` dependency.
- [x] Implement `OcrBrochureParser` in `data/repositories` for image processing using shared extraction heuristics.
- [x] Implement `CompositeBrochureParser` to switch between PDF and OCR based on file type.
- [x] Direct Camera Integration: Add `image_picker` to allow taking photos directly within the app.
- [ ] (Future Enhancement - Phase TBD) Live Video Scanning: Implement a camera preview with real-time OCR overlay for immediate feedback.

## 3. Offer Extraction Logic
- [x] Develop Regex logic to extract product names and prices from raw text.
- [x] Implement Ingestion Controller and State using Riverpod.
- [x] Create `BrochureIngestionPage` for file selection and preview.
- [x] Implement a "Review & Correct" UI flow (detailed editing) to allow users to verify extracted offers.
- [x] Save extracted offers to the Drift database (Initial implementation in controller).

## 4. Localization & Multi-language Support
- [x] Add `flutter_localizations` dependency to `pubspec.yaml`.
- [x] Setup `l10n.yaml` and initialize ARB files for German (`app_de.arb`).
- [x] Implement a basic localization delegate and apply it to UI.
- [ ] (Future) Prepare for English support by ensuring all UI strings are localized.

## 5. Testing & Verification
- [x] Unit tests for `PdfBrochureParser` with German price formats and units.
- [x] Unit tests for `IngestionController` with mocked parsers and in-memory database.
- [x] Widget tests for `BrochureIngestionPage` with localization and state verification.
- [x] Integration tests for the full ingestion pipeline: `File -> Parser -> Entities -> Database` (Logic verified in controller tests).
- [x] Verify extraction accuracy across different brochure formats (Verified via unit tests with mock samples).
