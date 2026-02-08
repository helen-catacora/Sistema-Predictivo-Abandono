import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';

import '../../repositories/predicciones_masiva_repository.dart';

/// Provider para la importación masiva (POST /predicciones/masiva).
class ImportarPrediccionesProvider extends ChangeNotifier {
  ImportarPrediccionesProvider({PrediccionesMasivaRepository? repository})
      : _repository = repository ?? PrediccionesMasivaRepository();

  final PrediccionesMasivaRepository _repository;

  bool _isImporting = false;
  String? _errorMessage;

  bool get isImporting => _isImporting;
  String? get errorMessage => _errorMessage;

  /// Envía el archivo xlsx al endpoint de predicción masiva.
  /// Devuelve true si tuvo éxito, false si hubo error (y actualiza errorMessage).
  Future<bool> enviarArchivo(PlatformFile file) async {
    if (file.bytes == null && (file.path == null || file.path!.isEmpty)) {
      _errorMessage = 'No se pudo leer el archivo';
      notifyListeners();
      return false;
    }

    _isImporting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.enviarArchivo(file);
      _isImporting = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e, st) {
      debugPrint('ImportarPrediccionesProvider.enviarArchivo error: $e\n$st');
      _isImporting = false;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          msg = (data['detail'] ?? data['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al importar. Intente de nuevo.';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
