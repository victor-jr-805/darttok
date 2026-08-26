// domain/entities/video_post.dart

// Representa un video dentro de la app, sin importar si vino de la API
// de Pixabay ode los assets locales - esa decision no le pertenece el dominio,
// vive en la capa Infraestructure.
class VideoPost {
  // Identificador unico del video
  // Nos sirve para evitar duplicados al paginar y como Key en la UI.
  final int id;

  // Texto que se muestra sobre el video (en Pixabay viene del campo "name").
  final String caption;

  // URL directa al archivo .mp4 que reproducira video_player.
  final String videoUrl;

  // Cantidad de "me gusta". Por defecto 0 si la fuente no lo trae.
  final int likes;

  // Cantidad de vistas. Por defecto 0 si la fuente no lo trae.
  final int views;

  // Constructor con parametros nombrados.
  // "id", "caption" y "videoUrl" son obligatorios: sin ellos
  // el video no se puede identificar ni reproducir.
  // "likes" y "views" son solo datos de visualizacion, por
  // eso tienen un valor por defecto y la app puede mostrar el video aunque falten.
  VideoPost({
    required this.id,
    required this.caption,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
  });
}
