import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/importacion_estudiantes_response.dart';
import '../../data/models/resumen_importaciones_response.dart';
import '../../repositories/estudiantes_importar_repository.dart';

/// Provider para la importación de estudiantes (POST /estudiantes/importar).
class ImportarEstudiantesProvider extends ChangeNotifier {
  ImportarEstudiantesProvider({
    EstudiantesImportarRepository? repository,
  }) : _repository = repository ?? EstudiantesImportarRepository();

  final EstudiantesImportarRepository _repository;

  bool _isImporting = false;
  String? _errorMessage;
  ImportacionEstudiantesResponse? _lastResponse;
  bool _isLoadingResumen = false;
  ResumenImportacionesResponse? _resumenImportaciones;

  bool get isImporting => _isImporting;
  String? get errorMessage => _errorMessage;
  ImportacionEstudiantesResponse? get lastResponse => _lastResponse;
  bool get isLoadingResumen => _isLoadingResumen;
  ResumenImportacionesResponse? get resumenImportaciones =>
      _resumenImportaciones;

  /// Envía el archivo .xlsx al endpoint de importación de estudiantes.
  /// Devuelve la respuesta si tuvo éxito, null si hubo error (y actualiza errorMessage).
  Future<ImportacionEstudiantesResponse?> enviarArchivo(PlatformFile file) async {
    if (file.bytes == null && (file.path == null || file.path!.isEmpty)) {
      _errorMessage = 'No se pudo leer el archivo';
      notifyListeners();
      return null;
    }

    _isImporting = true;
    _errorMessage = null;
    _lastResponse = null;
    notifyListeners();

    try {
      final response = await _repository.enviarArchivo(file);
      _isImporting = false;
      _errorMessage = null;
      _lastResponse = response;
      await loadResumenImportaciones();
      notifyListeners();
      return response;
    } catch (e, st) {
      debugPrint('ImportarEstudiantesProvider.enviarArchivo error: $e\n$st');
      _isImporting = false;
      _lastResponse = null;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          final detail = data['detail'];
          if (detail is String) {
            msg = detail;
          } else if (detail is List && detail.isNotEmpty && detail[0] is Map) {
            msg = (detail[0] as Map)['msg']?.toString();
          }
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al importar. Intente de nuevo.';
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Carga el resumen de importaciones de estudiantes.
  /// GET /estudiantes/resumen-importaciones
  Future<void> loadResumenImportaciones() async {
    _isLoadingResumen = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _resumenImportaciones =
          await _repository.getResumenImportaciones();
      _isLoadingResumen = false;
    } catch (e, st) {
      debugPrint(
          'ImportarEstudiantesProvider.loadResumenImportaciones error: $e\n$st');
      _isLoadingResumen = false;
      _resumenImportaciones = null;
    }
    notifyListeners();
  }
}
