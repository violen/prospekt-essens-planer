import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_core/prospekt_core.dart';
import 'package:prospekt_data/prospekt_data.dart';

void main() {
  late AppDatabase database;
  late OfferRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    repository = OfferRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('getUniqueProductNames returns distinct offer names', () async {
    // 1. Insert multiple offers with some duplicates
    await repository.insertOffer(Offer(id: 0, brochureId: 1, productName: 'Bio Kartoffeln', normalizedName: 'Kartoffel', price: 1.99));
    await repository.insertOffer(Offer(id: 0, brochureId: 1, productName: 'Milch', normalizedName: 'Milch', price: 0.99));
    await repository.insertOffer(Offer(id: 0, brochureId: 2, productName: 'Speisekartoffeln', normalizedName: 'Kartoffel', price: 2.49));
    await repository.insertOffer(Offer(id: 0, brochureId: 2, productName: 'Gouda', normalizedName: 'Käse', price: 2.50));

    // 2. Fetch unique names
    final uniqueNames = await repository.getUniqueProductNames();

    // 3. Verify
    expect(uniqueNames.length, 3);
    expect(uniqueNames, containsAll(['Kartoffel', 'Milch', 'Käse']));
  });
}
