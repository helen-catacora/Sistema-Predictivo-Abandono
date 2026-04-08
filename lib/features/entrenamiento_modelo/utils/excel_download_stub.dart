import 'dart:io';
import 'dart:typed_data';

/// Guarda el Excel en el directorio Downloads (plataformas no web).
String? saveExcel(Uint8List bytes, String filename) {
  final dir = Platform.environment['USERPROFILE'] ?? '.';
  final file = File('$dir/Downloads/$filename');
  file.writeAsBytesSync(bytes);
  return file.path;
}
