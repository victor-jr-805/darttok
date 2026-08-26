// domain/datasources/video_posts_datasource.dart

import 'package:darttok/domain/entities/video_post.dart';

// Contrato abstracto: define QUE puede hacer un datasource de videos,
// sin decir COMO. Cualquier calse que los implemente puede traer los
// datos de donde quiera: el resto de la app no nota la diferencia.
abstract class VideoPostsDatasource {
  // Trae una pagina de videos.
  // "page" y "perPage" controlan la pagincacion (el Modulo 11
  // los usa de verdad; por ahora son parte del contrato).
  Future<List<VideoPost>> getPopularVideos({int page = 1, int perPage = 20});
}
