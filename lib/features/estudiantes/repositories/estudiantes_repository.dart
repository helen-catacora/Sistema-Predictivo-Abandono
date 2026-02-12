import 'package:dio/dio.dart';

import '../api_service/estudiantes_api_service.dart';
import '../data/models/estudiante_item.dart';
import '../data/models/estudiante_perfil_response.dart';
import '../data/models/estudiantes_tabla_response.dart';

/// Repositorio de estudiantes.
class EstudiantesRepository {
  EstudiantesRepository({
    EstudiantesApiService? apiService,
  }) : _apiService = apiService ?? EstudiantesApiService();

  final EstudiantesApiService _apiService;

  /// Obtiene la lista de estudiantes para la tabla.
  Future<List<EstudianteItem>> getTabla() async {
    final response = await _apiService.getTabla();
    return response.estudiantes;
  }

  /// Obtiene el perfil completo de un estudiante.
  Future<EstudiantePerfilResponse> getPerfil(int estudianteId) async {
    return _apiService.getPerfil(estudianteId);
  }
}
