import '../entities/brochure.dart';

abstract class BrochureRepository {
  Future<List<Brochure>> getAllBrochures();
  Future<Brochure> getBrochureById(int id);
  Future<int> insertBrochure(String name, String filePath);
  Future<void> updateBrochureStatus(int id, String status);
  Future<void> deleteBrochure(int id);
}
