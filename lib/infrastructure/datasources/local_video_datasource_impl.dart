// infrastructure/datasources/local_video_datasource_impl.dart

import 'package:darttok/domain/datasources/video_posts_datasource.dart';
import 'package:darttok/domain/entities/video_post.dart';
import 'package:darttok/shared/data/local_video_posts.dart';

// Implementacion local: no llama a ninguna API, siempre devuelve la
// misma lista fija. Sirve para (1) tests que no dependen de internet
// ni de una API key, y (2) un posible respaldo si Pixabay no responde.
class LocalVideoDatasourceImpl implements VideoPostsDatasource {
  @override
  Future<List<VideoPost>> getPopularVideos({
    int page = 1,
    int perPage = 20,
  }) async {
    // No hay JSON que parsear: los datos ya son Dart puro, asi que
    // devlovemos las entidades directamente, sin necesitar un Model.
    return localVideoPosts;
  }
}
