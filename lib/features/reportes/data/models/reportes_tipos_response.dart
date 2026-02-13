import 'reporte_tipo_item.dart';

/// Respuesta del endpoint GET /reportes/tipos.
class ReportesTiposResponse {
  ReportesTiposResponse({required this.tipos});

  factory ReportesTiposResponse.fromJson(Map<String, dynamic> json) {
    final list = json['tipos'];
    return ReportesTiposResponse(
      tipos: list is List
          ? (list)
                .map(
                  (e) => ReporteTipoItem.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : <ReporteTipoItem>[],
    );
  }

  final List<ReporteTipoItem> tipos;
}
