import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/paralelos_response.dart';

/// Servicio de API para paralelos.
class ParalelosApiService {
  ParalelosApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene la lista de paralelos.
  /// GET /api/v1/paralelos
  Future<ParalelosResponse> getParalelos() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.paralelos,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return ParalelosResponse.fromJson(response.data!);
  }
}
