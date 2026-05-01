# Phase 1 Tasks: Core Foundation & Data Persistence

## 1. Clean Architecture Setup
- [ ] Create folder structure: lib/core, lib/features, lib/domain, lib/data, lib/presentation
- [ ] Setup base Riverpod providers for DI

## 2. Drift Database Implementation
- [ ] Add dependencies to pubspec.yaml (drift, sqlite3_flutter_libs, drift_dev, build_runner)
- [ ] Define Drift tables in lib/data/local/database.dart
- [ ] Implement database class with schema validation and migration logic
- [ ] Create repository interfaces in domain/repositories
- [ ] Implement repositories in data/repositories using Drift

## 3. Testing & Verification
- [ ] Setup unit testing for Drift database
- [ ] Write tests for core DB operations and complex queries
