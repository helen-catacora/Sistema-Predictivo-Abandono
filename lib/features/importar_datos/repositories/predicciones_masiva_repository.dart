import 'package:file_picker/file_picker.dart';

import '../api_service/predicciones_masiva_api_service.dart';

/// Repositorio para envío de predicción masiva (archivo xlsx).
class PrediccionesMasivaRepository {
  PrediccionesMasivaRepository({
    PrediccionesMasivaApiService? apiService,
  }) : _apiService = apiService ?? PrediccionesMasivaApiService();

  final PrediccionesMasivaApiService _apiService;

  Future<void> enviarArchivo(PlatformFile file) => _apiService.postMasiva(file);
}
