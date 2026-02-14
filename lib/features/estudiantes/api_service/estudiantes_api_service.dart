import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/estudiante_perfil_response.dart';
import '../data/models/estudiantes_tabla_response.dart';

/// Servicio de API para estudiantes.
class EstudiantesApiService {
  EstudiantesApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// Obtiene la tabla de estudiantes en riesgo.
  /// GET /api/v1/estudiantes/tabla — opcional paralelo_id para filtrar por paralelo.
  Future<EstudiantesTablaResponse> getTabla({int? paraleloId}) async {
    final queryParams = <String, dynamic>{};
    if (paraleloId != null) queryParams['paralelo_id'] = paraleloId;
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.estudiantesTabla,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return EstudiantesTablaResponse.fromJson(response.data!);
  }

  /// Obtiene el perfil completo de un estudiante.
  /// GET /api/v1/estudiantes/:id/perfil
  Future<EstudiantePerfilResponse> getPerfil(int estudianteId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.estudiantePerfil(estudianteId),
    );

    if (response.data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respuesta vacía del servidor',
      );
    }

    return EstudiantePerfilResponse.fromJson(response.data!);
  }
}
