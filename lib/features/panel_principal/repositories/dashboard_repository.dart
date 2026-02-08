import '../api_service/dashboard_api_service.dart';
import '../data/models/dashboard_response.dart';

/// Repositorio del dashboard de predicciones.
class DashboardRepository {
  DashboardRepository({
    DashboardApiService? apiService,
  }) : _apiService = apiService ?? DashboardApiService();

  final DashboardApiService _apiService;

  Future<DashboardResponse> getDashboard() => _apiService.getDashboard();
}
