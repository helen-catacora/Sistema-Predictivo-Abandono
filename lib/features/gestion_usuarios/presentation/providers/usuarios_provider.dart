import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/usuario_item.dart';
import '../../repositories/usuarios_repository.dart';

/// Estado de carga de usuarios.
enum UsuariosStatus {
  initial,
  loading,
  success,
  error,
}

/// Provider de la tabla de usuarios.
class UsuariosProvider extends ChangeNotifier {
  UsuariosProvider({UsuariosRepository? repository})
      : _repository = repository ?? UsuariosRepository();

  final UsuariosRepository _repository;

  UsuariosStatus _status = UsuariosStatus.initial;
  List<UsuarioItem> _usuarios = [];
  String? _errorMessage;

  UsuariosStatus get status => _status;
  List<UsuarioItem> get usuarios => List.unmodifiable(_usuarios);
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == UsuariosStatus.loading;
  bool get hasError => _status == UsuariosStatus.error;

  /// Carga los usuarios desde el backend.
  Future<void> loadUsuarios() async {
    _status = UsuariosStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _usuarios = await _repository.getUsuarios();
      _status = UsuariosStatus.success;
      _errorMessage = null;
    } catch (e, st) {
      debugPrint('UsuariosProvider.loadUsuarios error: $e\n$st');
      _status = UsuariosStatus.error;
      String? msg;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          msg = (data['detail'] ?? data['message'])?.toString();
        }
        msg ??= e.message;
      }
      _errorMessage = msg ?? 'Error al cargar usuarios';
      _usuarios = [];
    }
    notifyListeners();
  }
}
