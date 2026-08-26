// infrastructure/models/pixabay_video_model.dart

// MODELO
// Representa la forma en la que Pixabay entrega un video.
// Por ahora asumimos que el JSON Viene bien formado.
// En el modulo 5 lo hacemos mas defensivo.
import 'package:darttok/domain/entities/video_post.dart';

class PixabayVideoModel {
  final int id;
  final String name;
  final String mediumVideoUrl;
  final int likes;
  final int views;

  PixabayVideoModel({
    required this.id,
    required this.name,
    required this.mediumVideoUrl,
    required this.likes,
    required this.views,
  });

  // Constructor nombrado: arma el modelo desde un elemento de "hits".
  factory PixabayVideoModel.fromJson(Map<String, dynamic> json) {
    return PixabayVideoModel(
      id: json['id'],
      name: json['name'],
      mediumVideoUrl: json['videos']['medium']['url'],
      likes: json['likes'],
      views: json['views'],
    );
  }

  // MAPPER
  // Unica tarea: transformar este modelo en la entidad de dominio.
  VideoPost toVideoPostEntity() => VideoPost(
    id: id,
    caption: name,
    videoUrl: mediumVideoUrl,
    likes: likes,
    views: views,
  );
}
