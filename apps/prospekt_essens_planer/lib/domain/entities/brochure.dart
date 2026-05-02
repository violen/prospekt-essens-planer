class Brochure {
  final int? id;
  final String name;
  final String filePath;
  final DateTime importDate;
  final String status;

  Brochure({
    this.id,
    required this.name,
    required this.filePath,
    required this.importDate,
    required this.status,
  });

  Brochure copyWith({
    int? id,
    String? name,
    String? filePath,
    DateTime? importDate,
    String? status,
  }) {
    return Brochure(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      importDate: importDate ?? this.importDate,
      status: status ?? this.status,
    );
  }
}
