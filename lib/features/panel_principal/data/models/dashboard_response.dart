/// Resumen general del dashboard de predicciones.
class ResumenGeneral {
  ResumenGeneral({
    required this.totalEstudiantes,
    required this.totalPrediccionesActivas,
    required this.totalAltoRiesgo,
    required this.totalCritico,
    required this.totalMedioRiesgo,
    required this.totalBajoRiesgo,
    required this.porcentajeAltoRiesgo,
    required this.totalAlertasActivas,
    required this.totalAlertasCriticas,
  });

  factory ResumenGeneral.fromJson(Map<String, dynamic> json) {
    return ResumenGeneral(
      totalEstudiantes: (json['total_estudiantes'] as num?)?.toInt() ?? 0,
      totalPrediccionesActivas:
          (json['total_predicciones_activas'] as num?)?.toInt() ?? 0,
      totalAltoRiesgo: (json['total_alto_riesgo'] as num?)?.toInt() ?? 0,
      totalCritico: (json['total_critico'] as num?)?.toInt() ?? 0,
      totalMedioRiesgo: (json['total_medio_riesgo'] as num?)?.toInt() ?? 0,
      totalBajoRiesgo: (json['total_bajo_riesgo'] as num?)?.toInt() ?? 0,
      porcentajeAltoRiesgo:
          (json['porcentaje_alto_riesgo'] as num?)?.toDouble() ?? 0.0,
      totalAlertasActivas:
          (json['total_alertas_activas'] as num?)?.toInt() ?? 0,
      totalAlertasCriticas:
          (json['total_alertas_criticas'] as num?)?.toInt() ?? 0,
    );
  }

  final int totalEstudiantes;
  final int totalPrediccionesActivas;
  final int totalAltoRiesgo;
  final int totalCritico;
  final int totalMedioRiesgo;
  final int totalBajoRiesgo;
  final double porcentajeAltoRiesgo;
  final int totalAlertasActivas;
  final int totalAlertasCriticas;
}

/// Item de distribución de riesgo por nivel (Bajo, Medio, Alto, Crítico).
class DistribucionRiesgoItem {
  DistribucionRiesgoItem({
    required this.nivel,
    required this.cantidad,
    required this.porcentaje,
  });

  factory DistribucionRiesgoItem.fromJson(Map<String, dynamic> json) {
    return DistribucionRiesgoItem(
      nivel: json['nivel'] as String? ?? '',
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 0,
      porcentaje: (json['porcentaje'] as num?)?.toDouble() ?? 0.0,
    );
  }

  final String nivel;
  final int cantidad;
  final double porcentaje;
}

/// Item de distribución por paralelo.
class DistribucionPorParaleloItem {
  DistribucionPorParaleloItem({
    required this.paralelo,
    required this.area,
    required this.total,
    required this.altoRiesgo,
    required this.critico,
  });

  factory DistribucionPorParaleloItem.fromJson(Map<String, dynamic> json) {
    return DistribucionPorParaleloItem(
      paralelo: json['paralelo'] as String? ?? '',
      area: json['area'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      altoRiesgo: (json['alto_riesgo'] as num?)?.toInt() ?? 0,
      critico: (json['critico'] as num?)?.toInt() ?? 0,
    );
  }

  final String paralelo;
  final String area;
  final int total;
  final int altoRiesgo;
  final int critico;
}

/// Respuesta completa del endpoint GET /predicciones/dashboard.
class DashboardResponse {
  DashboardResponse({
    required this.resumenGeneral,
    required this.distribucionRiesgo,
    required this.distribucionPorParalelo,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    final resumen = json['resumen_general'];
    final distRiesgo = json['distribucion_riesgo'];
    final distParalelo = json['distribucion_por_paralelo'];

    return DashboardResponse(
      resumenGeneral: resumen is Map<String, dynamic>
          ? ResumenGeneral.fromJson(resumen)
          : ResumenGeneral(
              totalEstudiantes: 0,
              totalPrediccionesActivas: 0,
              totalAltoRiesgo: 0,
              totalCritico: 0,
              totalMedioRiesgo: 0,
              totalBajoRiesgo: 0,
              porcentajeAltoRiesgo: 0.0,
              totalAlertasActivas: 0,
              totalAlertasCriticas: 0,
            ),
      distribucionRiesgo: distRiesgo is List
          ? (distRiesgo)
                .map(
                  (e) => DistribucionRiesgoItem.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : <DistribucionRiesgoItem>[],
      distribucionPorParalelo: distParalelo is List
          ? (distParalelo)
                .map(
                  (e) => DistribucionPorParaleloItem.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : <DistribucionPorParaleloItem>[],
    );
  }

  final ResumenGeneral resumenGeneral;
  final List<DistribucionRiesgoItem> distribucionRiesgo;
  final List<DistribucionPorParaleloItem> distribucionPorParalelo;
}
