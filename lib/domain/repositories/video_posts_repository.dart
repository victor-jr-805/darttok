// domain/repositories/video_posts_repository.dart

import 'package:darttok/domain/entities/video_post.dart';

// Contrato que va a usar Presentation (el Provider del Modulo 9).
// No expone nada de Infraestructure: ni Dio, ni cuantos
// datasources hay detras, ni la politica de fallback.
// Solo "dame una pagina de videos".
abstract class VideoPostsRepository {
  Future<List<VideoPost>> getPopularVideos({int page = 1, int perPage = 20});
}
