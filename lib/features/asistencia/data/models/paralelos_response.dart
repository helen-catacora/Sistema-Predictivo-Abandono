import 'paralelo_item.dart';

/// Respuesta del endpoint GET /paralelos.
class ParalelosResponse {
  ParalelosResponse({required this.paralelos});

  factory ParalelosResponse.fromJson(Map<String, dynamic> json) {
    final list = json['paralelos'] as List<dynamic>? ?? [];
    return ParalelosResponse(
      paralelos: list
          .map((e) => ParaleloItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<ParaleloItem> paralelos;
}
