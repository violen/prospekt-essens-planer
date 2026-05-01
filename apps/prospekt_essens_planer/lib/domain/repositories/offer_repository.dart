import '../entities/offer.dart';

abstract class OfferRepository {
  Future<List<Offer>> getOffersByBrochureId(int brochureId);
  Future<int> insertOffer(Offer offer);
  Future<void> deleteOffersByBrochureId(int brochureId);
}
