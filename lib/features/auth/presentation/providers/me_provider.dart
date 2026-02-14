import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/me_response.dart';
import '../../repositories/auth_repository.dart';

/// Estado de carga del usuario actual (GET /me).
enum MeStatus { initial, loading, success, error }

/// Provider del usuario actual en sesión (GET /me).
/// Expone [me] y [modulos] para control de acceso en sidebar y otras vistas.
class MeProvider extends ChangeNotifier {
  MeProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  MeStatus _status = MeStatus.initial;
  MeResponse? _me;
  String? _errorMessage;

  MeStatus get status => _status;
  MeResponse? get me => _me;
  List<String> get modulos => _me?.modulos ?? [];
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == MeStatus.loading;
  bool get hasError => _status == MeStatus.error;

  /// Carga los datos del usuario actual (incluye módulos a los que tiene acceso).
  Future<void> loadMe() async {
    _status = MeStatus.loading;
    _errorMessage = null;
    _me = null;
    notifyListeners();

    try {
      _me = await _repository.getMe();
      _status = MeStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('MeProvider.loadMe error: $e\n$st');
      _status = MeStatus.error;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          msg = (data['detail'] ?? data['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar perfil';
      _me = null;
    }
    notifyListeners();
  }

  /// Limpia el estado (p. ej. al cerrar sesión).
  void clear() {
    _status = MeStatus.initial;
    _me = null;
    _errorMessage = null;
    notifyListeners();
  }
}
