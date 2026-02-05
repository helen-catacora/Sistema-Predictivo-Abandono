import '../api_service/asistencias_api_service.dart';
import '../data/models/asistencia_dia_response.dart';
import '../data/models/asistencia_save_request.dart';

/// Repositorio de asistencias.
class AsistenciasRepository {
  AsistenciasRepository({AsistenciasApiService? apiService})
      : _apiService = apiService ?? AsistenciasApiService();

  final AsistenciasApiService _apiService;

  /// Obtiene las asistencias del día.
  Future<AsistenciaDiaResponse> getAsistenciasDia({
    required int materiaId,
    required int paraleloId,
  }) async {
    return _apiService.getAsistenciasDia(
      materiaId: materiaId,
      paraleloId: paraleloId,
    );
  }

  /// Guarda las asistencias del día.
  Future<void> saveAsistenciasDia({
    required int materiaId,
    required int paraleloId,
    required AsistenciaSaveRequest body,
  }) async {
    await _apiService.postAsistenciasDia(
      materiaId: materiaId,
      paraleloId: paraleloId,
      body: body,
    );
  }
}
