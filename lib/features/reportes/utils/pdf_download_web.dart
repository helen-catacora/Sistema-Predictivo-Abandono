import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// En web: dispara la descarga del PDF mediante un blob.
/// Usa package:web (compatible con dart2wasm, sustituye dart:html).
/// Devuelve null (la descarga la maneja el navegador).
String? savePdf(Uint8List bytes, String filename) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'application/pdf'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  // Revocar la URL después de un retraso; si se revoca de inmediato, la descarga puede fallar.
  Future.delayed(const Duration(seconds: 3), () {
    web.URL.revokeObjectURL(url);
  });
  return null;
}
