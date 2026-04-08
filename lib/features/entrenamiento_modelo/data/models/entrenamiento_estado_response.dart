import 'metricas_modelo.dart';

/// Estado actual de un entrenamiento (respuesta del polling).
class EntrenamientoEstadoResponse {
  final int id;
  final String estado;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String nombreArchivo;
  final int totalRegistros;
  final String? tipoMejorModelo;
  final MetricasModelo? metricasNuevo;
  final MetricasModelo? metricasActual;
  final Map<String, dynamic>? parametrosModelo;
  final String? mensajeError;

  const EntrenamientoEstadoResponse({
    required this.id,
    required this.estado,
    required this.fechaInicio,
    this.fechaFin,
    required this.nombreArchivo,
    required this.totalRegistros,
    this.tipoMejorModelo,
    this.metricasNuevo,
    this.metricasActual,
    this.parametrosModelo,
    this.mensajeError,
  });

  factory EntrenamientoEstadoResponse.fromJson(Map<String, dynamic> json) {
    return EntrenamientoEstadoResponse(
      id: json['id'] as int,
      estado: json['estado'] as String,
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: json['fecha_fin'] != null
          ? DateTime.parse(json['fecha_fin'] as String)
          : null,
      nombreArchivo: json['nombre_archivo'] as String,
      totalRegistros: json['total_registros'] as int,
      tipoMejorModelo: json['tipo_mejor_modelo'] as String?,
      metricasNuevo: json['metricas_nuevo'] != null
          ? MetricasModelo.fromJson(json['metricas_nuevo'] as Map<String, dynamic>)
          : null,
      metricasActual: json['metricas_actual'] != null
          ? MetricasModelo.fromJson(json['metricas_actual'] as Map<String, dynamic>)
          : null,
      parametrosModelo: json['parametros_modelo'] as Map<String, dynamic>?,
      mensajeError: json['mensaje_error'] as String?,
    );
  }
}
