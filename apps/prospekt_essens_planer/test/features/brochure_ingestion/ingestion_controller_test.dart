import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prospekt_essens_planer/core/providers.dart';
import 'package:prospekt_core/prospekt_core.dart';
import 'package:prospekt_data/prospekt_data.dart';
import 'package:prospekt_essens_planer/features/brochure_ingestion/presentation/controllers/ingestion_controller.dart';
import 'package:prospekt_essens_planer/features/brochure_ingestion/presentation/controllers/ingestion_state.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';

import 'ingestion_controller_test.mocks.dart';

@GenerateMocks([BrochureParser])
void main() {
  late MockBrochureParser mockParser;
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    mockParser = MockBrochureParser();
    database = AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));
    
    container = ProviderContainer(
      overrides: [
        brochureParserProvider.overrideWithValue(mockParser),
        databaseProvider.overrideWithValue(database),
        brochureRepositoryProvider.overrideWithValue(BrochureRepositoryImpl(database)),
        offerRepositoryProvider.overrideWithValue(OfferRepositoryImpl(database)),
      ],
    );
  });

  tearDown(() async {
    await database.close();
    container.dispose();
  });

  test('processFile extracts offers and updates state', () async {
    final file = File('test.pdf');
    final mockOffers = [
      Offer(id: 1, brochureId: 0, productName: 'Test Product', price: 1.99),
    ];

    when(mockParser.parse(file, 0)).thenAnswer((_) async => mockOffers);

    final controller = container.read(ingestionControllerProvider.notifier);
    
    await controller.processFile(file);

    final state = container.read(ingestionControllerProvider);
    expect(state.status, IngestionStatus.success);
    expect(state.extractedOffers.length, 1);
    expect(state.extractedOffers.first.productName, 'Test Product');
  });

  test('saveOffers stores brochure and offers in database', () async {
    final file = File('test.pdf');
    final mockOffers = [
      Offer(id: 1, brochureId: 0, productName: 'Apple', price: 0.99),
      Offer(id: 2, brochureId: 0, productName: 'Banana', price: 1.49),
    ];

    when(mockParser.parse(file, 0)).thenAnswer((_) async => mockOffers);

    final controller = container.read(ingestionControllerProvider.notifier);
    await controller.processFile(file);
    
    await controller.saveOffers('Kaufland KW 18');

    // Verify DB state
    final brochures = await container.read(brochureRepositoryProvider).getAllBrochures();
    expect(brochures.length, 1);
    expect(brochures.first.name, 'Kaufland KW 18');

    final offers = await container.read(offerRepositoryProvider).getOffersByBrochureId(brochures.first.id!);
    expect(offers.length, 2);
    expect(offers.any((o) => o.productName == 'Apple'), true);
  });

  test('removeOffer updates state correctly', () async {
    final file = File('test.pdf');
    final mockOffers = [
      Offer(id: 1, brochureId: 0, productName: 'Apple', price: 0.99),
      Offer(id: 2, brochureId: 0, productName: 'Banana', price: 1.49),
    ];

    when(mockParser.parse(file, 0)).thenAnswer((_) async => mockOffers);

    final controller = container.read(ingestionControllerProvider.notifier);
    await controller.processFile(file);
    
    controller.removeOffer(0); // Remove Apple

    final state = container.read(ingestionControllerProvider);
    expect(state.extractedOffers.length, 1);
    expect(state.extractedOffers.first.productName, 'Banana');
  });
}
