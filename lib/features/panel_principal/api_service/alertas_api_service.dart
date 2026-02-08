import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/alertas_response.dart';

/// Servicio de API para alertas.
class AlertasApiService {
  AlertasApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// GET /api/v1/alertas
  Future<AlertasResponse> getAlertas() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.alertas,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return AlertasResponse.fromJson(response.data!);
  }
}
