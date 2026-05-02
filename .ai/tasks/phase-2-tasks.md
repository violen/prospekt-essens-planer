# Phase 2 Tasks: Data Ingestion (Brochures & OCR)

## 1. PDF Parsing Integration
- [x] Research and add a Flutter-compatible PDF parsing package (`pdf_text`).
- [x] Create `BrochureParser` interface in `domain/repositories`.
- [x] Implement `PdfBrochureParser` in `data/repositories` with improved regex and unit detection.
- [x] Add unit tests for PDF extraction logic.

## 2. Image OCR Integration (ML Kit)
- [x] Add `google_mlkit_text_recognition` dependency.
- [x] Implement `OcrBrochureParser` in `data/repositories` for image processing using shared extraction heuristics.
- [ ] Create a service to handle camera/gallery input for brochure scans.
- [x] Implement `CompositeBrochureParser` to switch between PDF and OCR based on file type.

## 3. Offer Extraction Logic
- [x] Develop Regex logic to extract product names and prices from raw text.
- [x] Implement Ingestion Controller and State using Riverpod.
- [x] Create `BrochureIngestionPage` for file selection and preview.
- [ ] Implement a "Review & Correct" UI flow (detailed editing) to allow users to verify extracted offers.
- [x] Save extracted offers to the Drift database (Initial implementation in controller).

## 4. Localization & Multi-language Support
- [x] Add `flutter_localizations` dependency to `pubspec.yaml`.
- [x] Setup `l10n.yaml` and initialize ARB files for German (`app_de.arb`).
- [x] Implement a basic localization delegate and apply it to UI.
- [ ] (Future) Prepare for English support by ensuring all UI strings are localized.

## 5. Testing & Verification
- [ ] Integration tests for the full ingestion pipeline: `File -> Parser -> Entities -> Database`.
- [ ] Verify extraction accuracy across different brochure formats.
