# Phase 2 Tasks: Data Ingestion (Brochures & OCR)

## 1. PDF Parsing Integration
- [ ] Research and add a Flutter-compatible PDF parsing package (e.g., `syncfusion_flutter_pdf` or `dart_pdf`).
- [ ] Create `BrochureParser` interface in `domain/repositories`.
- [ ] Implement `PdfBrochureParser` in `data/repositories`.
- [ ] Add unit tests with a sample PDF from `sample_data`.

## 2. Image OCR Integration (ML Kit)
- [ ] Add `google_mlkit_text_recognition` dependency.
- [ ] Implement `OcrBrochureParser` in `data/repositories` for image processing.
- [ ] Create a service to handle camera/gallery input for brochure scans.

## 3. Offer Extraction Logic
- [ ] Develop Regex/NLP logic to extract product names and prices from raw text.
- [ ] Implement a "Review & Correct" UI flow (Presentation layer) to allow users to verify extracted offers.
- [ ] Save extracted offers to the Drift database.

## 4. Testing & Verification
- [ ] Integration tests for the full ingestion pipeline: `File -> Parser -> Entities -> Database`.
- [ ] Verify extraction accuracy across different brochure formats.
