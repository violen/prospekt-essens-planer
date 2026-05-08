import 'package:drift/drift.dart';
import 'package:prospekt_core/prospekt_core.dart';
import '../local/database.dart';

class OfferRepositoryImpl implements OfferRepository {
  final AppDatabase db;

  OfferRepositoryImpl(this.db);

  @override
  Future<List<Offer>> getOffersByBrochureId(int brochureId) async {
    final query = db.select(db.offers)..where((t) => t.brochureId.equals(brochureId));
    final rows = await query.get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<int> insertOffer(Offer offer) async {
    return await db.into(db.offers).insert(
          OffersCompanion.insert(
            brochureId: offer.brochureId,
            productName: offer.productName,
            price: offer.price,
            unit: Value(offer.unit),
            discountInfo: Value(offer.discountInfo),
            category: Value(offer.category),
            normalizedName: Value(offer.normalizedName),
            isReadyMeal: Value(offer.isReadyMeal ?? false),
          ),
        );
  }

  @override
  Future<void> deleteOffersByBrochureId(int brochureId) async {
    final query = db.delete(db.offers)..where((t) => t.brochureId.equals(brochureId));
    await query.go();
  }

  @override
  Future<List<String>> getUniqueProductNames() async {
    final query = db.selectOnly(db.offers, distinct: true)
      ..addColumns([db.offers.normalizedName, db.offers.productName]);
    final rows = await query.get();
    return rows.map((row) {
      return row.read(db.offers.normalizedName) ?? row.read(db.offers.productName)!;
    }).toSet().toList(); // Ensure uniqueness if both columns exist
  }

  Offer _mapToEntity(OfferEntry row) {
    return Offer(
      id: row.id,
      brochureId: row.brochureId,
      productName: row.productName,
      price: row.price,
      unit: row.unit,
      discountInfo: row.discountInfo,
      category: row.category,
      normalizedName: row.normalizedName,
      isReadyMeal: row.isReadyMeal,
    );
  }
}
