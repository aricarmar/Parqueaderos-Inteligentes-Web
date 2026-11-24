/// Guardar, abrir y compartir los reportes (PDF, Excel y CSV).
///
/// Cada plataforma usa su propia implementación con la misma interfaz:
///  * Windows, Android e iOS: `files_io.dart` (guarda el archivo en el dispositivo).
///  * Web: `files_web.dart` (el navegador descarga el archivo).
library;

export 'files_io.dart' if (dart.library.js_interop) 'files_web.dart';
