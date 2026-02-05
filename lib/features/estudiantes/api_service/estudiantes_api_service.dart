import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/estudiantes_tabla_response.dart';

/// Servicio de API para estudiantes.
class EstudiantesApiService {
  EstudiantesApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene la tabla de estudiantes en riesgo.
  /// GET /api/v1/estudiantes/tabla
  Future<EstudiantesTablaResponse> getTabla() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.estudiantesTabla,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return EstudiantesTablaResponse.fromJson(response.data!);
  }
}
