import '../api_service/alertas_api_service.dart';
import '../data/models/alertas_response.dart';

/// Repositorio de alertas.
class AlertasRepository {
  AlertasRepository({
    AlertasApiService? apiService,
  }) : _apiService = apiService ?? AlertasApiService();

  final AlertasApiService _apiService;

  Future<AlertasResponse> getAlertas() => _apiService.getAlertas();
}
