/// Un tipo de reporte del endpoint GET /reportes/tipos.
class ReporteTipoItem {
  ReporteTipoItem({
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    required this.requiereParalelo,
    required this.requiereEstudiante,
  });

  factory ReporteTipoItem.fromJson(Map<String, dynamic> json) {
    return ReporteTipoItem(
      tipo: json['tipo'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      requiereParalelo: json['requiere_paralelo'] as bool? ?? false,
      requiereEstudiante: json['requiere_estudiante'] as bool? ?? false,
    );
  }

  final String tipo;
  final String nombre;
  final String descripcion;
  final bool requiereParalelo;
  final bool requiereEstudiante;
}
