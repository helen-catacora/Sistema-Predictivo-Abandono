import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/periodo_registro_malla_item.dart';
import '../../repositories/periodos_registro_malla_repository.dart';

enum PeriodosRegistroMallaStatus { initial, loading, success, error }

class PeriodosRegistroMallaProvider extends ChangeNotifier {
  PeriodosRegistroMallaProvider({PeriodosRegistroMallaRepository? repository})
      : _repository = repository ?? PeriodosRegistroMallaRepository();

  final PeriodosRegistroMallaRepository _repository;

  PeriodosRegistroMallaStatus _status = PeriodosRegistroMallaStatus.initial;
  List<PeriodoRegistroMallaItem> _periodos = [];
  String? _errorMessage;
  bool _isCreating = false;
  bool _isUpdating = false;

  PeriodosRegistroMallaStatus get status => _status;
  List<PeriodoRegistroMallaItem> get periodos => List.unmodifiable(_periodos);
  String? get errorMessage => _errorMessage;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;

  Future<void> loadPeriodos() async {
    if (_status == PeriodosRegistroMallaStatus.loading) return;
    _status = PeriodosRegistroMallaStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _periodos = await _repository.getPeriodos();
      _status = PeriodosRegistroMallaStatus.success;
    } on DioException catch (e) {
      _status = PeriodosRegistroMallaStatus.error;
      _errorMessage = _extractError(e);
    } catch (_) {
      _status = PeriodosRegistroMallaStatus.error;
      _errorMessage = 'Error al cargar períodos de registro';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> crearPeriodo({
    required String descripcion,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    _isCreating = true;
    notifyListeners();
    try {
      await _repository.createPeriodo(
        descripcion: descripcion,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
      await loadPeriodos();
      return true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al crear período';
      notifyListeners();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<bool> activar(int id) async {
    _isUpdating = true;
    notifyListeners();
    try {
      await _repository.activar(id);
      await loadPeriodos();
      return true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al activar período';
      notifyListeners();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> desactivar(int id) async {
    _isUpdating = true;
    notifyListeners();
    try {
      await _repository.desactivar(id);
      await loadPeriodos();
      return true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al cerrar período';
      notifyListeners();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      return data['detail']?.toString() ?? data['message']?.toString() ?? e.message ?? 'Error desconocido';
    }
    return e.message ?? 'Error desconocido';
  }
}
