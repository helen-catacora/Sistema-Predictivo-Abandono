import '../api_service/paralelos_api_service.dart';
import '../data/models/paralelo_item.dart';

/// Repositorio de paralelos.
class ParalelosRepository {
  ParalelosRepository({ParalelosApiService? apiService})
    : _apiService = apiService ?? ParalelosApiService();

  final ParalelosApiService _apiService;

  /// Obtiene la lista de paralelos.
  Future<List<ParaleloItem>> getParalelos() async {
    final response = await _apiService.getParalelos();
    return response.paralelos;
  }
}
