import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_data/prospekt_data.dart';
import 'package:prospekt_core/prospekt_core.dart';

void main() {
  late AppDatabase database;
  late BrochureRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    repository = BrochureRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('can insert and retrieve a brochure', () async {
    const name = 'Test Brochure';
    const filePath = '/path/to/brochure.pdf';

    final id = await repository.insertBrochure(name, filePath);
    final brochures = await repository.getAllBrochures();

    expect(brochures.length, 1);
    expect(brochures.first.id, id);
    expect(brochures.first.name, name);
    expect(brochures.first.filePath, filePath);
    expect(brochures.first.status, 'pending');
  });

  test('can update brochure status', () async {
    final id = await repository.insertBrochure('Test', 'path');
    
    await repository.updateBrochureStatus(id, 'completed');
    final brochure = await repository.getBrochureById(id);

    expect(brochure.status, 'completed');
  });
}
