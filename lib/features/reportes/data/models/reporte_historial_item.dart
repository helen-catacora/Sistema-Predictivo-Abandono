/// Un reporte del historial GET /reportes/historial.
class ReporteHistorialItem {
  ReporteHistorialItem({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.generadoPorNombre,
    required this.fechaGeneracion,
    this.parametros,
  });

  factory ReporteHistorialItem.fromJson(Map<String, dynamic> json) {
    final params = json['parametros'];
    return ReporteHistorialItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tipo: json['tipo'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      generadoPorNombre: json['generado_por_nombre'] as String? ?? '',
      fechaGeneracion: json['fecha_generacion'] as String? ?? '',
      parametros: params is Map<String, dynamic>
          ? Map<String, dynamic>.from(params)
          : null,
    );
  }

  final int id;
  final String tipo;
  final String nombre;
  final String generadoPorNombre;
  final String fechaGeneracion;
  final Map<String, dynamic>? parametros;
}
