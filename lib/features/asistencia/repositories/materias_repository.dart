import '../api_service/materias_api_service.dart';
import '../data/models/materia_item.dart';

/// Repositorio de materias.
class MateriasRepository {
  MateriasRepository({MateriasApiService? apiService})
    : _apiService = apiService ?? MateriasApiService();

  final MateriasApiService _apiService;

  /// Obtiene la lista de materias.
  Future<List<MateriaItem>> getMaterias() async {
    final response = await _apiService.getMaterias();
    return response.materias;
  }
}
