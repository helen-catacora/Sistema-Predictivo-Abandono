/// Respuesta del endpoint de login.
class LoginResponse {
  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.rolId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      rolId: json['rol_id'] as int,
    );
  }

  final String accessToken;
  final String tokenType;
  final int rolId;
}
