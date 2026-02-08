import 'reporte_historial_item.dart';

/// Respuesta del endpoint GET /reportes/historial.
class ReportesHistorialResponse {
  ReportesHistorialResponse({
    required this.total,
    required this.reportes,
  });

  factory ReportesHistorialResponse.fromJson(Map<String, dynamic> json) {
    final list = json['reportes'];
    return ReportesHistorialResponse(
      total: (json['total'] as num?)?.toInt() ?? 0,
      reportes: list is List
          ? (list as List)
              .map((e) => ReporteHistorialItem.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : <ReporteHistorialItem>[],
    );
  }

  final int total;
  final List<ReporteHistorialItem> reportes;
}
