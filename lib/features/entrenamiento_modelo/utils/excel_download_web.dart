import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// En web: dispara la descarga del Excel mediante un blob.
String? saveExcel(Uint8List bytes, String filename) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(
        type:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;
  anchor.click();
  Future.delayed(const Duration(seconds: 3), () {
    web.URL.revokeObjectURL(url);
  });
  return null;
}
