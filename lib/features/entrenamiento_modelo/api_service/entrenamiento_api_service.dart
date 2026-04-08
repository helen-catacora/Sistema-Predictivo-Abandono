import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../data/models/entrenamiento_estado_response.dart';
import '../data/models/entrenamiento_historial_item.dart';
import '../data/models/modelo_actual_response.dart';

/// Servicio HTTP para endpoints de entrenamiento del modelo ML.
class EntrenamientoApiService {
  EntrenamientoApiService() : _dio = DioClient.instance;

  final Dio _dio;

  /// POST /entrenamiento/iniciar — Sube Excel y lanza entrenamiento.
  /// Retorna {entrenamiento_id, estado, mensaje}.
  Future<Map<String, dynamic>> iniciarEntrenamiento(PlatformFile file) async {
    final MultipartFile multipartFile;
    if (file.bytes != null && file.bytes!.isNotEmpty) {
      multipartFile = MultipartFile.fromBytes(file.bytes!, filename: file.name);
    } else if (file.path != null && file.path!.isNotEmpty) {
      multipartFile = await MultipartFile.fromFile(file.path!, filename: file.name);
    } else {
      throw ArgumentError('El archivo no tiene datos (path o bytes)');
    }

    final formData = FormData.fromMap(<String, dynamic>{'archivo': multipartFile});
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.entrenamientoIniciar,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );
    return response.data!;
  }

  /// GET /entrenamiento/{id}/estado — Polling del estado.
  Future<EntrenamientoEstadoResponse> getEstado(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.entrenamientoEstado(id),
    );
    return EntrenamientoEstadoResponse.fromJson(response.data!);
  }

  /// POST /entrenamiento/{id}/aceptar — Acepta el modelo candidato.
  Future<Map<String, dynamic>> aceptarModelo(int id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.entrenamientoAceptar(id),
    );
    return response.data!;
  }

  /// POST /entrenamiento/{id}/rechazar — Rechaza el modelo candidato.
  Future<void> rechazarModelo(int id) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.entrenamientoRechazar(id),
    );
  }

  /// GET /entrenamiento/historial — Lista de entrenamientos.
  Future<List<EntrenamientoHistorialItem>> getHistorial({int limite = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.entrenamientoHistorial,
      queryParameters: {'limite': limite},
    );
    final data = response.data!;
    final list = data['entrenamientos'] as List;
    return list
        .map((e) => EntrenamientoHistorialItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /entrenamiento/modelo-actual — Info del modelo en producción.
  Future<ModeloActualResponse> getModeloActual() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.entrenamientoModeloActual,
    );
    return ModeloActualResponse.fromJson(response.data!);
  }

  /// GET /entrenamiento/plantilla — Descarga plantilla Excel como bytes.
  Future<List<int>> descargarPlantilla() async {
    final response = await _dio.get<List<int>>(
      ApiEndpoints.entrenamientoPlantilla,
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!;
  }
}
