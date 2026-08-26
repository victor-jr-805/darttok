// domain/errors/video_posts_exception.dart

// Excepcion propia del dominio para errores al obtener videos, sin
// importar si la causa real fue Dio, un archivo local, etc.
// Gracias a esto, Provider y las pantallas solo van a conocer ESTA
// clase, nunca DioExeption ni ningun detalle de Infraestructure.
class VideoPostsException implements Exception {
  // Mensaje legible, pensado para eventualmente mostrarse al usuario.
  final String message;

  const VideoPostsException(this.message);

  @override
  String toString() => 'VideoPostsException: $message';
}
