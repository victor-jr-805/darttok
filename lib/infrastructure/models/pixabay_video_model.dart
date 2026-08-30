// infrastructure/models/pixabay_video_model.dart

// MODELO
// Representa la forma en la que Pixabay entrega un video.
// A diferencia del primer intento, aquí asumimos que cualquier campo
// puede venir nulo, vacío o con un tipo inesperado.
import 'package:darttok/domain/entities/video_post.dart';

class PixabayVideoModel {
  final int id;
  final String name;
  final String videoUrl;
  final int likes;
  final int views;

  PixabayVideoModel({
    required this.id,
    required this.name,
    required this.videoUrl,
    required this.likes,
    required this.views,
  });

  // Constructor nombrado: arma el modelo desde un elemento de "hits".
  // Devuelve null si falta algo indispensable (id o una URL de video
  // usable) en vez de lanzar una excepcion: preferimos saltarnos
  // UN video defectuoso a tumbar la pagina completa de 20.
  static PixabayVideoModel? tryFromJson(Map<String, dynamic> json) {
    // "id" es indispensable: sin el no podemos evitar duplicados al
    // paginar (modulo 11). Si falta, descartamos el video.
    final id = json['id'];
    if (id is! int) {
      return null;
    }

    // Buscamos una URL de video utilizable, con un orden de preferencia.
    // Si "medium" no viene o viene vacio, provamos con las otras calidades
    // antes de rendirnos.
    final videoUrl = _pickBestVideoUrl(json['videos']);
    if (videoUrl == null) {
      return null;
    }
    return PixabayVideoModel(
      id: id,
      // "name " es solo texto de presentacion: si falta, no descartamos
      // el video entero, mostramos un texto por defecto.
      name: json['name'] ?? 'Sin descripción',
      videoUrl: videoUrl,
      // "as num?" acepta tanto int como double antes de convertir a int.
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
    );
  }

  // recorre las calidades de video en orden de preferencia y devuelve
  // la primera URL no vacia que encuentre. Devuelve null si ninguna
  // calidad tiene una URL usable.
  static String? _pickBestVideoUrl(dynamic videos) {
    if (videos is! Map) {
      return null;
    }
    const preferredQualities = ['medium', 'small', 'large', 'tiny'];
    for (final quality in preferredQualities) {
      final url = videos[quality]?['url'];
      if (url is String && url.isNotEmpty) {
        return url;
      }
    }
    return null;
  }

  // MAPPER
  // Unica tarea: transformar este modelo en la entidad de dominio.
  VideoPost toVideoPostEntity() => VideoPost(
    id: id,
    caption: name,
    videoUrl: videoUrl,
    likes: likes,
    views: views,
  );
}
