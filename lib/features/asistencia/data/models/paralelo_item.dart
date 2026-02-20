/// Modelo de paralelo del endpoint /paralelos.
class ParaleloItem {
  ParaleloItem({
    required this.id,
    required this.nombre,
    required this.areaId,
    this.areaNombre,
    required this.semestreId,
    required this.nombreEncargado,
  });

  factory ParaleloItem.fromJson(Map<String, dynamic> json) {
    return ParaleloItem(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      areaId: json['area_id'] as int,
      areaNombre: json['area_nombre'] as String?,
      semestreId: json['semestre_id'] as int,
      nombreEncargado: json['nombre_encargado'] as String,
    );
  }

  final int id;
  final String nombre;
  final int areaId;
  /// Nombre del área (carrera). Viene del backend; si es null se puede derivar por areaId.
  final String? areaNombre;
  final int semestreId;
  final String nombreEncargado;
}
