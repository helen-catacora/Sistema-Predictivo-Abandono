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

  /// Asigna un encargado al paralelo. PATCH /api/v1/paralelos/:id
  Future<void> updateParaleloEncargado(int paraleloId, int encargadoId) async {
    await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.paralelo(paraleloId),
      data: {'encargado_id': encargadoId},
    );
  }
}
