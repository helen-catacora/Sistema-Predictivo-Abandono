import 'dart:io';
import 'dart:typed_data';

/// Guarda el PDF en el directorio temporal (plataformas no web).
/// Devuelve la ruta del archivo para mostrar al usuario.
String? savePdf(Uint8List bytes, String filename) {
  final dir = Directory.systemTemp;
  final file = File('${dir.path}/$filename');
  file.writeAsBytesSync(bytes);
  return file.path;
}
