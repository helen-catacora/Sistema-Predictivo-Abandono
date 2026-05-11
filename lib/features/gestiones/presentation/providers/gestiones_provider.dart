import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/gestion_item.dart';
import '../../repositories/gestiones_repository.dart';

enum GestionesStatus { initial, loading, success, error }

class GestionesProvider extends ChangeNotifier {
  GestionesProvider({GestionesRepository? repository})
      : _repository = repository ?? GestionesRepository();

  final GestionesRepository _repository;

  GestionesStatus _status = GestionesStatus.initial;
  List<GestionItem> _gestiones = [];
  String? _errorMessage;
  bool _isCreating = false;
  bool _isActivating = false;
  bool _isUpdatingVentana = false;

  GestionesStatus get status => _status;
  List<GestionItem> get gestiones => List.unmodifiable(_gestiones);
  String? get errorMessage => _errorMessage;
  bool get isCreating => _isCreating;
  bool get isActivating => _isActivating;
  bool get isUpdatingVentana => _isUpdatingVentana;

  Future<void> loadGestiones() async {
    if (_status == GestionesStatus.loading) return;
    _status = GestionesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _gestiones = await _repository.getGestiones();
      _status = GestionesStatus.success;
    } on DioException catch (e) {
      _status = GestionesStatus.error;
      _errorMessage = _extractError(e);
    } catch (e) {
      _status = GestionesStatus.error;
      _errorMessage = 'Error al cargar gestiones';
    } finally {
      notifyListeners();
    }
  }

  Future<bool> crearGestion({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    DateTime? fechaInicioRegistroEstudiantes,
    DateTime? fechaFinRegistroEstudiantes,
  }) async {
    _isCreating = true;
    notifyListeners();
    try {
      await _repository.createGestion(
        nombre: nombre,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        fechaInicioRegistroEstudiantes: fechaInicioRegistroEstudiantes,
        fechaFinRegistroEstudiantes: fechaFinRegistroEstudiantes,
      );
      await loadGestiones();
      return true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al crear gestión';
      notifyListeners();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  Future<bool> activarGestion(int id) async {
    _isActivating = true;
    notifyListeners();
    try {
      await _repository.activarGestion(id);
      await loadGestiones();
      return true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al activar gestión';
      notifyListeners();
      return false;
    } finally {
      _isActivating = false;
      notifyListeners();
    }
  }

  Future<bool> updateVentana({
    required int id,
    DateTime? fechaInicioRegistroEstudiantes,
    DateTime? fechaFinRegistroEstudiantes,
  }) async {
    _isUpdatingVentana = true;
    notifyListeners();
    try {
      await _repository.updateVentana(
        id: id,
        fechaInicioRegistroEstudiantes: fechaInicioRegistroEstudiantes,
        fechaFinRegistroEstudiantes: fechaFinRegistroEstudiantes,
      );
      await loadGestiones();
      return true;
    } on DioException catch (e) {
      _errorMessage = _extractError(e);
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Error al actualizar ventana';
      notifyListeners();
      return false;
    } finally {
      _isUpdatingVentana = false;
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
