import 'package:drift/drift.dart';
import '../../domain/entities/brochure.dart';
import '../../domain/repositories/brochure_repository.dart';
import '../local/database.dart';

class BrochureRepositoryImpl implements BrochureRepository {
  final AppDatabase db;

  BrochureRepositoryImpl(this.db);

  @override
  Future<List<Brochure>> getAllBrochures() async {
    final rows = await db.select(db.brochures).get();
    return rows.map((row) => _mapToEntity(row)).toList();
  }

  @override
  Future<Brochure> getBrochureById(int id) async {
    final query = db.select(db.brochures)..where((t) => t.id.equals(id));
    final row = await query.getSingle();
    return _mapToEntity(row);
  }

  @override
  Future<int> insertBrochure(String name, String filePath) async {
    return await db.into(db.brochures).insert(
          BrochuresCompanion.insert(
            name: name,
            filePath: filePath,
          ),
        );
  }

  @override
  Future<void> updateBrochureStatus(int id, String status) async {
    final query = db.update(db.brochures)..where((t) => t.id.equals(id));
    await query.write(BrochuresCompanion(status: Value(status)));
  }

  @override
  Future<void> deleteBrochure(int id) async {
    final query = db.delete(db.brochures)..where((t) => t.id.equals(id));
    await query.go();
  }

  Brochure _mapToEntity(BrochureEntry row) {
    return Brochure(
      id: row.id,
      name: row.name,
      filePath: row.filePath,
      importDate: row.importDate,
      status: row.status,
    );
  }
}
