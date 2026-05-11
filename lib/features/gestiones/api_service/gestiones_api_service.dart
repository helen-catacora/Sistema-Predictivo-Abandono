import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/gestion_item.dart';

class GestionesApiService {
  GestionesApiService() : _dio = DioClient.instance;

  final Dio _dio;

  Future<List<GestionItem>> getGestiones() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.gestiones);
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    final list = response.data!['gestiones'] as List<dynamic>;
    return list.map((e) => GestionItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<GestionItem> createGestion({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    DateTime? fechaInicioRegistroEstudiantes,
    DateTime? fechaFinRegistroEstudiantes,
  }) async {
    final body = <String, dynamic>{
      'nombre': nombre,
      'fecha_inicio': fechaInicio.toIso8601String().substring(0, 10),
      'fecha_fin': fechaFin.toIso8601String().substring(0, 10),
      if (fechaInicioRegistroEstudiantes != null)
        'fecha_inicio_registro_estudiantes': fechaInicioRegistroEstudiantes.toIso8601String().substring(0, 10),
      if (fechaFinRegistroEstudiantes != null)
        'fecha_fin_registro_estudiantes': fechaFinRegistroEstudiantes.toIso8601String().substring(0, 10),
    };

    final response = await _dio.post<Map<String, dynamic>>(ApiEndpoints.gestiones, data: body);
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    return GestionItem.fromJson(response.data!);
  }

  Future<GestionItem> activarGestion(int id) async {
    final response = await _dio.patch<Map<String, dynamic>>(ApiEndpoints.gestionActivar(id));
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    return GestionItem.fromJson(response.data!);
  }

  Future<GestionItem> updateVentana({
    required int id,
    DateTime? fechaInicioRegistroEstudiantes,
    DateTime? fechaFinRegistroEstudiantes,
  }) async {
    final body = <String, dynamic>{
      'fecha_inicio_registro_estudiantes': fechaInicioRegistroEstudiantes?.toIso8601String().substring(0, 10),
      'fecha_fin_registro_estudiantes': fechaFinRegistroEstudiantes?.toIso8601String().substring(0, 10),
    };

    final response = await _dio.patch<Map<String, dynamic>>(ApiEndpoints.gestionVentana(id), data: body);
    if (response.data == null) {
      throw DioException(requestOptions: response.requestOptions, message: 'Respuesta vacía del servidor');
    }
    return GestionItem.fromJson(response.data!);
  }
}
