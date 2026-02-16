import '../api_service/estudiantes_api_service.dart';
import '../data/models/acciones_list_response.dart';
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

  /// Lista acciones de seguimiento (GET /acciones?estudiante_id=&limite=).
  Future<List<AccionListItem>> getAcciones({
    required int estudianteId,
    int limite = 50,
  }) async {
    final response = await _apiService.getAcciones(
      estudianteId: estudianteId,
      limite: limite,
    );
    return response.acciones;
  }

  /// Crea una acción de seguimiento para un estudiante (POST /acciones).
  Future<void> crearAccion({
    required String descripcion,
    required String fecha,
    required int estudianteId,
  }) async {
    await _apiService.postCrearAccion(
      descripcion: descripcion,
      fecha: fecha,
      estudianteId: estudianteId,
    );
  }
}
