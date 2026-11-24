import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Archivo generado por la app (reporte) en la versión web.
class SavedFile {
  SavedFile(this.name, this.path, this._url);

  final String name;

  /// Texto que se muestra al usuario: en web el archivo queda en las descargas del navegador.
  final String path;

  /// Dirección interna (blob:) del archivo, para volver a abrirlo.
  final String _url;
}

/// Versión web: los reportes se descargan con el navegador y se pueden abrir en otra pestaña.
class AppFiles {
  static const _types = {
    'pdf': 'application/pdf',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'csv': 'text/csv;charset=utf-8',
  };

  /// Descarga el archivo con el nombre indicado.
  static Future<SavedFile> save(String name, List<int> bytes) async {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    final blob = web.Blob(
      <JSAny>[Uint8List.fromList(bytes).toJS].toJS,
      web.BlobPropertyBag(type: _types[ext] ?? 'application/octet-stream'),
    );
    final url = web.URL.createObjectURL(blob);
    final link = web.HTMLAnchorElement()
      ..href = url
      ..download = name;
    web.document.body?.append(link);
    link.click();
    link.remove();
    return SavedFile(name, 'Carpeta de descargas del navegador ($name)', url);
  }

  /// Abre el archivo en una pestaña nueva del navegador (los PDF se ven directamente).
  static Future<bool> open(SavedFile file) async {
    try {
      // Devuelve null si el navegador bloqueó la ventana emergente.
      return web.window.open(file._url, '_blank') != null;
    } catch (_) {
      return false;
    }
  }

  /// En el navegador no se usa el menú de compartir: el archivo ya quedó descargado.
  static Future<void> share(SavedFile file, {String? text}) async {}

  static bool get canShare => false;
}
