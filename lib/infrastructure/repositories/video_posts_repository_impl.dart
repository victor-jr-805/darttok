// infrastructure/repositories/video_posts_repository_impl.dart

import 'package:darttok/domain/datasources/video_posts_datasource.dart';
import 'package:darttok/domain/entities/video_post.dart';
import 'package:darttok/domain/errors/video_posts_exception.dart';
import 'package:darttok/domain/repositories/video_posts_repository.dart';
import 'package:flutter/material.dart';

// Impletementacion concreta: orquesta un datasource
// remoto y uno local.
// Politica: intenta primero el remoto; si falla, cae al local
// para que la app nunca se quede completamente vacia.
class VideoPostsRepositoryImpl implements VideoPostsRepository {
  // Ambos datasources llegan por constructor (inyeccion de dependencias),
  // no se crean aqui adentro con "new" ni con imports directos.
  final VideoPostsDatasource remoteDatasource;
  final VideoPostsDatasource localDatasource;

  VideoPostsRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<VideoPost>> getPopularVideos({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      return await remoteDatasource.getPopularVideos(
        page: page,
        perPage: perPage,
      );
    } on VideoPostsException catch (e) {
      // No dejammos que el error tumbe la pantalla: avisamos
      // en consola (solo en modo debug) y devolvemos el respaldo local.
      debugPrint('⚠️ Falló Pixabay, usando datos locales de respaldo: $e');
      return localDatasource.getPopularVideos(page: page, perPage: perPage);
    }
  }
}
