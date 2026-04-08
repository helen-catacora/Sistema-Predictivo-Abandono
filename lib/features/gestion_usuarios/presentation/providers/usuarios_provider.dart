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
  String _searchQuery = '';
  String? _rolFilter;
  String? _estadoFilter;

  UsuariosStatus get status => _status;
  List<UsuarioItem> get usuarios => List.unmodifiable(_usuarios);
  List<UsuarioItem> get usuariosFiltrados => _applyFilters();
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == UsuariosStatus.loading;
  bool get hasError => _status == UsuariosStatus.error;
  String get searchQuery => _searchQuery;
  String? get rolFilter => _rolFilter;
  String? get estadoFilter => _estadoFilter;

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setRolFilter(String? r) {
    _rolFilter = r;
    notifyListeners();
  }

  void setEstadoFilter(String? e) {
    _estadoFilter = e;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _rolFilter = null;
    _estadoFilter = null;
    notifyListeners();
  }

  List<UsuarioItem> _applyFilters() {
    var result = List<UsuarioItem>.from(_usuarios);
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((u) =>
        u.nombre.toLowerCase().contains(q) ||
        u.correo.toLowerCase().contains(q) ||
        u.cargo.toLowerCase().contains(q)
      ).toList();
    }
    if (_rolFilter != null) {
      result = result.where((u) => u.rol == _rolFilter).toList();
    }
    if (_estadoFilter != null) {
      result = result.where((u) => u.estado.toLowerCase() == _estadoFilter).toList();
    }
    return result;
  }

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
