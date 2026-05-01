import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import '../data/repositories/brochure_repository_impl.dart';
import '../data/repositories/offer_repository_impl.dart';
import '../domain/repositories/brochure_repository.dart';
import '../domain/repositories/offer_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final brochureRepositoryProvider = Provider<BrochureRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BrochureRepositoryImpl(db);
});

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return OfferRepositoryImpl(db);
});
