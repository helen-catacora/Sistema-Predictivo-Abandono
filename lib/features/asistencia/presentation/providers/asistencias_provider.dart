import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/asistencia_dia_response.dart';
import '../../data/models/asistencia_item.dart';
import '../../data/models/asistencia_save_request.dart';
import '../../repositories/asistencias_repository.dart';
import '../widgets/attendance_status_selector.dart';

/// Estado de carga de asistencias.
enum AsistenciasStatus {
  initial,
  loading,
  success,
  error,
}

/// Item editable de asistencia para la tabla.
class EditableAsistencia {
  EditableAsistencia({
    required this.estudianteId,
    required this.nombreEstudiante,
    required this.codigoEstudiante,
    required this.estado,
    required this.observacion,
    required this.originalEstado,
    required this.originalObservacion,
  });

  final int estudianteId;
  final String nombreEstudiante;
  final String codigoEstudiante;
  String estado;
  String observacion;
  final String originalEstado;
  final String originalObservacion;

  bool get isModified =>
      estado != originalEstado || observacion != originalObservacion;
}

/// Provider de asistencias del día.
class AsistenciasProvider extends ChangeNotifier {
  AsistenciasProvider({AsistenciasRepository? repository})
      : _repository = repository ?? AsistenciasRepository();

  final AsistenciasRepository _repository;

  AsistenciasStatus _status = AsistenciasStatus.initial;
  AsistenciaDiaResponse? _data;
  String? _errorMessage;
  bool _isSaving = false;
  int? _lastMateriaId;
  int? _lastParaleloId;
  List<EditableAsistencia> _editableAsistencias = [];

  AsistenciasStatus get status => _status;
  AsistenciaDiaResponse? get data => _data;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AsistenciasStatus.loading;
  bool get hasError => _status == AsistenciasStatus.error;
  bool get hasData => _data != null;
  bool get isSaving => _isSaving;
  int? get lastMateriaId => _lastMateriaId;
  int? get lastParaleloId => _lastParaleloId;

  int get totalEstudiantes => _data?.totalEstudiantes ?? 0;
  int get totalPresentes => _data?.totalPresentes ?? 0;
  int get totalAusentes => _data?.totalAusentes ?? 0;
  double get porcentajeAsistenciaDia =>
      _data?.porcentajeAsistenciaDia ?? 0.0;

  /// Lista editable para la tabla (usa esta en lugar de asistencias para edición).
  List<EditableAsistencia> get editableAsistencias =>
      List.unmodifiable(_editableAsistencias);

  /// Para compatibilidad con tarjetas de resumen (datos originales).
  List<AsistenciaItem> get asistencias => _data?.asistencias ?? [];

  /// Carga las asistencias del día. Solo se ejecuta al pulsar "Aplicar Filtros".
  Future<void> loadAsistenciasDia({
    required int materiaId,
    required int paraleloId,
  }) async {
    _status = AsistenciasStatus.loading;
    _errorMessage = null;
    _data = null;
    _editableAsistencias = [];
    notifyListeners();

    try {
      _data = await _repository.getAsistenciasDia(
        materiaId: materiaId,
        paraleloId: paraleloId,
      );
      _lastMateriaId = materiaId;
      _lastParaleloId = paraleloId;
      _editableAsistencias = _data!.asistencias
          .map(
            (a) => EditableAsistencia(
              estudianteId: a.estudianteId,
              nombreEstudiante: a.nombreEstudiante,
              codigoEstudiante: a.codigoEstudiante,
              estado: a.estado,
              observacion: a.observacion,
              originalEstado: a.estado,
              originalObservacion: a.observacion,
            ),
          )
          .toList();
      _status = AsistenciasStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('AsistenciasProvider.loadAsistenciasDia error: $e\n$st');
      _status = AsistenciasStatus.error;
      String? msg;
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          msg = (responseData['detail'] ?? responseData['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar asistencias';
      _data = null;
      _editableAsistencias = [];
    }
    notifyListeners();
  }

  void updateEstatus(int index, AttendanceStatus? status) {
    if (index < 0 || index >= _editableAsistencias.length) return;
    _editableAsistencias[index].estado = _statusToApi(status);
    notifyListeners();
  }

  void updateObservacion(int index, String observacion) {
    if (index < 0 || index >= _editableAsistencias.length) return;
    _editableAsistencias[index].observacion = observacion;
    notifyListeners();
  }

  void markAllPresent() {
    for (final e in _editableAsistencias) {
      e.estado = _statusToApi(AttendanceStatus.presente);
    }
    notifyListeners();
  }

  void clearAll() {
    for (final e in _editableAsistencias) {
      e.estado = '';
      e.observacion = '';
    }
    notifyListeners();
  }

  String _statusToApi(AttendanceStatus? status) {
    if (status == null) return '';
    switch (status) {
      case AttendanceStatus.presente:
        return 'Presente';
      case AttendanceStatus.ausente:
        return 'Ausente';
      case AttendanceStatus.justificado:
        return 'Justificado';
    }
  }

  /// Lista de asistencias modificadas para enviar al POST.
  List<AsistenciaSaveItem> getModifiedForSave() {
    return _editableAsistencias
        .where((e) => e.isModified)
        .map(
          (e) => AsistenciaSaveItem(
            estudianteId: e.estudianteId,
            estado: e.estado,
            observacion: e.observacion,
          ),
        )
        .toList();
  }

  /// Guarda las asistencias modificadas. En éxito recarga los datos.
  Future<bool> saveAsistenciasDia() async {
    if (_lastMateriaId == null || _lastParaleloId == null) return false;
    final modified = getModifiedForSave();
    if (modified.isEmpty) return true;

    _isSaving = true;
    notifyListeners();

    try {
      await _repository.saveAsistenciasDia(
        materiaId: _lastMateriaId!,
        paraleloId: _lastParaleloId!,
        body: AsistenciaSaveRequest(asistencias: modified),
      );
      _isSaving = false;
      notifyListeners();
      await loadAsistenciasDia(
        materiaId: _lastMateriaId!,
        paraleloId: _lastParaleloId!,
      );
      return true;
    } catch (e, st) {
      debugPrint('AsistenciasProvider.saveAsistenciasDia error: $e\n$st');
      _isSaving = false;
      String? msg;
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map) {
          msg = (responseData['detail'] ?? responseData['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al guardar asistencias';
      notifyListeners();
      return false;
    }
  }
}
