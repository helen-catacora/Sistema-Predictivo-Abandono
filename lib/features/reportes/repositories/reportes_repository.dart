import 'dart:typed_data';

import '../api_service/reportes_api_service.dart';
import '../data/models/reportes_historial_response.dart';
import '../data/models/reportes_tipos_response.dart';

/// Repositorio de reportes.
class ReportesRepository {
  ReportesRepository({
    ReportesApiService? apiService,
  }) : _apiService = apiService ?? ReportesApiService();

  final ReportesApiService _apiService;

  Future<ReportesTiposResponse> getTipos() => _apiService.getTipos();

  /// Genera un reporte PDF. Body según tipo (tipo, opcional paralelo_id o estudiante_id).
  Future<Uint8List> generar(Map<String, dynamic> body) => _apiService.generar(body);

  /// Historial de reportes paginado.
  Future<ReportesHistorialResponse> getHistorial({int page = 1, int pageSize = 20}) =>
      _apiService.getHistorial(page: page, pageSize: pageSize);
}
