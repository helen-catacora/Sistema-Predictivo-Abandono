import '../api_service/estudiantes_api_service.dart';
import '../data/models/estudiante_item.dart';
import '../data/models/estudiante_perfil_response.dart';

/// Repositorio de estudiantes.
class EstudiantesRepository {
  EstudiantesRepository({EstudiantesApiService? apiService})
    : _apiService = apiService ?? EstudiantesApiService();

  final EstudiantesApiService _apiService;

  /// Obtiene la lista de estudiantes para la tabla (opcionalmente filtrada por paralelo).
  Future<List<EstudianteItem>> getTabla({int? paraleloId}) async {
    final response = await _apiService.getTabla(paraleloId: paraleloId);
    return response.estudiantes;
  }

  /// Obtiene el perfil completo de un estudiante.
  Future<EstudiantePerfilResponse> getPerfil(int estudianteId) async {
    return _apiService.getPerfil(estudianteId);
  }
}
