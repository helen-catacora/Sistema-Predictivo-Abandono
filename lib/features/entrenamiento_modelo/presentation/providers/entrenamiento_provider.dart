import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/entrenamiento_estado_response.dart';
import '../../data/models/entrenamiento_historial_item.dart';
import '../../data/models/modelo_actual_response.dart';
import '../../repositories/entrenamiento_repository.dart';

/// Estados del flujo de entrenamiento.
enum EntrenamientoEstado {
  idle,
  uploading,
  training,
  comparing,
  accepting,
  rejecting,
  done,
  error,
}

/// Provider para entrenamiento/reentrenamiento del modelo ML.
class EntrenamientoProvider extends ChangeNotifier {
  EntrenamientoProvider({EntrenamientoRepository? repository})
      : _repository = repository ?? EntrenamientoRepository();

  final EntrenamientoRepository _repository;

  EntrenamientoEstado _estado = EntrenamientoEstado.idle;
  int? _entrenamientoId;
  String? _errorMessage;
  String? _successMessage;
  EntrenamientoEstadoResponse? _estadoResponse;
  ModeloActualResponse? _modeloActual;
  List<EntrenamientoHistorialItem> _historial = [];
  bool _isLoadingModeloActual = false;
  bool _isLoadingHistorial = false;
  Timer? _pollingTimer;

  // Getters
  EntrenamientoEstado get estado => _estado;
  int? get entrenamientoId => _entrenamientoId;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  EntrenamientoEstadoResponse? get estadoResponse => _estadoResponse;
  ModeloActualResponse? get modeloActual => _modeloActual;
  List<EntrenamientoHistorialItem> get historial => _historial;
  bool get isLoadingModeloActual => _isLoadingModeloActual;
  bool get isLoadingHistorial => _isLoadingHistorial;
  bool get isTraining =>
      _estado == EntrenamientoEstado.uploading ||
      _estado == EntrenamientoEstado.training;

  /// Carga la información del modelo actual.
  Future<void> loadModeloActual() async {
    if (_isLoadingModeloActual) return;
    _isLoadingModeloActual = true;
    notifyListeners();

    try {
      print('[EntrenamientoProvider] Cargando modelo actual...');
      _modeloActual = await _repository
          .getModeloActual()
          .timeout(const Duration(seconds: 15));
      print('[EntrenamientoProvider] Modelo actual cargado OK');
    } catch (e) {
      print('[EntrenamientoProvider] Error modelo actual: $e');
    } finally {
      _isLoadingModeloActual = false;
      notifyListeners();
      print('[EntrenamientoProvider] isLoadingModeloActual = false');
    }
  }

  /// Carga el historial de entrenamientos.
  Future<void> loadHistorial() async {
    if (_isLoadingHistorial) return;
    _isLoadingHistorial = true;
    notifyListeners();

    try {
      print('[EntrenamientoProvider] Cargando historial...');
      _historial = await _repository
          .getHistorial()
          .timeout(const Duration(seconds: 15));
      print(
          '[EntrenamientoProvider] Historial cargado OK: ${_historial.length} items');
    } catch (e) {
      print('[EntrenamientoProvider] Error historial: $e');
      _historial = [];
    } finally {
      _isLoadingHistorial = false;
      notifyListeners();
      print('[EntrenamientoProvider] isLoadingHistorial = false');
    }
  }

  /// Inicia el entrenamiento subiendo el archivo Excel.
  Future<bool> iniciarEntrenamiento(PlatformFile file) async {
    _estado = EntrenamientoEstado.uploading;
    _errorMessage = null;
    _successMessage = null;
    _estadoResponse = null;
    notifyListeners();

    try {
      final result = await _repository.iniciarEntrenamiento(file);
      _entrenamientoId = result['entrenamiento_id'] as int;
      _estado = EntrenamientoEstado.training;
      notifyListeners();

      // Iniciar polling
      _startPolling();
      return true;
    } catch (e) {
      _estado = EntrenamientoEstado.error;
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Acepta el modelo candidato (reemplaza el actual).
  Future<bool> aceptarModelo() async {
    if (_entrenamientoId == null) return false;

    _estado = EntrenamientoEstado.accepting;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.aceptarModelo(_entrenamientoId!);
      _estado = EntrenamientoEstado.done;
      _successMessage = result['mensaje'] as String? ?? 'Modelo reemplazado exitosamente.';
      notifyListeners();

      // Recargar modelo actual e historial
      await Future.wait([loadModeloActual(), loadHistorial()]);
      return true;
    } catch (e) {
      _estado = EntrenamientoEstado.error;
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Rechaza el modelo candidato.
  Future<bool> rechazarModelo() async {
    if (_entrenamientoId == null) return false;

    _estado = EntrenamientoEstado.rejecting;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.rechazarModelo(_entrenamientoId!);
      _estado = EntrenamientoEstado.done;
      _successMessage = 'Modelo candidato descartado. El modelo actual no fue modificado.';
      notifyListeners();

      await loadHistorial();
      return true;
    } catch (e) {
      _estado = EntrenamientoEstado.error;
      _errorMessage = _extractErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// Descarga la plantilla Excel.
  Future<List<int>?> descargarPlantilla() async {
    try {
      return await _repository.descargarPlantilla();
    } catch (e) {
      debugPrint('Error al descargar plantilla: $e');
      return null;
    }
  }

  /// Reinicia el estado para un nuevo entrenamiento.
  void reset() {
    _stopPolling();
    _estado = EntrenamientoEstado.idle;
    _entrenamientoId = null;
    _errorMessage = null;
    _successMessage = null;
    _estadoResponse = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // --- Polling ---

  void _startPolling() {
    _stopPolling();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _pollEstado();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _pollEstado() async {
    if (_entrenamientoId == null) {
      _stopPolling();
      return;
    }

    try {
      final response = await _repository.getEstado(_entrenamientoId!);
      _estadoResponse = response;

      if (response.estado == 'completado') {
        _stopPolling();
        _estado = EntrenamientoEstado.comparing;
        notifyListeners();
      } else if (response.estado == 'error') {
        _stopPolling();
        _estado = EntrenamientoEstado.error;
        _errorMessage = response.mensajeError ?? 'Error durante el entrenamiento.';
        notifyListeners();
      } else {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error en polling: $e');
    }
  }

  String _extractErrorMessage(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        return (data['detail'] ?? data['message'])?.toString() ??
            'Error de comunicación con el servidor.';
      }
      return e.message ?? 'Error de comunicación con el servidor.';
    }
    return e.toString();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
