class PeriodoRegistroMallaItem {
  final int id;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool activa;
  final DateTime creadaEn;
  final int totalImportados;
  final List<String> mallasImportadas;

  const PeriodoRegistroMallaItem({
    required this.id,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.activa,
    required this.creadaEn,
    this.totalImportados = 0,
    this.mallasImportadas = const [],
  });

  factory PeriodoRegistroMallaItem.fromJson(Map<String, dynamic> json) {
    return PeriodoRegistroMallaItem(
      id: json['id'] as int,
      descripcion: json['descripcion'] as String,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: DateTime.parse(json['fecha_fin'] as String),
      activa: json['activa'] as bool,
      creadaEn: DateTime.parse(json['creada_en'] as String),
      totalImportados: (json['total_importados'] as int?) ?? 0,
      mallasImportadas: (json['mallas_importadas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
