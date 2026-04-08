/// Fila del historial de entrenamientos.
class EntrenamientoHistorialItem {
  final int id;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String estado;
  final String nombreArchivo;
  final int totalRegistros;
  final String? tipoMejorModelo;
  final double? f1Nuevo;
  final double? f1Actual;
  final String usuarioNombre;
  final String? versionGenerada;

  const EntrenamientoHistorialItem({
    required this.id,
    required this.fechaInicio,
    this.fechaFin,
    required this.estado,
    required this.nombreArchivo,
    required this.totalRegistros,
    this.tipoMejorModelo,
    this.f1Nuevo,
    this.f1Actual,
    required this.usuarioNombre,
    this.versionGenerada,
  });

  factory EntrenamientoHistorialItem.fromJson(Map<String, dynamic> json) {
    return EntrenamientoHistorialItem(
      id: json['id'] as int,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: json['fecha_fin'] != null
          ? DateTime.parse(json['fecha_fin'] as String)
          : null,
      estado: json['estado'] as String,
      nombreArchivo: json['nombre_archivo'] as String,
      totalRegistros: json['total_registros'] as int,
      tipoMejorModelo: json['tipo_mejor_modelo'] as String?,
      f1Nuevo: (json['f1_nuevo'] as num?)?.toDouble(),
      f1Actual: (json['f1_actual'] as num?)?.toDouble(),
      usuarioNombre: json['usuario_nombre'] as String,
      versionGenerada: json['version_generada'] as String?,
    );
  }
}
