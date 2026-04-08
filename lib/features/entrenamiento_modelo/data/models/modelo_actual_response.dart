import 'metricas_modelo.dart';

/// Información del modelo actualmente en producción.
class ModeloActualResponse {
  final String version;
  final String tipoModelo;
  final MetricasModelo metricas;
  final int nFeatures;
  final String? fechaEntrenamiento;

  const ModeloActualResponse({
    required this.version,
    required this.tipoModelo,
    required this.metricas,
    required this.nFeatures,
    this.fechaEntrenamiento,
  });

  factory ModeloActualResponse.fromJson(Map<String, dynamic> json) {
    return ModeloActualResponse(
      version: json['version'] as String,
      tipoModelo: json['tipo_modelo'] as String,
      metricas: MetricasModelo.fromJson(json['metricas'] as Map<String, dynamic>),
      nFeatures: json['n_features'] as int,
      fechaEntrenamiento: json['fecha_entrenamiento'] as String?,
    );
  }
}
