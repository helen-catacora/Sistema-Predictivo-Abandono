import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/dashboard_response.dart';

/// Servicio de API para el dashboard de predicciones.
class DashboardApiService {
  DashboardApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// GET /api/v1/predicciones/dashboard
  Future<DashboardResponse> getDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.prediccionesDashboard,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return DashboardResponse.fromJson(response.data!);
  }
}
