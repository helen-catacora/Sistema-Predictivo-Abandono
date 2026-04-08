import 'package:file_picker/file_picker.dart';

import '../api_service/entrenamiento_api_service.dart';
import '../data/models/entrenamiento_estado_response.dart';
import '../data/models/entrenamiento_historial_item.dart';
import '../data/models/modelo_actual_response.dart';

/// Repositorio para operaciones de entrenamiento del modelo ML.
class EntrenamientoRepository {
  EntrenamientoRepository({EntrenamientoApiService? apiService})
      : _apiService = apiService ?? EntrenamientoApiService();

  final EntrenamientoApiService _apiService;

  Future<Map<String, dynamic>> iniciarEntrenamiento(PlatformFile file) =>
      _apiService.iniciarEntrenamiento(file);

  Future<EntrenamientoEstadoResponse> getEstado(int id) =>
      _apiService.getEstado(id);

  Future<Map<String, dynamic>> aceptarModelo(int id) =>
      _apiService.aceptarModelo(id);

  Future<void> rechazarModelo(int id) => _apiService.rechazarModelo(id);

  Future<List<EntrenamientoHistorialItem>> getHistorial({int limite = 20}) =>
      _apiService.getHistorial(limite: limite);

  Future<ModeloActualResponse> getModeloActual() =>
      _apiService.getModeloActual();

  Future<List<int>> descargarPlantilla() => _apiService.descargarPlantilla();
}
