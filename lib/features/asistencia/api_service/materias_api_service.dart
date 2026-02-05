import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/materias_response.dart';

/// Servicio de API para materias.
class MateriasApiService {
  MateriasApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene la lista de materias.
  /// GET /api/v1/materias
  Future<MateriasResponse> getMaterias() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.materias,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return MateriasResponse.fromJson(response.data!);
  }
}
