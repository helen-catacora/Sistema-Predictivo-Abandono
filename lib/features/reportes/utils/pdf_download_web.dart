// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// En web: dispara la descarga del PDF mediante un blob.
/// Devuelve null (la descarga la maneja el navegador).
String? savePdf(Uint8List bytes, String filename) {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  html.Url.revokeObjectUrl(url);
  return null;
}
