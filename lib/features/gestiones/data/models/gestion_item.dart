class GestionItem {
  final int id;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final bool activa;
  final DateTime? fechaInicioRegistroEstudiantes;
  final DateTime? fechaFinRegistroEstudiantes;

  const GestionItem({
    required this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.activa,
    this.fechaInicioRegistroEstudiantes,
    this.fechaFinRegistroEstudiantes,
  });

  factory GestionItem.fromJson(Map<String, dynamic> json) {
    return GestionItem(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: DateTime.parse(json['fecha_fin'] as String),
      activa: json['activa'] as bool,
      fechaInicioRegistroEstudiantes: json['fecha_inicio_registro_estudiantes'] != null
          ? DateTime.parse(json['fecha_inicio_registro_estudiantes'] as String)
          : null,
      fechaFinRegistroEstudiantes: json['fecha_fin_registro_estudiantes'] != null
          ? DateTime.parse(json['fecha_fin_registro_estudiantes'] as String)
          : null,
    );
  }
}
