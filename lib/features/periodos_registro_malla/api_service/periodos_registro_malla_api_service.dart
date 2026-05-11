import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/periodo_registro_malla_item.dart';

class PeriodosRegistroMallaApiService {
  PeriodosRegistroMallaApiService() : _dio = DioClient.instance;

  final Dio _dio;

  Future<List<PeriodoRegistroMallaItem>> getPeriodos() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.periodosRegistroMalla);
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    final list = response.data!['periodos'] as List<dynamic>;
    return list.map((e) => PeriodoRegistroMallaItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PeriodoRegistroMallaItem> createPeriodo({
    required String descripcion,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final body = <String, dynamic>{
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio.toIso8601String().substring(0, 10),
      'fecha_fin': fechaFin.toIso8601String().substring(0, 10),
    };
    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.periodosRegistroMalla, data: body);
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    return PeriodoRegistroMallaItem.fromJson(response.data!);
  }

  Future<PeriodoRegistroMallaItem> activar(int id) async {
    final response = await _dio.patch<Map<String, dynamic>>(ApiEndpoints.periodoRegistroMallaActivar(id));
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    return PeriodoRegistroMallaItem.fromJson(response.data!);
  }

  Future<PeriodoRegistroMallaItem> desactivar(int id) async {
    final response = await _dio.patch<Map<String, dynamic>>(ApiEndpoints.periodoRegistroMallaDesactivar(id));
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    return PeriodoRegistroMallaItem.fromJson(response.data!);
  }
}
