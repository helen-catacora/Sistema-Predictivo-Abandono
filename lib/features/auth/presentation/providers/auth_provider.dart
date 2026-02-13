import 'package:flutter/foundation.dart';
import '../../repositories/auth_repository.dart';

/// Estado del proceso de login.
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Provider de autenticación.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  int? _rolId;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int? get rolId => _rolId;
  bool get isAuthenticated => _repository.isLoggedIn;
  bool get isLoading => _status == AuthStatus.loading;

  /// Inicia sesión con email y contraseña.
  Future<bool> login({required String email, required String password}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.login(
        email: email.trim(),
        password: password,
      );
      _rolId = response.rolId;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e, st) {
      debugPrint('AuthProvider.login error: $e\n$st');
      _status = AuthStatus.error;
      _errorMessage = 'Error inesperado. Intente nuevamente.';
      notifyListeners();
      return false;
    }
  }

  /// Cierra sesión.
  Future<void> logout() async {
    await _repository.logout();
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    _rolId = null;
    notifyListeners();
  }

  /// Revisa si hay sesión guardada (al iniciar la app).
  void checkAuthStatus() {
    if (_repository.isLoggedIn) {
      _rolId = _repository.rolId;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Limpia el mensaje de error.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
